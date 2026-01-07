#include "mlir/Analysis/DataFlow/ConstantPropagationAnalysis.h"
#include "mlir/Analysis/DataFlow/DeadCodeAnalysis.h"
#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Conversion/LLVMCommon/LoweringOptions.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/DLC/Transforms/DLCUtility.h"
#include "mlir/Dialect/DLC/Transforms/Passes.h"
#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/APFloat.h"
#include <iostream>
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/Builders.h"
namespace mlir {
#define GEN_PASS_DEF_DLCARITHLEGALIZER
#include "mlir/Dialect/DLC/Transforms/Passes.h.inc"
} // namespace mlir

#define DEBUG_TYPE "DLCArithLegalizer"

using namespace mlir;

static llvm::cl::opt<bool>
    EnableTaylorPattern("enable-taylor-pattern",
                        llvm::cl::desc("Enable Taylor Pattern for sin and cos"),
                        llvm::cl::init(true));
static llvm::cl::opt<bool> EnableBhaskaraPattern(
    "enable-bhaskara-pattern",
    llvm::cl::desc("Enable Bhaskara Pattern for sin and cos"),
    llvm::cl::init(false));
static llvm::cl::opt<bool> EnableQuadraticPattern(
    "enable-quadratic-pattern",
    llvm::cl::desc("Enable Quadratic Pattern for sin and cos"),
    llvm::cl::init(false));
static llvm::cl::opt<bool> EnablePreciseMulI(
    "enable-precise-muli-pattern",
    llvm::cl::desc("Enable Precise Pattern for Integer Multiplication"),
    llvm::cl::init(false));

namespace {

static Type getAdaptiveFloatType(Operation *op, PatternRewriter &rewriter) {
  Type orgTy = op->getResult(0).getType();
  Type elemTy = getElementTypeOrSelf(orgTy);
  if (elemTy.isInteger(32))
    elemTy = rewriter.getF32Type();
  if (elemTy.isInteger(16))
    elemTy = rewriter.getF16Type();
  if (isa<VectorType>(orgTy))
    return VectorType::get(cast<VectorType>(orgTy).getShape(), elemTy);
  return elemTy;
}

static Type getAdaptiveIntType(Operation *op, PatternRewriter &rewriter) {
  Type orgTy = op->getResult(0).getType();
  Type elemTy = getElementTypeOrSelf(orgTy);
  if (elemTy.isF32())
    elemTy = rewriter.getI32Type();
  if (elemTy.isF16() || elemTy.isBF16())
    elemTy = rewriter.getI16Type();
  if (isa<VectorType>(orgTy))
    return VectorType::get(cast<VectorType>(orgTy).getShape(), elemTy);
  return elemTy;
}

Value AdaptiveFloatConst(float val, Operation *op, PatternRewriter &rewriter) {
  Type targetType = getAdaptiveFloatType(op, rewriter);
  Type elemType = getElementTypeOrSelf(targetType);
  Location loc = op->getLoc();
  TypedAttr attr = rewriter.getFloatAttr(elemType, val);
  Value scalar = rewriter.create<arith::ConstantOp>(loc, attr);
  if (auto vecTy = dyn_cast<VectorType>(targetType)) {
    return rewriter.create<vector::SplatOp>(loc, vecTy, scalar);
  }
  return scalar;
}

Value AdaptiveIntConst(int val, Operation *op, PatternRewriter &rewriter) {
  Type targetType = getAdaptiveIntType(op, rewriter);
  Type elemType = getElementTypeOrSelf(targetType);
  Location loc = op->getLoc();
  TypedAttr attr = rewriter.getIntegerAttr(elemType, val);
  Value scalar = rewriter.create<arith::ConstantOp>(loc, attr);
  if (auto vecTy = dyn_cast<VectorType>(targetType)) {
    return rewriter.create<vector::SplatOp>(loc, vecTy, scalar);
  }
  return scalar;
}

Value InfOrNaNCheck(Value x, Operation *op, PatternRewriter &rewriter) {
  auto loc = op->getLoc();
  Type elemTy = getElementTypeOrSelf(op->getResult(0).getType());
  int mask;
  if (elemTy.isF16()) {
    mask = 0x7C00;
  } else if (elemTy.isBF16()) {
    mask = 0x7F80;
  } else {
    mask = 0x7F800000;
  }
  Value mask_exp = AdaptiveIntConst(mask, op, rewriter);
  Value x_bitview = rewriter.create<arith::BitcastOp>(
      loc, getAdaptiveIntType(op, rewriter), x);
  Value exponent = rewriter.create<arith::AndIOp>(loc, x_bitview, mask_exp);
  return rewriter.create<arith::CmpIOp>(loc, arith::CmpIPredicate::eq, exponent,
                                        mask_exp);
}

bool hasIndexOperand(Operation *op) {
  for (Value operand : op->getOperands()) {
    if (isa<IndexType>(operand.getType()))
      return true;
  }
  return false;
}

bool hasScalarOperand(Operation *op) {
  for (Value operand : op->getOperands()) {
    if (!isa<VectorType>(operand.getType()) &&
        !isa<ShapedType>(operand.getType()))
      return true;
  }
  return false;
}

//arith scalar operation
//result = select(isBadCase,manually_computed_value,addf(x, y))

struct AddIScalarPattern : public OpRewritePattern<arith::AddIOp> {
  AddIScalarPattern(MLIRContext *context, DataFlowSolver &s,PatternBenefit benefit = 1)
      : OpRewritePattern<arith::AddIOp>(context), solver(s) {}

  LogicalResult matchAndRewrite(arith::AddIOp op,PatternRewriter &rewriter) const override {
    if (op->getBlock()->getTerminator() == op)
      return failure();
    mlir::Type lhsTy = op.getLhs().getType();
    mlir::Type rhsTy = op.getRhs().getType();
    // 不能是 tensor
    if (llvm::isa<mlir::ShapedType>(lhsTy) || llvm::isa<mlir::ShapedType>(rhsTy))
      return failure();
    // 必须是 i32 scalar
    auto lhsIntTy = llvm::dyn_cast<mlir::IntegerType>(lhsTy);
    auto rhsIntTy = llvm::dyn_cast<mlir::IntegerType>(rhsTy);

    if (!lhsIntTy || !rhsIntTy)
      return failure();

    if (!lhsIntTy.isSignlessInteger(32) ||!rhsIntTy.isSignlessInteger(32))
      return failure();
    //设计算法完成正确的AddI
    rewriter.setInsertionPoint(op);
    Location loc = op.getLoc();
    Value x = op.getLhs();
    Value y = op.getRhs();

    Value sum=rewriter.create<arith::XOrIOp>(loc,x,y);
    Value carry=rewriter.create<arith::AndIOp>(loc,x,y);
    auto one=rewriter.create<arith::ConstantIntOp>(loc,1,32);
    carry=rewriter.create<arith::ShLIOp>(loc,carry,one);
    auto zero=rewriter.create<arith::ConstantIntOp>(loc,0,32);
    for (int i = 0; i < 32; ++i) {
      // carry == 0 ?
      auto isZero = rewriter.create<arith::CmpIOp>(
          loc, arith::CmpIPredicate::eq, carry, zero);
    
      // next_sum = sum XOR carry
      auto sum_xor = rewriter.create<arith::XOrIOp>(loc, sum, carry);
    
      // next_carry = (sum AND carry) << 1
      auto sum_and = rewriter.create<arith::AndIOp>(loc, sum, carry);
      auto carry_shl =
          rewriter.create<arith::ShLIOp>(loc, sum_and, one);
    
      // if carry == 0, keep sum, else update
      sum = rewriter.create<arith::SelectOp>(
          loc, isZero, sum, sum_xor);
    
      carry = rewriter.create<arith::SelectOp>(
          loc, isZero, zero, carry_shl);
    }
    //auto c = rewriter.create<arith::ConstantIntOp>(
      //op.getLoc(), 1234567, 32);
    //rewriter.replaceOp(op, c);
    rewriter.replaceOp(op,sum);    
  return success();
  }

private:
  DataFlowSolver &solver;
};

struct DivUIScalarPattern : public OpRewritePattern<arith::DivUIOp> {
  DivUIScalarPattern(MLIRContext *context, DataFlowSolver &s, PatternBenefit benefit = 1)
      : OpRewritePattern<arith::DivUIOp>(context), solver(s) {}

  LogicalResult matchAndRewrite(arith::DivUIOp op, PatternRewriter &rewriter) const override {
    // -----------------------
    // 基本检查
    // -----------------------
    if (op->getBlock()->getTerminator() == op)
      return failure();

    mlir::Type lhsTy = op.getLhs().getType();
    mlir::Type rhsTy = op.getRhs().getType();

    if (llvm::isa<mlir::ShapedType>(lhsTy) || llvm::isa<mlir::ShapedType>(rhsTy))
      return failure();

    auto lhsIntTy = llvm::dyn_cast<mlir::IntegerType>(lhsTy);
    auto rhsIntTy = llvm::dyn_cast<mlir::IntegerType>(rhsTy);

    if (!lhsIntTy || !rhsIntTy) return failure();
    if (!lhsIntTy.isSignlessInteger(32) || !rhsIntTy.isSignlessInteger(32))
      return failure();

    Location loc = op.getLoc();
    Value a = op.getLhs();
    Value b = op.getRhs();

    // -----------------------
    // 初始化常量
    // -----------------------
    auto zero = rewriter.create<arith::ConstantIntOp>(loc, 0, 32);
    auto one  = rewriter.create<arith::ConstantIntOp>(loc, 1, 32);

    // -----------------------
    // 特殊情况处理：b == 0 -> 返回 0
    // -----------------------
    auto bIsZero = rewriter.create<arith::CmpIOp>(loc, arith::CmpIPredicate::eq, b, zero);
    Value safeB = rewriter.create<arith::SelectOp>(loc, bIsZero, one, b);

    // -----------------------
    // 32-bit unsigned div bitwise loop
    // 模拟 long division
    // -----------------------
    Value quotient = zero;
    Value remainder = zero;

    for (int i = 31; i >= 0; --i) {
    // remainder <<= 1
    remainder = rewriter.create<arith::ShLIOp>(loc, remainder, one);

    // remainder |= (a >> i) & 1
    Value bit = rewriter.create<arith::ShRUIOp>(loc, a,
                     rewriter.create<arith::ConstantIntOp>(loc, i, 32));
    bit = rewriter.create<arith::AndIOp>(loc, bit, one);
    remainder = rewriter.create<arith::OrIOp>(loc, remainder, bit);

    // if remainder >= b then subtract and set quotient bit
    Value ge = rewriter.create<arith::CmpIOp>(loc, arith::CmpIPredicate::uge, remainder, safeB);
    Value newRemainder = rewriter.create<arith::SelectOp>(loc, ge,
                                 rewriter.create<arith::SubIOp>(loc, remainder, safeB),
                                 remainder);
    Value qBit = rewriter.create<arith::SelectOp>(loc, ge, one, zero);
    qBit = rewriter.create<arith::ShLIOp>(loc, qBit,
                   rewriter.create<arith::ConstantIntOp>(loc, i, 32));
    quotient = rewriter.create<arith::OrIOp>(loc, quotient, qBit);

    remainder = newRemainder;
}

    rewriter.replaceOp(op, quotient);
    return success();
  }

private:
  DataFlowSolver &solver;
};


struct RemSIScalarPattern : public OpRewritePattern<arith::RemSIOp> {
  RemSIScalarPattern(MLIRContext *context, DataFlowSolver &s,
                     PatternBenefit benefit = 1)
      : OpRewritePattern<arith::RemSIOp>(context), solver(s) {}

  LogicalResult matchAndRewrite(arith::RemSIOp op,
                                PatternRewriter &rewriter) const override {
    Location loc = op.getLoc();
    Value a = op.getLhs();
    Value b = op.getRhs();
    // 只匹配 scalar i32
    if (op->getBlock()->getTerminator() == op)
      return failure();
    mlir::Type lhsTy = op.getLhs().getType();
    mlir::Type rhsTy = op.getRhs().getType();
    // 不能是 tensor
    if (llvm::isa<mlir::ShapedType>(lhsTy) || llvm::isa<mlir::ShapedType>(rhsTy))
      return failure();
    // 必须是 i32 scalar
    auto lhsIntTy = llvm::dyn_cast<mlir::IntegerType>(lhsTy);
    auto rhsIntTy = llvm::dyn_cast<mlir::IntegerType>(rhsTy);

    if (!lhsIntTy || !rhsIntTy)
      return failure();

    if (!lhsIntTy.isSignlessInteger(32) ||!rhsIntTy.isSignlessInteger(32))
      return failure();

    // 创建 q/p/r
    Value q = rewriter.create<arith::DivSIOp>(loc, a, b);
    Value p = rewriter.create<arith::MulIOp>(loc, q, b);
    Value r = rewriter.create<arith::SubIOp>(loc, a, p);
    //auto s = rewriter.create<arith::ConstantIntOp>(loc, 5, 32);
    rewriter.replaceOp(op, r);
    return success();
  }

private:
  DataFlowSolver &solver;
};


struct MaximumFScalarPattern : public OpRewritePattern<arith::MaximumFOp> {
  MaximumFScalarPattern(MLIRContext *context, DataFlowSolver &s, PatternBenefit benefit = 1)
      : OpRewritePattern<arith::MaximumFOp>(context), solver(s) {}

  LogicalResult matchAndRewrite(arith::MaximumFOp op, PatternRewriter &rewriter) const override {
    // 不能是 terminator
    if (op->getBlock()->getTerminator() == op)
      return failure();

    mlir::Type lhsTy = op.getLhs().getType();
    mlir::Type rhsTy = op.getRhs().getType();

    // 不能是 tensor
    if (llvm::isa<mlir::ShapedType>(lhsTy) || llvm::isa<mlir::ShapedType>(rhsTy))
      return failure();

    // 必须是浮点 scalar
    auto lhsFloatTy = llvm::dyn_cast<mlir::FloatType>(lhsTy);
    auto rhsFloatTy = llvm::dyn_cast<mlir::FloatType>(rhsTy);
    if (!lhsFloatTy || !rhsFloatTy)
      return failure();

    if (lhsFloatTy.getWidth() != rhsFloatTy.getWidth())
      return failure();

    // 设置插入点
    rewriter.setInsertionPoint(op);
    Location loc = op.getLoc();
    Value lhs = op.getLhs();
    Value rhs = op.getRhs();

    // -------------------------------------
    // NaN 检查
    // 如果任意一方是 NaN，结果就是 NaN
    // -------------------------------------
    auto lhs_nan = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::UNO, lhs, lhs);
    auto rhs_nan = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::UNO, rhs, rhs);
    auto any_nan = rewriter.create<arith::OrIOp>(loc, lhs_nan, rhs_nan);

    // -------------------------------------
    // -0.0 和 +0.0 的特殊处理
    // 先判断 lhs > rhs
    auto lhs_gt_rhs = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OGT, lhs, rhs);
    // 再判断是否等于零，区别 ±0
    auto both_zero = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OEQ, lhs, rhs);
    auto lhs_sign = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OLT, lhs, rewriter.create<arith::ConstantOp>(loc, lhs.getType(), rewriter.getFloatAttr(lhsFloatTy, 0.0)));
    auto select_zero = rewriter.create<arith::SelectOp>(loc, lhs_sign, rhs, lhs); // 如果 lhs < 0 且两者为 0，返回 rhs(+0)
    
    // 综合比较，最大值选择
    auto max_val = rewriter.create<arith::SelectOp>(loc, lhs_gt_rhs, lhs, rhs);
    max_val = rewriter.create<arith::SelectOp>(loc, both_zero, select_zero, max_val);

    // 如果任意一方为 NaN，结果就是 NaN（保留原操作数 lhs 作为 NaN 载体）
    max_val = rewriter.create<arith::SelectOp>(loc, any_nan, lhs, max_val);

    // 替换原 op
    rewriter.replaceOp(op, max_val);

    return success();
  }

private:
  DataFlowSolver &solver;
};



struct MinimumFScalarPattern : public OpRewritePattern<arith::MinimumFOp> {
  MinimumFScalarPattern(MLIRContext *context, DataFlowSolver &s, PatternBenefit benefit = 1)
      : OpRewritePattern<arith::MinimumFOp>(context), solver(s) {}

  LogicalResult matchAndRewrite(arith::MinimumFOp op, PatternRewriter &rewriter) const override {
    // 不能是 terminator
    if (op->getBlock()->getTerminator() == op)
      return failure();

    mlir::Type lhsTy = op.getLhs().getType();
    mlir::Type rhsTy = op.getRhs().getType();

    // 不能是 tensor
    if (llvm::isa<mlir::ShapedType>(lhsTy) || llvm::isa<mlir::ShapedType>(rhsTy))
      return failure();

    // 必须是浮点 scalar
    auto lhsFloatTy = llvm::dyn_cast<mlir::FloatType>(lhsTy);
    auto rhsFloatTy = llvm::dyn_cast<mlir::FloatType>(rhsTy);
    if (!lhsFloatTy || !rhsFloatTy)
      return failure();

    if (lhsFloatTy.getWidth() != rhsFloatTy.getWidth())
      return failure();

    // 设置插入点
    rewriter.setInsertionPoint(op);
    Location loc = op.getLoc();
    Value lhs = op.getLhs();
    Value rhs = op.getRhs();

    // -------------------------------------
    // NaN 检查
    auto lhs_nan = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::UNO, lhs, lhs);
    auto rhs_nan = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::UNO, rhs, rhs);
    auto any_nan = rewriter.create<arith::OrIOp>(loc, lhs_nan, rhs_nan);

    // -------------------------------------
    // ±0 处理
    auto lhs_lt_rhs = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OLT, lhs, rhs);
    auto both_zero = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OEQ, lhs, rhs);
    auto lhs_sign = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OLT, lhs, rewriter.create<arith::ConstantOp>(loc, lhs.getType(), rewriter.getFloatAttr(lhsFloatTy, 0.0)));
    auto select_zero = rewriter.create<arith::SelectOp>(loc, lhs_sign, lhs, rhs); // 如果 lhs < 0 且两者为 0，返回 lhs(-0)

    // 综合比较
    auto min_val = rewriter.create<arith::SelectOp>(loc, lhs_lt_rhs, lhs, rhs);
    min_val = rewriter.create<arith::SelectOp>(loc, both_zero, select_zero, min_val);

    // NaN 优先
    min_val = rewriter.create<arith::SelectOp>(loc, any_nan, lhs, min_val);

    rewriter.replaceOp(op, min_val);

    return success();
  }

private:
  DataFlowSolver &solver;
};



struct SubIScalarPattern : public OpRewritePattern<arith::SubIOp> {
  SubIScalarPattern(MLIRContext *context,
                    DataFlowSolver &s,
                    PatternBenefit benefit = 1)
      : OpRewritePattern<arith::SubIOp>(context), solver(s) {}

  LogicalResult matchAndRewrite(arith::SubIOp op,
                                PatternRewriter &rewriter) const override {
    if (op->getBlock()->getTerminator() == op)
      return failure();

    Type lhsTy = op.getLhs().getType();
    Type rhsTy = op.getRhs().getType();

    if (llvm::isa<ShapedType>(lhsTy) || llvm::isa<ShapedType>(rhsTy))
      return failure();

    auto lhsIntTy = llvm::dyn_cast<IntegerType>(lhsTy);
    auto rhsIntTy = llvm::dyn_cast<IntegerType>(rhsTy);

    if (!lhsIntTy || !rhsIntTy)
      return failure();

    if (!lhsIntTy.isSignlessInteger(32) ||
        !rhsIntTy.isSignlessInteger(32))
      return failure();
    rewriter.setInsertionPoint(op);
    Location loc = op.getLoc();

    Value x = op.getLhs();
    Value y = op.getRhs();

    auto zero = rewriter.create<arith::ConstantIntOp>(loc, 0, 32);
    auto one  = rewriter.create<arith::ConstantIntOp>(loc, 1, 32);
    auto allOnes =
        rewriter.create<arith::ConstantIntOp>(loc, -1, 32);

    // diff = x ^ y
    Value diff = rewriter.create<arith::XOrIOp>(loc, x, y);

    // borrow = (~x) & y
    Value not_x =
        rewriter.create<arith::XOrIOp>(loc, x, allOnes);
    Value borrow =
        rewriter.create<arith::AndIOp>(loc, not_x, y);
    borrow = rewriter.create<arith::ShLIOp>(loc, borrow, one);

    for (int i = 0; i < 32; ++i) {
      auto isZero = rewriter.create<arith::CmpIOp>(
          loc, arith::CmpIPredicate::eq, borrow, zero);

      auto diff_xor =
          rewriter.create<arith::XOrIOp>(loc, diff, borrow);

      auto not_diff =
          rewriter.create<arith::XOrIOp>(loc, diff, allOnes);
      auto diff_and =
          rewriter.create<arith::AndIOp>(loc, not_diff, borrow);
      auto borrow_shl =
          rewriter.create<arith::ShLIOp>(loc, diff_and, one);

      diff = rewriter.create<arith::SelectOp>(
          loc, isZero, diff, diff_xor);

      borrow = rewriter.create<arith::SelectOp>(
          loc, isZero, zero, borrow_shl);
    }

    rewriter.replaceOp(op, diff);
    return success();
  }

private:
  DataFlowSolver &solver;
};







////////////////////////////////////////////////////////////////
//                         MathOp                             //
////////////////////////////////////////////////////////////////

// Find the minimal number of multiplications to compute x^p, where p is a
// positive integer. The problem is more complex than it seems. For example,
// x^15 (binary 1111) has these paths:
// 1 - 2 - 4 - 8
// |   |   |---| -12
// |   |-----------| -14
// |-------------------| -15
// But ternary approach (base 3) gives a shorter path:
// 1 - 2 - 3 - 6 - 9
//             |---| -15
// In theory, we should consider all prime bases < p to find the minimal steps.
// However, due to inverse operations (x^-1), we could also compute x^16 then
// multiply by x^-1. Since exponents are typically not very large, we simplify
// by only considering base 2 and 3.
Value getMinPathToIntPow(Operation *op, PatternRewriter &rewriter, int p,
                         Value x) {
  auto loc = op->getLoc();
  Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);

  auto createMul = [&](Value a, Value b) {
    return rewriter.create<arith::MulFOp>(loc, a, b);
  };

  auto binaryDecomposition = [&](Value &result) -> int {
    int step = 0;
    int exponent = p;

    if (exponent < 1) {
      return -1;
    }
    if (exponent == 1) {
      result = x;
      return 0;
    }

    Value expOf2 = x;
    result = float1;
    while (exponent) {
      if (exponent % 2) {
        result = createMul(result, expOf2);
        step++;
      }
      exponent >>= 1;
      if (exponent) {
        expOf2 = createMul(expOf2, expOf2);
        step++;
      }
    }
    return step;
  };

  auto ternaryDecomposition = [&](Value &result) -> int {
    int step = 0;
    int exponent = p;

    if (exponent < 1) {
      return -1;
    }
    if (exponent == 1) {
      result = x;
      return 0;
    }

    Value expOf3 = x;
    result = float1;
    while (exponent) {
      if (exponent % 3 == 1) {
        result = createMul(result, expOf3);
        step++;
      }
      Value exp2Of3 = createMul(expOf3, expOf3);
      if (exponent % 3 == 2) {
        result = createMul(result, exp2Of3);
        step++;
      }
      exponent /= 3;
      if (exponent) {
        expOf3 = createMul(expOf3, exp2Of3);
        step += 2;
      }
    }
    return step;
  };

  Value result2, result3;

  if (binaryDecomposition(result2) <= ternaryDecomposition(result3)) {
    return result2;
  } else {
    return result3;
  }
}

Value getXpowC(Operation *op, PatternRewriter &rewriter, int intC, float fractC,
               Value initBase, Value initExp) {
  bool isGeneralFrac = false;
  bool isGeneralInt = false;
  auto loc = op->getLoc();
  Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
  /// Handle fractional pow
  Value Root2Base;
  if (fractC == -0.5f) {
    Root2Base = rewriter.create<math::RsqrtOp>(loc, initBase); // latency:10
  } else if (fractC != 0.0f) {
    isGeneralFrac = true;
  }
  /// Handle integer pow
  // if it runs rsqrt faster than general case (latency:25), it's worthy to
  // be specialized.
  // the 2th param. in pow indicates the times of mulf that can be accepted.
  Value result;
  if (!isGeneralFrac) {
    if (fractC == 0.0f) {
      if (intC == 0) {
        return float1;
      } else if (intC > 0 && intC <= std::pow(2, 5))
        return getMinPathToIntPow(op, rewriter, intC, initBase);
      else if (intC < 0 && std::abs(intC) <= std::pow(2, 3)) {
        return rewriter.create<arith::DivFOp>(
            loc, float1,
            getMinPathToIntPow(op, rewriter, std::abs(intC), initBase));
      } else
        isGeneralInt = true;
    }
    if (fractC == -0.5f) {
      if (intC == 0)
        return Root2Base;
      if (intC > 0 && intC <= std::pow(2, 2))
        return rewriter.create<arith::MulFOp>(
            loc, getMinPathToIntPow(op, rewriter, intC, initBase), Root2Base);
      if (intC == -1) {
        Value recipBase = rewriter.create<arith::DivFOp>(loc, float1, initBase);
        return rewriter.create<arith::MulFOp>(loc, recipBase, Root2Base);
      } else {
        isGeneralInt = true;
      }
    }
  }
  if (isGeneralFrac || isGeneralInt) {
    // General case for fractional exponentiation
    Value log2InitBase =
        rewriter.create<math::Log2Op>(loc, initBase); // latency:10
    Value newExp =
        rewriter.create<arith::MulFOp>(loc, log2InitBase, initExp); // latency:5
    return rewriter.create<math::Exp2Op>(loc, newExp); // latency:10
  }
  return nullptr;
}

Value getCpowX(Operation *op, PatternRewriter &rewriter, float C,
               Value initExp) {
  auto loc = op->getLoc();
  if (C == 2.0f) {
    return rewriter.create<math::Exp2Op>(loc, initExp);
  } else {
    Value log2C = AdaptiveFloatConst(std::log2(C), op, rewriter);
    Value newExp = rewriter.create<arith::MulFOp>(loc, log2C, initExp);
    return rewriter.create<math::Exp2Op>(loc, newExp);
  }
}

template <typename OpTy>
struct F32OnlyRewritePattern : public OpRewritePattern<OpTy> {
  using OpRewritePattern<OpTy>::OpRewritePattern;

  LogicalResult matchAndRewrite(OpTy op,
                                PatternRewriter &rewriter) const final {
    if (!isa<Float32Type>(getElementTypeOrSelf(op.getResult()))) {
      return failure();
    }
    return matchAndRewriteF32(op, rewriter);
  }

  virtual LogicalResult matchAndRewriteF32(OpTy op,
                                           PatternRewriter &rewriter) const = 0;
};

struct PowFPattern : public F32OnlyRewritePattern<math::PowFOp> {
  PowFPattern(MLIRContext *context, DataFlowSolver &s)
      : F32OnlyRewritePattern<math::PowFOp>(context), solver(s) {}

  LogicalResult matchAndRewriteF32(math::PowFOp op,
                                   PatternRewriter &rewriter) const override {
    // exponent is const
    if (auto pow = op.getRhs().getDefiningOp<arith::ConstantOp>()) {
      auto resultType = op.getType();
      auto initExp = parseFloat(pow.getResult());
      float fractionalPart = 0.0;
      int intPart = 0;
      if (initExp) {
        // use ceil instead of floor to use rsqrt instead of sqrt
        fractionalPart = *initExp - std::ceil(*initExp);
        intPart = std::ceil(*initExp);
      } else {
        return failure();
      }
      if (initExp == 0.0f)
        return rewriter.notifyMatchFailure(
            op, "Unable to process X pow 0 temporarily.");
      rewriter.replaceOp(op, getXpowC(op, rewriter, intPart, fractionalPart,
                                      op.getLhs(), op.getRhs()));
      return success();
    }
    // base is constant
    if (auto base = op.getLhs().getDefiningOp<arith::ConstantOp>()) {
      if (auto baseValFloat = parseFloat(base.getResult())) {
        if (baseValFloat < 0) {
          return failure();
        }
        rewriter.replaceOp(op,
                           getCpowX(op, rewriter, *baseValFloat, op.getRhs()));
        return success();
      }
      return failure();
    }
    Location loc = op->getLoc();
    Value log2base = rewriter.create<math::Log2Op>(loc, op.getLhs());
    Value newExp = rewriter.create<arith::MulFOp>(loc, log2base, op.getRhs());
    rewriter.replaceOp(op, rewriter.create<math::Exp2Op>(loc, newExp));
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct FPowIPattern : public OpRewritePattern<math::FPowIOp> {
  FPowIPattern(MLIRContext *context, DataFlowSolver &s)
      : OpRewritePattern<math::FPowIOp>(context), solver(s) {}

  LogicalResult matchAndRewrite(math::FPowIOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getResult();
    Location loc = op.getLoc();

    Value newExp;
    if (auto initExp = op.getRhs().getDefiningOp<arith::ConstantOp>()) {
      auto initExpNum = parseInt(initExp.getResult());
      if (initExp) {
        float newExpValue = *initExpNum;
        newExp = AdaptiveFloatConst(newExpValue, op, rewriter);
      } else {
        return failure();
      }
    } else {
      newExp = rewriter.create<arith::SIToFPOp>(
          loc, getAdaptiveFloatType(op, rewriter), op.getRhs());
    }
    Value newPow = rewriter.create<math::PowFOp>(loc, op.getLhs(), newExp);
    rewriter.replaceOp(op, newPow);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct IPowIPattern : public OpRewritePattern<math::IPowIOp> {
  IPowIPattern(MLIRContext *context, DataFlowSolver &s)
      : OpRewritePattern<math::IPowIOp>(context), solver(s) {}

  LogicalResult matchAndRewrite(math::IPowIOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getResult();
    Location loc = op.getLoc();

    if (hasIndexOperand(op))
      return failure();

    Value newExp, newBase;
    if (auto initExp = op.getRhs().getDefiningOp<arith::ConstantOp>()) {
      auto initExpNum = parseInt(initExp.getResult());
      if (initExp) {
        float newExpValue = *initExpNum;
        newExp = AdaptiveFloatConst(newExpValue, op, rewriter);
      } else {
        return failure();
      }
    } else {
      newExp = rewriter.create<arith::SIToFPOp>(
          loc, getAdaptiveFloatType(op, rewriter), op.getRhs());
    }
    if (auto initBase = op.getLhs().getDefiningOp<arith::ConstantOp>()) {
      auto initBaseNum = parseInt(initBase.getResult());
      if (initBase) {
        float newBaseValue = *initBaseNum;
        newBase = AdaptiveFloatConst(newBaseValue, op, rewriter);
      } else {
        return failure();
      }
    } else {
      newBase = rewriter.create<arith::SIToFPOp>(
          loc, getAdaptiveFloatType(op, rewriter), op.getLhs());
    }
    Value newPow = rewriter.create<math::PowFOp>(loc, newBase, newExp);
    newPow = rewriter.create<arith::FPToSIOp>(
        loc, getAdaptiveIntType(op, rewriter), newPow);
    rewriter.replaceOp(op, newPow);
    return success();
  }

private:
  DataFlowSolver &solver;
};

// Sine = (4x*(π - |x|)) / π^2
// Cycle range: [-pi,pi]
// Max absolute error: 0.05601 at x = 0.15pi, 0.85pi
// Max relative error: ~0.27 at x = 0, ±pi
struct SinQuadraticPattern : public OpRewritePattern<math::SinOp> {
  SinQuadraticPattern(MLIRContext *context, DataFlowSolver &s,
                      PatternBenefit benefit = 1)
      : OpRewritePattern<math::SinOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(math::SinOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value pi = AdaptiveFloatConst(3.14159265f, op, rewriter);
    Value double_pi = AdaptiveFloatConst(6.28318531f, op, rewriter);
    Value float1_div_2pi = AdaptiveFloatConst(0.15915494f, op, rewriter);
    Value five_squared_pi = AdaptiveFloatConst(49.3480220f, op, rewriter);
    Value float4 = AdaptiveFloatConst(4.0f, op, rewriter);
    Value float4_div_pi_squared = AdaptiveFloatConst(0.4052847f, op, rewriter);
    Value float16 = AdaptiveFloatConst(16.0f, op, rewriter);

    // map x to [-pi, pi]
    Value cycleX = rewriter.create<arith::MulFOp>(loc, x, float1_div_2pi);
    Value round_cycleX = rewriter.create<math::RoundOp>(loc, cycleX);
    Value round_x =
        rewriter.create<arith::MulFOp>(loc, round_cycleX, double_pi);
    Value remain_x = rewriter.create<arith::SubFOp>(loc, x, round_x);

    // apply quadratic approximation
    Value abs_x = rewriter.create<math::AbsFOp>(loc, remain_x);
    Value pi_minus_abs_x = rewriter.create<arith::SubFOp>(loc, pi, abs_x);
    Value numerator =
        rewriter.create<arith::MulFOp>(loc, pi_minus_abs_x, remain_x);
    Value approxSin =
        rewriter.create<arith::MulFOp>(loc, numerator, float4_div_pi_squared);
    rewriter.replaceOp(op, approxSin);
    return success();
  }

private:
  DataFlowSolver &solver;
};

// Cos = (π^2 - 4x^2) / π^2
// Input range: [-pi/2, pi/2]
// Max absolute error: 0.05601 at x = N*pi + (0.5pi ± 0.15pi)
// Max relative error: ~0.27 at x = -3*pi/2, ±pi/2
struct CosQuadraticPattern : public OpRewritePattern<math::CosOp> {
  CosQuadraticPattern(MLIRContext *context, DataFlowSolver &s,
                      PatternBenefit benefit = 1)
      : OpRewritePattern<math::CosOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(math::CosOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    // map x to [-0.5pi, 1.5pi]
    Value pi = AdaptiveFloatConst(3.14159265f, op, rewriter);
    Value half_pi = AdaptiveFloatConst(1.570796327f, op, rewriter);
    Value double_pi = AdaptiveFloatConst(6.28318531f, op, rewriter);
    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);
    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
    Value float1_div_2pi = AdaptiveFloatConst(0.15915494f, op, rewriter);
    Value float4_div_pi_squared = AdaptiveFloatConst(0.4052847f, op, rewriter);

    Value cycleX = rewriter.create<arith::SubFOp>(loc, x, half_pi);
    cycleX = rewriter.create<arith::MulFOp>(loc, cycleX, float1_div_2pi);
    Value round_cycleX = rewriter.create<math::RoundOp>(loc, cycleX);
    Value round_x =
        rewriter.create<arith::MulFOp>(loc, round_cycleX, double_pi);
    Value remain_x = rewriter.create<arith::SubFOp>(loc, x, round_x);
    Value isGreat = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGT, remain_x, half_pi);
    remain_x = rewriter.create<arith::SelectOp>(
        loc, isGreat, rewriter.create<arith::SubFOp>(loc, pi, remain_x),
        remain_x);

    // apply quadratic approximation
    Value x_pow2 = rewriter.create<arith::MulFOp>(loc, remain_x, remain_x);
    Value term =
        rewriter.create<arith::MulFOp>(loc, x_pow2, float4_div_pi_squared);
    Value approxCos = rewriter.create<arith::SubFOp>(loc, float1, term);

    approxCos = rewriter.create<arith::SelectOp>(
        loc, isGreat, rewriter.create<arith::SubFOp>(loc, float0, approxCos),
        approxCos);
    rewriter.replaceOp(op, approxCos);
    return success();
  }

private:
  DataFlowSolver &solver;
};

// Sine = x - x^3/3! + x^5/5!
Value ApproxSin(Operation *op, PatternRewriter &rewriter, Value x) {
  auto loc = op->getLoc();

  Value recip_factorial3 = AdaptiveFloatConst(0.16666667f, op, rewriter);
  Value recip_factorial5 = AdaptiveFloatConst(0.00833333f, op, rewriter);
  Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);

  Value Xpow2 = rewriter.create<arith::MulFOp>(loc, x, x);
  Value approxSin =
      rewriter.create<arith::MulFOp>(loc, recip_factorial5, Xpow2);
  approxSin = rewriter.create<arith::SubFOp>(loc, approxSin, recip_factorial3);
  approxSin = rewriter.create<arith::MulFOp>(loc, approxSin, Xpow2);
  approxSin = rewriter.create<arith::AddFOp>(loc, approxSin, float1);
  approxSin = rewriter.create<arith::MulFOp>(loc, approxSin, x);
  return approxSin;
}

// Cos = 1 - x^2/2! + x^4/4!
Value ApproxCos(Operation *op, PatternRewriter &rewriter, Value x) {
  auto loc = op->getLoc();

  Value recip_factorial2 = AdaptiveFloatConst(0.5f, op, rewriter);
  Value recip_factorial4 = AdaptiveFloatConst(0.04166667f, op, rewriter);
  Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);

  Value Xpow2 = rewriter.create<arith::MulFOp>(loc, x, x);
  Value approxCos =
      rewriter.create<arith::MulFOp>(loc, Xpow2, recip_factorial4);
  approxCos = rewriter.create<arith::SubFOp>(loc, approxCos, recip_factorial2);
  approxCos = rewriter.create<arith::MulFOp>(loc, Xpow2, approxCos);
  approxCos = rewriter.create<arith::AddFOp>(loc, float1, approxCos);
  return approxCos;
}

// Sine = x - x^3/3! + x^5/5!          , x in [-0.25pi, 0.25pi]
// Cos = 1-(x-pi/2)^2/2!+(x-pi/2)^4/4! , x in [ 0.25pi, 0.75pi]
// Cycle range: [-0.25pi, 0.75pi]
// Max absolute error at ±pi/4
// Max relative error at ±pi/4, <0.0005
struct SinTaylorPattern : public F32OnlyRewritePattern<math::SinOp> {
  SinTaylorPattern(MLIRContext *context, DataFlowSolver &s,
                   PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::SinOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::SinOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    // map x to [-0.25pi, 1.75pi]
    Value pi = AdaptiveFloatConst(3.14159265f, op, rewriter);
    Value half_pi = AdaptiveFloatConst(1.570796327f, op, rewriter);
    Value three_quarter_pi = AdaptiveFloatConst(2.35619449f, op, rewriter);
    Value one_quarter_pi = AdaptiveFloatConst(0.78539816f, op, rewriter);
    Value double_pi = AdaptiveFloatConst(6.28318531f, op, rewriter);
    Value float1_div_2pi = AdaptiveFloatConst(0.15915494f, op, rewriter);
    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);

    Value cycleX = rewriter.create<arith::SubFOp>(loc, x, three_quarter_pi);
    cycleX = rewriter.create<arith::MulFOp>(loc, cycleX, float1_div_2pi);
    Value round_cycleX = rewriter.create<math::RoundOp>(loc, cycleX);
    Value round_x =
        rewriter.create<arith::MulFOp>(loc, round_cycleX, double_pi);
    Value remain_x = rewriter.create<arith::SubFOp>(loc, x, round_x);
    Value needInv = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGT, remain_x, three_quarter_pi);
    remain_x = rewriter.create<arith::SelectOp>(
        loc, needInv, rewriter.create<arith::SubFOp>(loc, remain_x, pi),
        remain_x);

    Value needCos = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGT, remain_x, one_quarter_pi);
    Value result = rewriter.create<arith::SelectOp>(
        loc, needCos,
        ApproxCos(op, rewriter,
                  rewriter.create<arith::SubFOp>(loc, remain_x, half_pi)),
        ApproxSin(op, rewriter, remain_x));
    result = rewriter.create<arith::SelectOp>(
        loc, needInv, rewriter.create<arith::SubFOp>(loc, float0, result),
        result);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

// Same as SinTaylor while only a pi/2 shift
struct CosTaylorPattern : public F32OnlyRewritePattern<math::CosOp> {
  CosTaylorPattern(MLIRContext *context, DataFlowSolver &s,
                   PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::CosOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::CosOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    // map x to [-0.25pi, 1.75pi]
    Value pi = AdaptiveFloatConst(3.14159265f, op, rewriter);
    Value half_pi = AdaptiveFloatConst(1.570796327f, op, rewriter);
    Value one_quarter_pi = AdaptiveFloatConst(0.78539816f, op, rewriter);
    Value neg_one_quarter_pi = AdaptiveFloatConst(-0.78539816f, op, rewriter);
    Value double_pi = AdaptiveFloatConst(6.28318531f, op, rewriter);
    Value float1_div_2pi = AdaptiveFloatConst(0.15915494f, op, rewriter);
    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);

    Value cycleX = rewriter.create<arith::SubFOp>(loc, x, one_quarter_pi);
    cycleX = rewriter.create<arith::MulFOp>(loc, cycleX, float1_div_2pi);
    Value round_cycleX = rewriter.create<math::RoundOp>(loc, cycleX);
    Value round_x =
        rewriter.create<arith::MulFOp>(loc, round_cycleX, double_pi);
    Value remain_x = rewriter.create<arith::SubFOp>(loc, x, round_x);
    Value needInv = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGT, remain_x, one_quarter_pi);
    remain_x = rewriter.create<arith::SelectOp>(
        loc, needInv, rewriter.create<arith::SubFOp>(loc, remain_x, pi),
        remain_x);

    Value needCos = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGT, remain_x, neg_one_quarter_pi);
    Value result = rewriter.create<arith::SelectOp>(
        loc, needCos, ApproxCos(op, rewriter, remain_x),
        ApproxSin(op, rewriter,
                  rewriter.create<arith::AddFOp>(loc, remain_x, half_pi)));
    result = rewriter.create<arith::SelectOp>(
        loc, needInv, rewriter.create<arith::SubFOp>(loc, float0, result),
        result);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

// Sine = 16x(pi-|x|)/(5pi^2-4|x|(pi-|x|))
// Cycle range: [-pi, pi]
// Max absolute error: 0.00163 at x = N*pi ± 0.064pi
// Max relative error: ~0.0187 at x = 0
struct SinBhaskaraPattern : public OpRewritePattern<math::SinOp> {
  SinBhaskaraPattern(MLIRContext *context, DataFlowSolver &s,
                     PatternBenefit benefit = 1)
      : OpRewritePattern<math::SinOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(math::SinOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value pi = AdaptiveFloatConst(3.14159265f, op, rewriter);
    Value double_pi = AdaptiveFloatConst(6.28318531f, op, rewriter);
    Value float1_div_2pi = AdaptiveFloatConst(0.15915494f, op, rewriter);
    Value five_squared_pi = AdaptiveFloatConst(49.3480220f, op, rewriter);
    Value float4 = AdaptiveFloatConst(4.0f, op, rewriter);
    Value float16 = AdaptiveFloatConst(16.0f, op, rewriter);

    // map x to [-pi, pi]
    Value cycleX = rewriter.create<arith::MulFOp>(loc, x, float1_div_2pi);
    Value round_cycleX = rewriter.create<math::RoundOp>(loc, cycleX);
    Value round_x =
        rewriter.create<arith::MulFOp>(loc, round_cycleX, double_pi);
    Value remain_x = rewriter.create<arith::SubFOp>(loc, x, round_x);

    // apply bhaskara
    Value abs_x = rewriter.create<math::AbsFOp>(loc, remain_x);
    Value pi_Minus_abs_x = rewriter.create<arith::SubFOp>(loc, pi, abs_x);
    Value x_times_pi_Minus_x =
        rewriter.create<arith::MulFOp>(loc, remain_x, pi_Minus_abs_x);
    Value numerator =
        rewriter.create<arith::MulFOp>(loc, float16, x_times_pi_Minus_x);
    Value abs_x_times_pi_Minus_x =
        rewriter.create<arith::MulFOp>(loc, abs_x, pi_Minus_abs_x);
    Value term =
        rewriter.create<arith::MulFOp>(loc, float4, abs_x_times_pi_Minus_x);
    Value denominator = rewriter.create<arith::SubFOp>(loc, five_squared_pi,
                                                       abs_x_times_pi_Minus_x);
    Value approxSin =
        rewriter.create<arith::DivFOp>(loc, numerator, denominator);
    rewriter.replaceOp(op, approxSin);
    return success();
  }

private:
  DataFlowSolver &solver;
};

// Cos = (π² - 4x²) / (π² + x²)
// Cycle range: [-pi/2, pi/2]
// Max absolute error: 0.00163 at x = N*pi + (pi/2 ± 0.064pi)
// Max relative error: ~0.0187 at x = N*pi + pi/2
struct CosBhaskaraPattern : public OpRewritePattern<math::CosOp> {
  CosBhaskaraPattern(MLIRContext *context, DataFlowSolver &s,
                     PatternBenefit benefit = 1)
      : OpRewritePattern<math::CosOp>(context, benefit), solver(s) {}
  LogicalResult matchAndRewrite(math::CosOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    // map x to [-0.5pi, 1.5pi]
    Value pi = AdaptiveFloatConst(3.14159265f, op, rewriter);
    Value half_pi = AdaptiveFloatConst(1.570796327f, op, rewriter);
    Value double_pi = AdaptiveFloatConst(6.28318531f, op, rewriter);
    Value pi_squared = AdaptiveFloatConst(9.86960440f, op, rewriter);
    Value float1_div_2pi = AdaptiveFloatConst(0.15915494f, op, rewriter);
    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);
    Value float4 = AdaptiveFloatConst(4.0f, op, rewriter);

    Value cycleX = rewriter.create<arith::SubFOp>(loc, x, half_pi);
    cycleX = rewriter.create<arith::MulFOp>(loc, cycleX, float1_div_2pi);
    Value round_cycleX = rewriter.create<math::RoundOp>(loc, cycleX);
    Value round_x =
        rewriter.create<arith::MulFOp>(loc, round_cycleX, double_pi);
    Value remain_x = rewriter.create<arith::SubFOp>(loc, x, round_x);
    Value isGreat = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGT, remain_x, half_pi);
    remain_x = rewriter.create<arith::SelectOp>(
        loc, isGreat, rewriter.create<arith::SubFOp>(loc, pi, remain_x),
        remain_x);

    // apply bhaskara
    Value xSquared = rewriter.create<arith::MulFOp>(loc, remain_x, remain_x);
    Value numerator = rewriter.create<arith::MulFOp>(loc, float4, xSquared);
    numerator = rewriter.create<arith::SubFOp>(loc, pi_squared, numerator);
    Value denominator =
        rewriter.create<arith::AddFOp>(loc, pi_squared, xSquared);
    Value approxCos =
        rewriter.create<arith::DivFOp>(loc, numerator, denominator);

    approxCos = rewriter.create<arith::SelectOp>(
        loc, isGreat, rewriter.create<arith::SubFOp>(loc, float0, approxCos),
        approxCos);
    rewriter.replaceOp(op, approxCos);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct TanPattern : public F32OnlyRewritePattern<math::TanOp> {
  TanPattern(MLIRContext *context, DataFlowSolver &s,
             PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::TanOp>(context, benefit), solver(s) {}
  LogicalResult matchAndRewriteF32(math::TanOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value Tan = rewriter.create<arith::DivFOp>(
        loc, rewriter.create<math::SinOp>(loc, x),
        rewriter.create<math::CosOp>(loc, x));
    rewriter.replaceOp(op, Tan);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct FloorPattern : public F32OnlyRewritePattern<math::FloorOp> {
  FloorPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::FloorOp>(context, benefit), solver(s) {}
  LogicalResult matchAndRewriteF32(math::FloorOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);
    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);

    Value isInfOrNaN = InfOrNaNCheck(x, op, rewriter);
    Value isPos = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OGE,
                                                 x, float0);
    Value trunc_x = rewriter.create<arith::FPToSIOp>(
        loc, getAdaptiveIntType(op, rewriter), x);
    trunc_x = rewriter.create<arith::SIToFPOp>(
        loc, getAdaptiveFloatType(op, rewriter), trunc_x);
    Value diff = rewriter.create<arith::SubFOp>(loc, x, trunc_x);
    Value hasFraction = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::ONE, diff, float0);
    Value floorVal = rewriter.create<arith::SelectOp>(
        loc, isPos, trunc_x,
        rewriter.create<arith::SubFOp>(loc, trunc_x, float1));
    floorVal = rewriter.create<arith::SelectOp>(loc, hasFraction, floorVal, x);
    Value result =
        rewriter.create<arith::SelectOp>(loc, isInfOrNaN, x, floorVal);

    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct CeilPattern : public F32OnlyRewritePattern<math::CeilOp> {
  CeilPattern(MLIRContext *context, DataFlowSolver &s,
              PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::CeilOp>(context, benefit), solver(s) {}
  LogicalResult matchAndRewriteF32(math::CeilOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);
    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);

    Value isInfOrNaN = InfOrNaNCheck(x, op, rewriter);
    Value isPos = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OGE,
                                                 x, float0);
    Value trunc_x = rewriter.create<arith::FPToSIOp>(
        loc, getAdaptiveIntType(op, rewriter), x);
    trunc_x = rewriter.create<arith::SIToFPOp>(
        loc, getAdaptiveFloatType(op, rewriter), trunc_x);
    Value diff = rewriter.create<arith::SubFOp>(loc, x, trunc_x);
    Value hasFraction = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::ONE, diff, float0);
    Value CeilVal = rewriter.create<arith::SelectOp>(
        loc, isPos, rewriter.create<arith::AddFOp>(loc, trunc_x, float1),
        trunc_x);
    CeilVal = rewriter.create<arith::SelectOp>(loc, hasFraction, CeilVal, x);
    Value result =
        rewriter.create<arith::SelectOp>(loc, isInfOrNaN, x, CeilVal);

    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct RoundPattern : public F32OnlyRewritePattern<math::RoundOp> {
  RoundPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::RoundOp>(context, benefit), solver(s) {}
  LogicalResult matchAndRewriteF32(math::RoundOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
    Value float_half = AdaptiveFloatConst(0.5f, op, rewriter);
    Value float_neg_half = AdaptiveFloatConst(-0.5f, op, rewriter);

    Value isInfOrNaN = InfOrNaNCheck(x, op, rewriter);
    Value trunc_x = rewriter.create<arith::FPToSIOp>(
        loc, getAdaptiveIntType(op, rewriter), x);
    trunc_x = rewriter.create<arith::SIToFPOp>(
        loc, getAdaptiveFloatType(op, rewriter), trunc_x);
    Value diff = rewriter.create<arith::SubFOp>(loc, x, trunc_x);
    // rounding halfway cases away from zero, regardless of the current rounding
    // direction.
    Value isLessThanNegHalf = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OLE, diff, float_neg_half);
    Value isGreaterThanHalf = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGE, diff, float_half);
    Value isForward = isGreaterThanHalf;
    Value isBackward = isLessThanNegHalf;
    Value RoundVal = rewriter.create<arith::SelectOp>(
        loc, isForward, rewriter.create<arith::AddFOp>(loc, trunc_x, float1),
        trunc_x);
    RoundVal = rewriter.create<arith::SelectOp>(
        loc, isBackward, rewriter.create<arith::SubFOp>(loc, trunc_x, float1),
        RoundVal);
    Value result =
        rewriter.create<arith::SelectOp>(loc, isInfOrNaN, x, RoundVal);

    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct TruncPattern : public F32OnlyRewritePattern<math::TruncOp> {
  TruncPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::TruncOp>(context, benefit), solver(s) {}
  LogicalResult matchAndRewriteF32(math::TruncOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value isInfOrNaN = InfOrNaNCheck(x, op, rewriter);
    Value trunc_x = rewriter.create<arith::FPToSIOp>(
        loc, getAdaptiveIntType(op, rewriter), x);
    trunc_x = rewriter.create<arith::SIToFPOp>(
        loc, getAdaptiveFloatType(op, rewriter), trunc_x);
    Value result = trunc_x;
    result = rewriter.create<arith::SelectOp>(loc, isInfOrNaN, x, result);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct RoundEvenPattern : public F32OnlyRewritePattern<math::RoundEvenOp> {
  RoundEvenPattern(MLIRContext *context, DataFlowSolver &s,
                   PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::RoundEvenOp>(context, benefit), solver(s) {}
  LogicalResult matchAndRewriteF32(math::RoundEvenOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
    Value float_half = AdaptiveFloatConst(0.5f, op, rewriter);
    Value float_neg_half = AdaptiveFloatConst(-0.5f, op, rewriter);
    Value int1 = AdaptiveIntConst(1, op, rewriter);

    Value isInfOrNaN = InfOrNaNCheck(x, op, rewriter);
    Value trunc_x_int = rewriter.create<arith::FPToSIOp>(
        loc, getAdaptiveIntType(op, rewriter), x);
    Value trunc_x_float = rewriter.create<arith::SIToFPOp>(
        loc, getAdaptiveFloatType(op, rewriter), trunc_x_int);
    Value diff = rewriter.create<arith::SubFOp>(loc, x, trunc_x_float);

    Value trunc_x_lsb = rewriter.create<arith::AndIOp>(loc, trunc_x_int, int1);
    Value isOdd = rewriter.create<arith::CmpIOp>(loc, arith::CmpIPredicate::eq,
                                                 trunc_x_lsb, int1);
    Value isExactHalf = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OEQ, diff, float_half);
    Value isExactNegHalf = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OEQ, diff, float_neg_half);
    Value isLessThanNegHalf = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OLT, diff, float_neg_half);
    Value isGreaterThanHalf = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGT, diff, float_half);

    Value isForward = rewriter.create<arith::OrIOp>(
        loc, isGreaterThanHalf,
        rewriter.create<arith::AndIOp>(loc, isExactHalf, isOdd));
    Value isBackward = rewriter.create<arith::OrIOp>(
        loc, isLessThanNegHalf,
        rewriter.create<arith::AndIOp>(loc, isExactNegHalf, isOdd));

    Value RoundVal = rewriter.create<arith::SelectOp>(
        loc, isForward,
        rewriter.create<arith::AddFOp>(loc, trunc_x_float, float1),
        trunc_x_float);
    RoundVal = rewriter.create<arith::SelectOp>(
        loc, isBackward,
        rewriter.create<arith::SubFOp>(loc, trunc_x_float, float1), RoundVal);
    Value result =
        rewriter.create<arith::SelectOp>(loc, isInfOrNaN, x, RoundVal);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct ErfPattern : public F32OnlyRewritePattern<math::ErfOp> {
  ErfPattern(MLIRContext *context, DataFlowSolver &s,
             PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::ErfOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::ErfOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value a1 = AdaptiveFloatConst(0.278393f, op, rewriter);
    Value a2 = AdaptiveFloatConst(0.230389f, op, rewriter);
    Value a3 = AdaptiveFloatConst(0.000972f, op, rewriter);
    Value a4 = AdaptiveFloatConst(0.079108f, op, rewriter);
    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
    Value float4 = AdaptiveFloatConst(4.0f, op, rewriter);

    Value AbsX = rewriter.create<math::AbsFOp>(loc, x);
    Value denominator = rewriter.create<arith::MulFOp>(loc, AbsX, a4);
    denominator = rewriter.create<arith::AddFOp>(loc, denominator, a3);
    denominator = rewriter.create<arith::MulFOp>(loc, denominator, AbsX);
    denominator = rewriter.create<arith::AddFOp>(loc, denominator, a2);
    denominator = rewriter.create<arith::MulFOp>(loc, denominator, AbsX);
    denominator = rewriter.create<arith::AddFOp>(loc, denominator, a1);
    denominator = rewriter.create<arith::MulFOp>(loc, denominator, AbsX);
    denominator = rewriter.create<arith::AddFOp>(loc, denominator, float1);
    denominator = rewriter.create<math::PowFOp>(loc, denominator, float4);
    Value result = rewriter.create<arith::DivFOp>(loc, float1, denominator);
    result = rewriter.create<arith::SubFOp>(loc, float1, result);
    result = rewriter.create<math::CopySignOp>(loc, result, x);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct AbsIPattern : public OpRewritePattern<math::AbsIOp> {
  AbsIPattern(MLIRContext *context, DataFlowSolver &s,
              PatternBenefit benefit = 1)
      : OpRewritePattern<math::AbsIOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(math::AbsIOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value shiftAmount = AdaptiveIntConst(31, op, rewriter);
    Value mask = rewriter.create<arith::ShRSIOp>(op.getLoc(), x, shiftAmount);
    Value xorVal = rewriter.create<arith::XOrIOp>(op.getLoc(), x, mask);
    Value abs = rewriter.create<arith::SubIOp>(op.getLoc(), xorVal, mask);
    rewriter.replaceOp(op, abs);
    return success();
  }

private:
  DataFlowSolver &solver;
};

// Max abs error: (0.868073, 0.00593)，Max relative error: (0.8078, 0.00594)
struct AsinPattern : public F32OnlyRewritePattern<math::AsinOp> {
  AsinPattern(MLIRContext *context, DataFlowSolver &s,
              PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::AsinOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::AsinOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
    Value float2 = AdaptiveFloatConst(2.0f, op, rewriter);
    Value p1 = AdaptiveFloatConst(-0.5858f, op, rewriter);
    Value p2 = AdaptiveFloatConst(0.0429f, op, rewriter);
    Value p3 = AdaptiveFloatConst(0.1149f, op, rewriter);
    Value q1 = AdaptiveFloatConst(0.5858f, op, rewriter);

    Value AbsX = rewriter.create<math::AbsFOp>(loc, x);

    Value P = rewriter.create<arith::MulFOp>(loc, AbsX, p3);
    P = rewriter.create<arith::AddFOp>(loc, P, p2);
    P = rewriter.create<arith::MulFOp>(loc, P, AbsX);
    P = rewriter.create<arith::AddFOp>(loc, P, p1);
    P = rewriter.create<arith::MulFOp>(loc, P, AbsX);
    P = rewriter.create<arith::AddFOp>(loc, P, float2);
    Value Q = rewriter.create<arith::MulFOp>(loc, AbsX, q1);
    Q = rewriter.create<arith::SubFOp>(loc, Q, float2);
    Value result = rewriter.create<arith::SubFOp>(loc, float1, AbsX);
    result = rewriter.create<math::SqrtOp>(loc, result);
    result = rewriter.create<arith::MulFOp>(loc, Q, result);
    result = rewriter.create<arith::AddFOp>(loc, P, result);
    result = rewriter.create<math::CopySignOp>(loc, result, x);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct AcosPattern : public F32OnlyRewritePattern<math::AcosOp> {
  AcosPattern(MLIRContext *context, DataFlowSolver &s,
              PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::AcosOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::AcosOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value halfPi = AdaptiveFloatConst(1.57079633f, op, rewriter);

    Value result = rewriter.create<arith::SubFOp>(
        loc, halfPi, rewriter.create<math::AsinOp>(loc, x));
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

// Max abs error: 0.005
struct AtanPattern : public F32OnlyRewritePattern<math::AtanOp> {
  AtanPattern(MLIRContext *context, DataFlowSolver &s,
              PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::AtanOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::AtanOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
    Value floatNeg1 = AdaptiveFloatConst(-1.0f, op, rewriter);
    Value halfPi = AdaptiveFloatConst(1.57079633f, op, rewriter);
    Value halfNegPi = AdaptiveFloatConst(-1.57079633f, op, rewriter);
    Value a1 = AdaptiveFloatConst(0.972380f, op, rewriter);
    Value a3 = AdaptiveFloatConst(-0.191942f, op, rewriter);

    Value isPosBig = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGT, x, float1);
    Value isNegBig = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OLT, x, floatNeg1);
    Value smallX = rewriter.create<arith::SelectOp>(
        loc, isPosBig, rewriter.create<arith::DivFOp>(loc, float1, x), x);
    smallX = rewriter.create<arith::SelectOp>(
        loc, isNegBig, rewriter.create<arith::DivFOp>(loc, float1, x), smallX);
    Value smallAtan = rewriter.create<arith::MulFOp>(loc, smallX, a3);
    smallAtan = rewriter.create<arith::MulFOp>(loc, smallAtan, smallX);
    smallAtan = rewriter.create<arith::AddFOp>(loc, smallAtan, a1);
    smallAtan = rewriter.create<arith::MulFOp>(loc, smallAtan, smallX);
    Value result = rewriter.create<arith::SelectOp>(
        loc, isPosBig, rewriter.create<arith::SubFOp>(loc, halfPi, smallAtan),
        smallAtan);
    result = rewriter.create<arith::SelectOp>(
        loc, isNegBig,
        rewriter.create<arith::SubFOp>(loc, halfNegPi, smallAtan), result);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct Atan2Pattern : public F32OnlyRewritePattern<math::Atan2Op> {
  Atan2Pattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::Atan2Op>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::Atan2Op op,
                                   PatternRewriter &rewriter) const override {
    Value y = op.getLhs();
    Value x = op.getRhs();
    Location loc = op.getLoc();

    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);
    Value Pi = AdaptiveFloatConst(3.14159265f, op, rewriter);
    Value NegPi = AdaptiveFloatConst(-3.14159265f, op, rewriter);
    Value HalfPi = AdaptiveFloatConst(1.57079633f, op, rewriter);
    Value NegHalfPi = AdaptiveFloatConst(-1.57079633f, op, rewriter);

    Value isXZero = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OEQ, x, float0);
    Value isXPos = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGT, x, float0);
    Value isYPos = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGE, y, float0);

    Value rotation = rewriter.create<arith::SelectOp>(loc, isYPos, Pi, NegPi);
    Value verticalY =
        rewriter.create<arith::SelectOp>(loc, isYPos, HalfPi, NegHalfPi);
    Value tanValue = rewriter.create<arith::DivFOp>(loc, y, x);
    Value atanValue = rewriter.create<math::AtanOp>(loc, tanValue);
    Value atanWithRotation = rewriter.create<arith::SelectOp>(
        loc, isXPos, atanValue,
        rewriter.create<arith::AddFOp>(loc, atanValue, rotation));
    Value result = rewriter.create<arith::SelectOp>(loc, isXZero, verticalY,
                                                    atanWithRotation);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct LogPattern : public F32OnlyRewritePattern<math::LogOp> {
  LogPattern(MLIRContext *context, DataFlowSolver &s,
             PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::LogOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::LogOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value log2_e = AdaptiveFloatConst(1.4426950409f, op, rewriter);

    Value result = rewriter.create<arith::DivFOp>(
        loc, rewriter.create<math::Log2Op>(loc, x), log2_e);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct Log10Pattern : public F32OnlyRewritePattern<math::Log10Op> {
  Log10Pattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::Log10Op>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::Log10Op op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value log2_10 = AdaptiveFloatConst(3.3219280949f, op, rewriter);

    Value result = rewriter.create<arith::DivFOp>(
        loc, rewriter.create<math::Log2Op>(loc, x), log2_10);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct Log1pPattern : public F32OnlyRewritePattern<math::Log1pOp> {
  Log1pPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::Log1pOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::Log1pOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);

    Value result = rewriter.create<math::LogOp>(
        loc, rewriter.create<arith::AddFOp>(loc, float1, x));
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct ExpM1Pattern : public OpRewritePattern<math::ExpM1Op> {
  ExpM1Pattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : OpRewritePattern<math::ExpM1Op>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(math::ExpM1Op op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);

    Value result = rewriter.create<arith::SubFOp>(
        loc, rewriter.create<math::ExpOp>(loc, x), float1);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct CbrtPattern : public F32OnlyRewritePattern<math::CbrtOp> {
  CbrtPattern(MLIRContext *context, DataFlowSolver &s,
              PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::CbrtOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::CbrtOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value cb = AdaptiveFloatConst(0.33333333f, op, rewriter);
    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);

    Value isPos = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OGT,
                                                 x, float0);
    Value isZero = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OEQ, x, float0);
    Value AbsX = rewriter.create<math::AbsFOp>(loc, x);
    Value result = rewriter.create<math::PowFOp>(loc, AbsX, cb);
    result = rewriter.create<math::CopySignOp>(loc, result, x);
    result = rewriter.create<arith::SelectOp>(loc, isZero, float0, result);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct CopysignPattern : public F32OnlyRewritePattern<math::CopySignOp> {
  CopysignPattern(MLIRContext *context, DataFlowSolver &s,
                  PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::CopySignOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::CopySignOp op,
                                   PatternRewriter &rewriter) const override {
    Value magnitude = op.getLhs();
    Value sign = op.getRhs();
    Location loc = op.getLoc();

    Value signMask = AdaptiveIntConst(0x8000'0000, op, rewriter);
    Value magMask = AdaptiveIntConst(0x7fff'ffff, op, rewriter);

    Value magBit = rewriter.create<arith::BitcastOp>(
        loc, getAdaptiveIntType(op, rewriter), magnitude);
    magBit = rewriter.create<arith::AndIOp>(loc, magMask, magBit);
    Value signBit = rewriter.create<arith::BitcastOp>(
        loc, getAdaptiveIntType(op, rewriter), sign);
    signBit = rewriter.create<arith::AndIOp>(loc, signMask, signBit);

    Value result = rewriter.create<arith::OrIOp>(loc, magBit, signBit);
    result = rewriter.create<arith::BitcastOp>(
        loc, getAdaptiveFloatType(op, rewriter), result);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct SinhPattern : public F32OnlyRewritePattern<math::SinhOp> {
  SinhPattern(MLIRContext *context, DataFlowSolver &s,
              PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::SinhOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::SinhOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);
    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
    Value float2 = AdaptiveFloatConst(2.0f, op, rewriter);

    Value Exp = rewriter.create<math::ExpOp>(loc, x);
    Value result = rewriter.create<arith::SubFOp>(
        loc, Exp, rewriter.create<arith::DivFOp>(loc, float1, Exp));
    result = rewriter.create<arith::DivFOp>(loc, result, float2);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct CoshPattern : public F32OnlyRewritePattern<math::CoshOp> {
  CoshPattern(MLIRContext *context, DataFlowSolver &s,
              PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::CoshOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::CoshOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);
    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
    Value float2 = AdaptiveFloatConst(2.0f, op, rewriter);

    Value Exp = rewriter.create<math::ExpOp>(loc, x);
    Value result = rewriter.create<arith::AddFOp>(
        loc, Exp, rewriter.create<arith::DivFOp>(loc, float1, Exp));
    result = rewriter.create<arith::DivFOp>(loc, result, float2);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct TanhPattern : public F32OnlyRewritePattern<math::TanhOp> {
  TanhPattern(MLIRContext *context, DataFlowSolver &s,
              PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::TanhOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::TanhOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);
    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
    Value float2 = AdaptiveFloatConst(2.0f, op, rewriter);

    Value x2 = rewriter.create<arith::MulFOp>(loc, float2, x);
    Value Exp2x = rewriter.create<math::ExpOp>(loc, x2);
    Value result = rewriter.create<arith::DivFOp>(
        loc, rewriter.create<arith::SubFOp>(loc, Exp2x, float1),
        rewriter.create<arith::AddFOp>(loc, Exp2x, float1));
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct AsinhPattern : public F32OnlyRewritePattern<math::AsinhOp> {
  AsinhPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::AsinhOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::AsinhOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);

    Value squared_x = rewriter.create<arith::MulFOp>(loc, x, x);
    Value result = rewriter.create<arith::AddFOp>(loc, squared_x, float1);
    result = rewriter.create<math::SqrtOp>(loc, result);
    result = rewriter.create<arith::AddFOp>(loc, x, result);
    result = rewriter.create<math::LogOp>(loc, result);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct AcoshPattern : public F32OnlyRewritePattern<math::AcoshOp> {
  AcoshPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : F32OnlyRewritePattern<math::AcoshOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewriteF32(math::AcoshOp op,
                                   PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);

    Value squared_x = rewriter.create<arith::MulFOp>(loc, x, x);
    Value result = rewriter.create<arith::SubFOp>(loc, squared_x, float1);
    result = rewriter.create<math::SqrtOp>(loc, result);
    result = rewriter.create<arith::AddFOp>(loc, x, result);
    result = rewriter.create<math::LogOp>(loc, result);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct AtanhPattern : public OpRewritePattern<math::AtanhOp> {
  AtanhPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : OpRewritePattern<math::AtanhOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(math::AtanhOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();

    Value float1 = AdaptiveFloatConst(1.0f, op, rewriter);
    Value floatHalf = AdaptiveFloatConst(0.5f, op, rewriter);

    Value x_m1 = rewriter.create<arith::SubFOp>(loc, float1, x);
    Value x_p1 = rewriter.create<arith::AddFOp>(loc, float1, x);
    Value result = rewriter.create<arith::DivFOp>(loc, x_p1, x_m1);
    result = rewriter.create<math::LogOp>(loc, result);
    result = rewriter.create<arith::MulFOp>(loc, result, floatHalf);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

////////////////////////////////////////////////////////////////
//                        ArithOp                             //
////////////////////////////////////////////////////////////////
struct DivSIPattern : public OpRewritePattern<arith::DivSIOp> {
  DivSIPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : OpRewritePattern<arith::DivSIOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::DivSIOp op,
                                PatternRewriter &rewriter) const override {
    Value dividend = op.getLhs();
    Value divider = op.getRhs();
    Location loc = op.getLoc();

    if (hasIndexOperand(op))
      return failure();

    if (auto cstDivider = divider.getDefiningOp<arith::ConstantOp>()) {
      int dividerVal = *parseInt(cstDivider);
      if ((dividerVal & (dividerVal - 1)) == 0) {
        int shiftAmount = log2(dividerVal);
        Value shiftCst = AdaptiveIntConst(shiftAmount, op, rewriter);
        rewriter.replaceOp(
            op, rewriter.create<arith::ShRSIOp>(loc, dividend, shiftCst));
        return success();
      }
    }

    Value int0 = AdaptiveIntConst(0, op, rewriter);

    Value abs_dividend = rewriter.create<math::AbsIOp>(loc, dividend);
    Value abs_divider = rewriter.create<math::AbsIOp>(loc, divider);

    Value isNeg = rewriter.create<arith::XOrIOp>(
        loc,
        rewriter.create<arith::CmpIOp>(loc, arith::CmpIPredicate::sgt, dividend,
                                       int0),
        rewriter.create<arith::CmpIOp>(loc, arith::CmpIPredicate::sgt, divider,
                                       int0));

    Value result =
        rewriter.create<arith::DivUIOp>(loc, abs_dividend, abs_divider);
    result = rewriter.create<arith::SelectOp>(
        loc, isNeg, rewriter.create<arith::SubIOp>(loc, int0, result), result);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct DivUIPattern : public OpRewritePattern<arith::DivUIOp> {
  DivUIPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : OpRewritePattern<arith::DivUIOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::DivUIOp op,
                                PatternRewriter &rewriter) const override {
    Value dividend = op.getLhs();
    Value divider = op.getRhs();
    Location loc = op.getLoc();

    if (hasIndexOperand(op))
      return failure();

    if (auto cstDivider = divider.getDefiningOp<arith::ConstantOp>()) {
      int dividerVal = *parseInt(cstDivider);
      if ((dividerVal & (dividerVal - 1)) == 0) {
        int shiftAmount = log2(dividerVal);
        Value shiftCst = AdaptiveIntConst(shiftAmount, op, rewriter);
        rewriter.replaceOp(
            op, rewriter.create<arith::ShRUIOp>(loc, dividend, shiftCst));
        return success();
      }
    }

    Value int0 = AdaptiveIntConst(0, op, rewriter);
    Value int1 = AdaptiveIntConst(1, op, rewriter);

    Value dividend_float = rewriter.create<arith::UIToFPOp>(
        loc, getAdaptiveFloatType(op, rewriter), dividend);
    Value divider_float = rewriter.create<arith::UIToFPOp>(
        loc, getAdaptiveFloatType(op, rewriter), divider);
    Value quotient =
        rewriter.create<arith::DivFOp>(loc, dividend_float, divider_float);
    Value quotient_int = rewriter.create<arith::FPToSIOp>(
        loc, getAdaptiveIntType(op, rewriter), quotient);
    Value regen_dividend =
        rewriter.create<arith::MulIOp>(loc, quotient_int, divider);
    Value rem = rewriter.create<arith::SubIOp>(loc, dividend, regen_dividend);
    Value rem_float = rewriter.create<arith::SIToFPOp>(
        loc, getAdaptiveFloatType(op, rewriter), rem);
    Value qrem = rewriter.create<arith::DivFOp>(loc, rem_float, divider_float);
    Value qrem_int = rewriter.create<arith::FPToSIOp>(
        loc, getAdaptiveIntType(op, rewriter), qrem);
    Value regen_rem = rewriter.create<arith::MulIOp>(loc, qrem_int, divider);
    Value rrem = rewriter.create<arith::SubIOp>(loc, rem, regen_rem);
    Value rrem_float = rewriter.create<arith::SIToFPOp>(
        loc, getAdaptiveFloatType(op, rewriter), rrem);
    Value qrrem =
        rewriter.create<arith::DivFOp>(loc, rrem_float, divider_float);
    Value qrrem_int = rewriter.create<arith::FPToSIOp>(
        loc, getAdaptiveIntType(op, rewriter), qrrem);
    Value regen_rrem = rewriter.create<arith::MulIOp>(loc, qrrem_int, divider);
    Value rrrem = rewriter.create<arith::SubIOp>(loc, rrem, regen_rrem);

    Value isRegenGT = rewriter.create<arith::CmpIOp>(
        loc, arith::CmpIPredicate::sgt, int0, rrrem);
    Value isRegenP1LEQ = rewriter.create<arith::CmpIOp>(
        loc, arith::CmpIPredicate::sle, divider, rrrem);

    Value result = rewriter.create<arith::AddIOp>(loc, quotient_int, qrem_int);
    result = rewriter.create<arith::AddIOp>(loc, result, qrrem_int);
    result = rewriter.create<arith::SelectOp>(
        loc, isRegenP1LEQ, rewriter.create<arith::AddIOp>(loc, result, int1),
        result);
    result = rewriter.create<arith::SelectOp>(
        loc, isRegenGT, rewriter.create<arith::SubIOp>(loc, result, int1),
        result);
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct RemFPattern : public OpRewritePattern<arith::RemFOp> {
  RemFPattern(MLIRContext *context, DataFlowSolver &s,
              PatternBenefit benefit = 1)
      : OpRewritePattern<arith::RemFOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::RemFOp op,
                                PatternRewriter &rewriter) const override {
    Value y = op.getLhs();
    Value x = op.getRhs();
    Location loc = op.getLoc();

    Value float0 = AdaptiveFloatConst(0.0f, op, rewriter);

    Value y_abs = rewriter.create<math::AbsFOp>(loc, y);
    Value x_abs = rewriter.create<math::AbsFOp>(loc, x);
    Value quotient = rewriter.create<arith::DivFOp>(loc, y_abs, x_abs);
    quotient = rewriter.create<math::TruncOp>(loc, quotient);
    Value y_regen = rewriter.create<arith::MulFOp>(loc, quotient, x_abs);

    Value isRegenGT = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OGT, y_regen, y_abs);
    Value isRegenP1LEQ = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OLE,
        rewriter.create<arith::AddFOp>(loc, y_regen, x_abs), y_abs);

    y_regen = rewriter.create<arith::SelectOp>(
        loc, isRegenGT, rewriter.create<arith::SubFOp>(loc, y_regen, x_abs),
        y_regen);
    y_regen = rewriter.create<arith::SelectOp>(
        loc, isRegenP1LEQ, rewriter.create<arith::AddFOp>(loc, y_regen, x_abs),
        y_regen);
    Value result0 = rewriter.create<arith::SubFOp>(loc, y_abs, y_regen);

    y_abs = result0;
    quotient = rewriter.create<arith::DivFOp>(loc, y_abs, x_abs);
    quotient = rewriter.create<math::TruncOp>(loc, quotient);
    y_regen = rewriter.create<arith::MulFOp>(loc, quotient, x_abs);

    isRegenGT = rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OGT,
                                               y_regen, y_abs);
    isRegenP1LEQ = rewriter.create<arith::CmpFOp>(
        loc, arith::CmpFPredicate::OLE,
        rewriter.create<arith::AddFOp>(loc, y_regen, x_abs), y_abs);

    y_regen = rewriter.create<arith::SelectOp>(
        loc, isRegenGT, rewriter.create<arith::SubFOp>(loc, y_regen, x_abs),
        y_regen);
    y_regen = rewriter.create<arith::SelectOp>(
        loc, isRegenP1LEQ, rewriter.create<arith::AddFOp>(loc, y_regen, x_abs),
        y_regen);
    Value result = rewriter.create<arith::SubFOp>(loc, y_abs, y_regen);
    result = rewriter.create<math::CopySignOp>(loc, result, y);

    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct RemSIPattern : public OpRewritePattern<arith::RemSIOp> {
  RemSIPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : OpRewritePattern<arith::RemSIOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::RemSIOp op,
                                PatternRewriter &rewriter) const override {
    Value dividend = op.getLhs();
    Value divider = op.getRhs();
    Location loc = op.getLoc();
    int dividerVal;

    if (hasIndexOperand(op))
      return failure();

    Value dividend_abs = rewriter.create<math::AbsIOp>(loc, dividend);
    Value divider_abs;
    if (auto cstDivider = divider.getDefiningOp<arith::ConstantOp>()) {
      dividerVal = abs(*parseInt(cstDivider));
      divider_abs = AdaptiveIntConst(dividerVal, op, rewriter);
    } else {
      divider_abs = rewriter.create<math::AbsIOp>(loc, divider);
    }
    Value result;

    bool isDividerPow2 = false;
    if (auto cstDivider = divider.getDefiningOp<arith::ConstantOp>()) {
      if ((dividerVal & (dividerVal - 1)) == 0) {
        int maskVal = dividerVal - 1;
        Value mask = AdaptiveIntConst(maskVal, op, rewriter);
        result = rewriter.create<arith::AndIOp>(loc, dividend_abs, mask);
        isDividerPow2 = true;
      }
    }
    if (!isDividerPow2) {
      Value quotient =
          rewriter.create<arith::DivSIOp>(loc, dividend_abs, divider_abs);
      Value y_regen =
          rewriter.create<arith::MulIOp>(loc, quotient, divider_abs);
      result = rewriter.create<arith::SubIOp>(loc, dividend_abs, y_regen);
    }

    Value int0 = AdaptiveIntConst(0, op, rewriter);
    Value isNeg = rewriter.create<arith::CmpIOp>(loc, arith::CmpIPredicate::slt,
                                                 dividend, int0);
    result = rewriter.create<arith::SelectOp>(
        loc, isNeg, rewriter.create<arith::SubIOp>(loc, int0, result), result);

    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct RemUIPattern : public OpRewritePattern<arith::RemUIOp> {
  RemUIPattern(MLIRContext *context, DataFlowSolver &s,
               PatternBenefit benefit = 1)
      : OpRewritePattern<arith::RemUIOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::RemUIOp op,
                                PatternRewriter &rewriter) const override {
    Value dividend = op.getLhs();
    Value divider = op.getRhs();
    Location loc = op.getLoc();

    if (hasIndexOperand(op))
      return failure();

    if (auto cstDivider = divider.getDefiningOp<arith::ConstantOp>()) {
      int dividerVal = *parseInt(cstDivider);
      if ((dividerVal & (dividerVal - 1)) == 0) {
        int maskLen = log2(dividerVal);
        int maskVal = (1 << maskLen) - 1;
        Value mask = AdaptiveIntConst(maskVal, op, rewriter);
        rewriter.replaceOp(op,
                           rewriter.create<arith::AndIOp>(loc, dividend, mask));
        return success();
      }
    }

    Value quotient = rewriter.create<arith::DivUIOp>(loc, dividend, divider);
    Value y_regen = rewriter.create<arith::MulIOp>(loc, quotient, divider);
    Value result = rewriter.create<arith::SubIOp>(loc, dividend, y_regen);

    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct NegMulToUnsignedPattern : public OpRewritePattern<arith::MulIOp> {
  NegMulToUnsignedPattern(MLIRContext *context, DataFlowSolver &s)
      : OpRewritePattern<arith::MulIOp>(context), solver(s) {}

  LogicalResult matchAndRewrite(arith::MulIOp op,
                                PatternRewriter &rewriter) const override {
    auto loc = op->getLoc();
    auto &lhsMutable = op.getLhsMutable();
    auto &rhsMutable = op.getRhsMutable();
    auto maybeIntLhs = getConstantIntValue(OpFoldResult(lhsMutable.get()));
    auto maybeIntRhs = getConstantIntValue(OpFoldResult(rhsMutable.get()));

    Value newCstLhs, newCstRhs;
    if (maybeIntLhs && *maybeIntLhs < 0) {
      newCstLhs = AdaptiveIntConst(-*maybeIntLhs, op, rewriter);
    }
    if (maybeIntRhs && *maybeIntRhs < 0) {
      newCstRhs = AdaptiveIntConst(-*maybeIntRhs, op, rewriter);
    }
    if (!newCstLhs && !newCstRhs) {
      return failure();
    }
    if (newCstLhs) {
      lhsMutable.assign(newCstLhs);
    }
    if (newCstRhs) {
      rhsMutable.assign(newCstRhs);
    }
    if (!newCstLhs || !newCstRhs) {
      Value zero = AdaptiveIntConst(0, op, rewriter);
      rewriter.setInsertionPointAfter(op);
      auto subOp = rewriter.create<arith::SubIOp>(loc, zero, op.getResult());
      op.getResult().replaceAllUsesExcept(subOp.getResult(), subOp);
    }
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct MulI32xI32Pattern : public OpRewritePattern<arith::MulIOp> {
  MulI32xI32Pattern(MLIRContext *context, DataFlowSolver &s,
                    PatternBenefit benefit = 1)
      : OpRewritePattern<arith::MulIOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::MulIOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getLhs();
    Value y = op.getRhs();
    Location loc = op.getLoc();

    if (hasIndexOperand(op) || hasScalarOperand(op))
      return failure();

    auto ExtractAndConvertF32 = [&](Value v, int left, int right) -> Value {
      Value v_shift;
      uint32_t mask = ((1 << (left - right)) - 1) << right;
      Value v_masked = rewriter.create<arith::AndIOp>(
          loc, v, AdaptiveIntConst(mask, op, rewriter));
      if (right > 0) {
        v_shift = rewriter.create<arith::ShRSIOp>(
            loc, v_masked, AdaptiveIntConst(right, op, rewriter));
      } else {
        v_shift = v_masked;
      }
      Value v_float = rewriter.create<arith::SIToFPOp>(
          loc, getAdaptiveFloatType(op, rewriter), v_shift);
      return v_float;
    };
    auto MulI32 = [&](Value a, Value b) -> Value {
      Value ab = rewriter.create<arith::MulFOp>(loc, a, b);
      return rewriter.create<arith::FPToSIOp>(
          loc, getAdaptiveIntType(op, rewriter), ab);
    };

    Value int12 = AdaptiveIntConst(12, op, rewriter);
    Value int24 = AdaptiveIntConst(24, op, rewriter);
    Value x_low12_float = ExtractAndConvertF32(x, 12, 0);
    Value y_low12_float = ExtractAndConvertF32(y, 12, 0);
    Value x_mid12_float = ExtractAndConvertF32(x, 24, 12);
    Value y_mid12_float = ExtractAndConvertF32(y, 24, 12);
    Value x_high8_float = ExtractAndConvertF32(x, 32, 24);
    Value y_high8_float = ExtractAndConvertF32(y, 32, 24);
    Value xlyl = MulI32(x_low12_float, y_low12_float);
    Value xmyl = MulI32(x_mid12_float, y_low12_float);
    Value xlym = MulI32(x_low12_float, y_mid12_float);
    Value xmym = MulI32(x_mid12_float, y_mid12_float);
    Value xlyh = MulI32(x_low12_float, y_high8_float);
    Value xhyl = MulI32(x_high8_float, y_low12_float);

    Value off0 = xlyl;
    Value off12 = rewriter.create<arith::AddIOp>(loc, xmyl, xlym);
    off12 = rewriter.create<arith::ShLIOp>(loc, off12, int12);

    Value off24 = rewriter.create<arith::AddIOp>(loc, xhyl, xlyh);
    off24 = rewriter.create<arith::AddIOp>(loc, off24, xmym);
    off24 = rewriter.create<arith::ShLIOp>(loc, off24, int24);

    Value result =
        rewriter.create<arith::AddUIExtendedOp>(loc, off0, off12).getSum();
    result =
        rewriter.create<arith::AddUIExtendedOp>(loc, result, off24).getSum();
    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct MulUIExtendedPattern : public OpRewritePattern<arith::MulUIExtendedOp> {
  MulUIExtendedPattern(MLIRContext *context, DataFlowSolver &s,
                       PatternBenefit benefit = 1)
      : OpRewritePattern<arith::MulUIExtendedOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::MulUIExtendedOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getLhs();
    Value y = op.getRhs();
    Location loc = op.getLoc();

    if (hasIndexOperand(op))
      return failure();

    auto ExtractI32 = [&](Value v, int left, int right) -> Value {
      uint32_t mask = ((1 << (left - right)) - 1) << right;
      Value v_masked = rewriter.create<arith::AndIOp>(
          loc, v, AdaptiveIntConst(mask, op, rewriter));
      return v_masked;
    };
    auto ExtractAndExpandF32 = [&](Value v, int left, int right) -> Value {
      Value v_shift, v_masked = ExtractI32(v, left, right);
      if (right > 0) {
        v_shift = rewriter.create<arith::ShRUIOp>(
            loc, v_masked, AdaptiveIntConst(right, op, rewriter));
      } else {
        v_shift = v_masked;
      }
      Value v_float = rewriter.create<arith::SIToFPOp>(
          loc, getAdaptiveFloatType(op, rewriter), v_shift);
      return v_float;
    };
    auto MulI32 = [&](Value a, Value b) -> Value {
      Value ab = rewriter.create<arith::MulFOp>(loc, a, b);
      return rewriter.create<arith::FPToSIOp>(
          loc, getAdaptiveIntType(op, rewriter), ab);
    };

    Value x_low12_float = ExtractAndExpandF32(x, 12, 0);
    Value y_low12_float = ExtractAndExpandF32(y, 12, 0);
    Value x_mid12_float = ExtractAndExpandF32(x, 24, 12);
    Value y_mid12_float = ExtractAndExpandF32(y, 24, 12);
    Value x_high8_float = ExtractAndExpandF32(x, 32, 24);
    Value y_high8_float = ExtractAndExpandF32(y, 32, 24);
    Value xlyl = MulI32(x_low12_float, y_low12_float);
    Value xmyl = MulI32(x_mid12_float, y_low12_float);
    Value xlym = MulI32(x_low12_float, y_mid12_float);
    Value xmym = MulI32(x_mid12_float, y_mid12_float);
    Value xlyh = MulI32(x_low12_float, y_high8_float);
    Value xhyl = MulI32(x_high8_float, y_low12_float);
    Value xhym = MulI32(x_high8_float, y_mid12_float);
    Value xmyh = MulI32(x_mid12_float, y_high8_float);
    Value xhyh = MulI32(x_high8_float, y_high8_float);

    Value ml = rewriter.create<arith::AddIOp>(loc, xmyl, xlym);
    Value ml_low32 = rewriter.create<arith::ShLIOp>(
        loc, ml, AdaptiveIntConst(12, op, rewriter));
    Value ml_high32 = ExtractI32(ml, 32, 20);
    ml_high32 = rewriter.create<arith::ShRUIOp>(
        loc, ml_high32, AdaptiveIntConst(20, op, rewriter));

    Value hl = rewriter.create<arith::AddIOp>(loc, xhyl, xlyh);
    Value off24 = rewriter.create<arith::AddIOp>(loc, hl, xmym);
    Value off24_low32 = rewriter.create<arith::ShLIOp>(
        loc, off24, AdaptiveIntConst(24, op, rewriter));
    Value off24_high32 = ExtractI32(off24, 32, 8);
    off24_high32 = rewriter.create<arith::ShRUIOp>(
        loc, off24_high32, AdaptiveIntConst(8, op, rewriter));

    Value hm = rewriter.create<arith::AddIOp>(loc, xhym, xmyh);
    Value hm_high32 = rewriter.create<arith::ShLIOp>(
        loc, hm, AdaptiveIntConst(4, op, rewriter));
    Value xhyh_high32 = rewriter.create<arith::ShLIOp>(
        loc, xhyh, AdaptiveIntConst(16, op, rewriter));

    Value low_overflow1 =
        rewriter.create<arith::AddUIExtendedOp>(loc, ml_low32, off24_low32)
            .getOverflow();
    Value low32 =
        rewriter.create<arith::AddUIExtendedOp>(loc, ml_low32, off24_low32)
            .getSum();
    Value low_overflow2 =
        rewriter.create<arith::AddUIExtendedOp>(loc, low32, xlyl).getOverflow();
    low32 = rewriter.create<arith::AddUIExtendedOp>(loc, low32, xlyl).getSum();

    low_overflow1 = rewriter.create<arith::ExtUIOp>(
        loc, getAdaptiveIntType(op, rewriter), low_overflow1);
    low_overflow2 = rewriter.create<arith::ExtUIOp>(
        loc, getAdaptiveIntType(op, rewriter), low_overflow2);
    Value low_overflow =
        rewriter.create<arith::AddIOp>(loc, low_overflow1, low_overflow2);
    Value high32 = rewriter.create<arith::AddIOp>(loc, off24_high32, hm_high32);
    high32 = rewriter.create<arith::AddIOp>(loc, high32, ml_high32);
    high32 = rewriter.create<arith::AddIOp>(loc, high32, low_overflow);
    high32 = rewriter.create<arith::AddUIExtendedOp>(loc, high32, xhyh_high32)
                 .getSum();

    rewriter.replaceAllUsesWith(op.getResult(0), low32);
    rewriter.replaceAllUsesWith(op.getResult(1), high32);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct MulSIExtendedPattern : public OpRewritePattern<arith::MulSIExtendedOp> {
  MulSIExtendedPattern(MLIRContext *context, DataFlowSolver &s,
                       PatternBenefit benefit = 1)
      : OpRewritePattern<arith::MulSIExtendedOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::MulSIExtendedOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getLhs();
    Value y = op.getRhs();
    Location loc = op.getLoc();

    if (hasIndexOperand(op))
      return failure();

    auto ExtractI32 = [&](Value v, int left, int right) -> Value {
      uint32_t mask = ((1 << (left - right)) - 1) << right;
      Value v_masked = rewriter.create<arith::AndIOp>(
          loc, v, AdaptiveIntConst(mask, op, rewriter));
      return v_masked;
    };
    auto ExtractAndExpandF32 = [&](Value v, int left, int right) -> Value {
      Value v_shift, v_masked = ExtractI32(v, left, right);
      if (right > 0) {
        v_shift = rewriter.create<arith::ShRSIOp>(
            loc, v_masked, AdaptiveIntConst(right, op, rewriter));
      } else {
        v_shift = v_masked;
      }
      Value v_float = rewriter.create<arith::SIToFPOp>(
          loc, getAdaptiveFloatType(op, rewriter), v_shift);
      return v_float;
    };
    auto MulI32 = [&](Value a, Value b) -> Value {
      Value ab = rewriter.create<arith::MulFOp>(loc, a, b);
      return rewriter.create<arith::FPToSIOp>(
          loc, getAdaptiveIntType(op, rewriter), ab);
    };

    Value x_low12_float = ExtractAndExpandF32(x, 12, 0);
    Value y_low12_float = ExtractAndExpandF32(y, 12, 0);
    Value x_mid12_float = ExtractAndExpandF32(x, 24, 12);
    Value y_mid12_float = ExtractAndExpandF32(y, 24, 12);
    Value x_high8_float = ExtractAndExpandF32(x, 32, 24);
    Value y_high8_float = ExtractAndExpandF32(y, 32, 24);
    Value xlyl = MulI32(x_low12_float, y_low12_float);
    Value xmyl = MulI32(x_mid12_float, y_low12_float);
    Value xlym = MulI32(x_low12_float, y_mid12_float);
    Value xmym = MulI32(x_mid12_float, y_mid12_float);
    Value xlyh = MulI32(x_low12_float, y_high8_float);
    Value xhyl = MulI32(x_high8_float, y_low12_float);
    Value xhym = MulI32(x_high8_float, y_mid12_float);
    Value xmyh = MulI32(x_mid12_float, y_high8_float);
    Value xhyh = MulI32(x_high8_float, y_high8_float);

    Value ml = rewriter.create<arith::AddIOp>(loc, xmyl, xlym);
    Value ml_low32 = rewriter.create<arith::ShLIOp>(
        loc, ml, AdaptiveIntConst(12, op, rewriter));
    Value ml_high32 = ExtractI32(ml, 32, 20);
    ml_high32 = rewriter.create<arith::ShRSIOp>(
        loc, ml_high32, AdaptiveIntConst(20, op, rewriter));

    Value hl = rewriter.create<arith::AddIOp>(loc, xhyl, xlyh);
    Value off24 = rewriter.create<arith::AddIOp>(loc, hl, xmym);
    Value off24_low32 = rewriter.create<arith::ShLIOp>(
        loc, off24, AdaptiveIntConst(24, op, rewriter));
    Value off24_high32 = ExtractI32(off24, 32, 8);
    off24_high32 = rewriter.create<arith::ShRSIOp>(
        loc, off24_high32, AdaptiveIntConst(8, op, rewriter));

    Value hm = rewriter.create<arith::AddIOp>(loc, xhym, xmyh);
    Value hm_high32 = rewriter.create<arith::ShLIOp>(
        loc, hm, AdaptiveIntConst(4, op, rewriter));
    Value xhyh_high32 = rewriter.create<arith::ShLIOp>(
        loc, xhyh, AdaptiveIntConst(16, op, rewriter));

    Value low_overflow1 =
        rewriter.create<arith::AddUIExtendedOp>(loc, ml_low32, off24_low32)
            .getOverflow();
    Value low32 =
        rewriter.create<arith::AddUIExtendedOp>(loc, ml_low32, off24_low32)
            .getSum();
    Value low_overflow2 =
        rewriter.create<arith::AddUIExtendedOp>(loc, low32, xlyl).getOverflow();
    low32 = rewriter.create<arith::AddUIExtendedOp>(loc, low32, xlyl).getSum();

    low_overflow1 = rewriter.create<arith::ExtUIOp>(
        loc, getAdaptiveIntType(op, rewriter), low_overflow1);
    low_overflow2 = rewriter.create<arith::ExtUIOp>(
        loc, getAdaptiveIntType(op, rewriter), low_overflow2);
    Value low_overflow =
        rewriter.create<arith::AddIOp>(loc, low_overflow1, low_overflow2);
    Value high32 = rewriter.create<arith::AddIOp>(loc, off24_high32, hm_high32);
    high32 = rewriter.create<arith::AddIOp>(loc, high32, ml_high32);
    high32 = rewriter.create<arith::AddIOp>(loc, high32, low_overflow);
    high32 = rewriter.create<arith::AddUIExtendedOp>(loc, high32, xhyh_high32)
                 .getSum();

    rewriter.replaceAllUsesWith(op.getResult(0), low32);
    rewriter.replaceAllUsesWith(op.getResult(1), high32);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct AddUIExtendedPattern : public OpRewritePattern<arith::AddUIExtendedOp> {
  AddUIExtendedPattern(MLIRContext *context, DataFlowSolver &s,
                       PatternBenefit benefit = 1)
      : OpRewritePattern<arith::AddUIExtendedOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::AddUIExtendedOp op,
                                PatternRewriter &rewriter) const override {
    Value y = op.getOperand(0);
    Value x = op.getOperand(1);
    Value s = op.getResult(0);
    Value o = op.getResult(1);
    Location loc = op.getLoc();

    Value sum = rewriter.create<dlc::AddIWrapOp>(loc, x, y);
    Value overflow =
        rewriter.create<arith::CmpIOp>(loc, arith::CmpIPredicate::ult, sum, x);

    rewriter.replaceAllUsesWith(s, sum);
    rewriter.replaceAllUsesWith(o, overflow);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct MaximumFPattern : public OpRewritePattern<arith::MaximumFOp> {
  MaximumFPattern(MLIRContext *context, DataFlowSolver &s,
                  PatternBenefit benefit = 1)
      : OpRewritePattern<arith::MaximumFOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::MaximumFOp op,
                                PatternRewriter &rewriter) const override {
    Value y = op.getOperand(0);
    Value x = op.getOperand(1);
    Location loc = op.getLoc();

    Value Nan = AdaptiveFloatConst(std::numeric_limits<float>::quiet_NaN(), op,
                                   rewriter);
    Value isNan =
        rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::UNO, x, y);
    Value result = rewriter.create<arith::MaxNumFOp>(loc, x, y);
    result = rewriter.create<arith::SelectOp>(loc, isNan, Nan, result);

    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct MinimumFPattern : public OpRewritePattern<arith::MinimumFOp> {
  MinimumFPattern(MLIRContext *context, DataFlowSolver &s,
                  PatternBenefit benefit = 1)
      : OpRewritePattern<arith::MinimumFOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(arith::MinimumFOp op,
                                PatternRewriter &rewriter) const override {
    Value y = op.getOperand(0);
    Value x = op.getOperand(1);
    Location loc = op.getLoc();

    Value Nan = AdaptiveFloatConst(std::numeric_limits<float>::quiet_NaN(), op,
                                   rewriter);
    Value isNan =
        rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::UNO, x, y);
    Value result = rewriter.create<arith::MinNumFOp>(loc, x, y);
    result = rewriter.create<arith::SelectOp>(loc, isNan, Nan, result);

    rewriter.replaceOp(op, result);
    return success();
  }

private:
  DataFlowSolver &solver;
};

////////////////////////////////////////////////////////////////
//                        VectorOp                            //
////////////////////////////////////////////////////////////////
struct F32I32ExtPattern : public RewritePattern {
  F32I32ExtPattern(MLIRContext *context, DataFlowSolver &s,
                   PatternBenefit benefit = 1)
      : RewritePattern(MatchAnyOpTypeTag(), benefit, context), solver(s) {}

  LogicalResult matchAndRewrite(Operation *op,
                                PatternRewriter &rewriter) const override {
    if (auto op0 = dyn_cast<vector::TransposeOp>(op)) {
      Value input = op0.getVector();
      if (auto type = dyn_cast<VectorType>(input.getType())) {
        if (type.getElementType() == rewriter.getI1Type()) {
          Type newTy =
              VectorType::Builder(type).setElementType(rewriter.getI32Type());
          auto ext =
              rewriter.create<arith::ExtUIOp>(op->getLoc(), newTy, input);
          auto newT = rewriter.replaceOpWithNewOp<vector::TransposeOp>(
              op, ext, op0.getPermutation());
          rewriter.setInsertionPointAfter(newT);
          auto trunc =
              rewriter.create<arith::TruncIOp>(op->getLoc(), type, newT);
          rewriter.replaceAllUsesExcept(newT.getResult(), trunc, trunc);
          return success();
        }
      }
    }
    return failure();
  }

private:
  DataFlowSolver &solver;
};

struct SinPattern : public OpRewritePattern<math::SinOp> {
  SinPattern(MLIRContext *context, DataFlowSolver &s,
             PatternBenefit benefit = 1)
      : OpRewritePattern<math::SinOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(math::SinOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();
    auto xType = x.getType();
    bool isVector = isa<VectorType>(xType);

    Value pi = rewriter.create<arith::ConstantOp>(
        loc, rewriter.getF32FloatAttr(3.14159265f));
    Value four =
        rewriter.create<arith::ConstantOp>(loc, rewriter.getF32FloatAttr(4.0f));
    if (isVector) {
      auto vecType = cast<VectorType>(xType);
      pi = rewriter.create<vector::SplatOp>(loc, vecType, pi);
      four = rewriter.create<vector::SplatOp>(loc, vecType, four);
    }

    Value absX = rewriter.create<math::AbsFOp>(loc, x);
    Value piMinusAbsX = rewriter.create<arith::SubFOp>(loc, pi, absX);
    Value numerator = rewriter.create<arith::MulFOp>(loc, four, x);
    numerator = rewriter.create<arith::MulFOp>(loc, numerator, piMinusAbsX);
    Value piSquared = rewriter.create<arith::MulFOp>(loc, pi, pi);
    Value approxSin = rewriter.create<arith::DivFOp>(loc, numerator, piSquared);
    rewriter.replaceOp(op, approxSin);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct CosPattern : public OpRewritePattern<math::CosOp> {
  CosPattern(MLIRContext *context, DataFlowSolver &s,
             PatternBenefit benefit = 1)
      : OpRewritePattern<math::CosOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(math::CosOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();
    auto xType = x.getType();
    bool isVector = isa<VectorType>(xType);

    Value halfPi = rewriter.create<arith::ConstantOp>(
        loc, rewriter.getF32FloatAttr(1.57079633f));
    if (isVector) {
      auto vecType = cast<VectorType>(xType);
      halfPi = rewriter.create<vector::SplatOp>(loc, vecType, halfPi);
    }
    Value xPlusHalfPi = rewriter.create<arith::AddFOp>(loc, x, halfPi);
    Value absX = rewriter.create<math::AbsFOp>(loc, xPlusHalfPi);
    Value pi = rewriter.create<arith::ConstantOp>(
        loc, rewriter.getF32FloatAttr(3.14159265f));
    Value four =
        rewriter.create<arith::ConstantOp>(loc, rewriter.getF32FloatAttr(4.0f));
    if (isVector) {
      auto vecType = cast<VectorType>(xType);
      pi = rewriter.create<vector::SplatOp>(loc, vecType, pi);
      four = rewriter.create<vector::SplatOp>(loc, vecType, four);
    }
    Value piMinusAbsX = rewriter.create<arith::SubFOp>(loc, pi, absX);
    Value numerator = rewriter.create<arith::MulFOp>(loc, four, xPlusHalfPi);
    numerator = rewriter.create<arith::MulFOp>(loc, numerator, piMinusAbsX);
    Value piSquared = rewriter.create<arith::MulFOp>(loc, pi, pi);
    Value approxCos = rewriter.create<arith::DivFOp>(loc, numerator, piSquared);
    rewriter.replaceOp(op, approxCos);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct ConstantFoldFloatSqrtPattern : OpRewritePattern<math::SqrtOp> {
  ConstantFoldFloatSqrtPattern(MLIRContext *context, DataFlowSolver &s,
                               PatternBenefit benefit = 1)
      : OpRewritePattern<math::SqrtOp>(context, benefit), solver(s) {}

  LogicalResult matchAndRewrite(math::SqrtOp op,
                                PatternRewriter &rewriter) const override {
    Value x = op.getOperand();
    Location loc = op.getLoc();
    auto cstOp = x.getDefiningOp<arith::ConstantOp>();
    if (!cstOp) {
      return failure();
    }

    auto floatAttr = dyn_cast<FloatAttr>(cstOp.getValue());
    if (!floatAttr) {
      return failure();
    }

    auto val = floatAttr.getValueAsDouble();
    if (val < 0.0) {
      return failure();
    }

    Value sqrtCst = rewriter.create<arith::ConstantOp>(
        loc, FloatAttr::get(x.getType(), std::sqrt(val)));
    rewriter.replaceOp(op, sqrtCst);
    return success();
  }

private:
  DataFlowSolver &solver;
};

struct DLCArithLegalizerPass
    : public impl::DLCArithLegalizerBase<DLCArithLegalizerPass> {

  void runOnOperation() override {
    auto *ctx = &getContext();
    RewritePatternSet patterns(ctx);
    auto mod = getOperation();
    DataFlowSolver solver;
    solver.load<dataflow::DeadCodeAnalysis>();
    solver.load<dataflow::SparseConstantPropagation>();
    solver.load<dataflow::IntegerRangeAnalysis>();
    if (failed(solver.initializeAndRun(mod)))
      return signalPassFailure();

    patterns
        .add<NegMulToUnsignedPattern, F32I32ExtPattern,
             //scalarop
             AddIScalarPattern,SubIScalarPattern,MinimumFScalarPattern,MaximumFScalarPattern,DivUIScalarPattern,RemSIScalarPattern,
             PowFPattern, FPowIPattern, IPowIPattern, TanPattern, FloorPattern,
             CeilPattern, RoundPattern, TruncPattern, RoundEvenPattern,
             ErfPattern, AbsIPattern, AsinPattern, AcosPattern, AtanPattern,
             Atan2Pattern, Log10Pattern, LogPattern, Log1pPattern, CbrtPattern,
             CopysignPattern, SinhPattern, CoshPattern, TanhPattern,
             AsinhPattern, AcoshPattern, AtanhPattern,
             // arithOp
             DivSIPattern, DivUIPattern, RemFPattern, RemSIPattern,
             RemUIPattern, AddUIExtendedPattern, MulUIExtendedPattern,
             MulSIExtendedPattern, MaximumFPattern, MinimumFPattern,
             // bf16 const folding
             ConstantFoldFloatSqrtPattern>(ctx, solver);
    if (EnableTaylorPattern) {
      patterns.add<CosTaylorPattern, SinTaylorPattern>(ctx, solver);
    } else if (EnableBhaskaraPattern) {
      patterns.add<CosBhaskaraPattern, SinBhaskaraPattern>(ctx, solver);
    } else if (EnableQuadraticPattern) {
      patterns.add<CosQuadraticPattern, SinQuadraticPattern>(ctx, solver);
    }
    if (EnablePreciseMulI) {
      patterns.add<MulI32xI32Pattern>(ctx, solver);
    }
    if (failed(applyPatternsGreedily(mod, std::move(patterns))))
      return signalPassFailure();
  }
};

} // namespace

std::unique_ptr<Pass> mlir::dlc::createDLCArithLegalizerPass() {
  return std::make_unique<DLCArithLegalizerPass>();
}