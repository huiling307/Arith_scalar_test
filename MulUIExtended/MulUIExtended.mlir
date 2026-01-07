// MulUIExtended.mlir
module {
  func.func @mului_extended(%a: i32, %b: i32) -> (i32, i32) {
    %lo, %hi = arith.mului_extended %a, %b : i32
    return %lo, %hi : i32, i32
  }
}

