Code文件夹：
arith_scalar_test文件夹：
为测试代码，主测试代码在py文件，运行测试代码命令行位于每个py文件最下方加#部分。
每个operation在运行一遍测试文件后都会将输出结果写入对应文件夹内的txt文件中方便查看。
arith_scalar_test文件夹位置：/root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test

DLCArithLegalizer.cpp：
在其中重写了AddI，SubI，RemSI，DivUI操作，对应pattern为AddIScalarPattern,SubIScalarPattern,RemSIScalarPattern,DivUIScalarPattern。
DLCArithLegalizer.cpp位置：
/root/iree/third_party/llvm-project/mlir/lib/Dialect/DLC/Transforms/DLCArithLegalizer.cpp

arith_scalar_operation.xlsx：
记录各个operation在测试文件下CPU与TPU的输出情况，是否重写，测试方法（jax或mlir）等内容。


主要工作：用jax完成了arith dialect中大部分指令的标量测试，少数无法用jax来测试的指令通过写mlir测试来完成。重写了AddI，SubI，RemSI，DivUI操作使其TPU行为与官方指令集行为一致。测试的数据集基本上为32bit，重写的pattern也只会接受32位的输入。



未处理的op说明：
5个op无法通过编译，会被标记为illegal从而返回calledprocesserror：
AddUIExtended,MulSIExtended,MulUIExtended,ScalingExtF,ScalingTruncF。

CPU与TPU在边界情况输出不同，但目前无法进行rewrite的op：
ExtF，MulF，TruncF。

MaximumF和MinimumF两个指令TPU的行为也有问题，由于无法用jax来测试，只能写mlir测试，但是在dump文件中发现arith.maximumf（minimumf）在经过conversionpass后就被lower成了vm.max指令，就算写了对应Pattern也没有办法被匹配，也就是说在lower过程中并没有经过DLCArithLegalizerPass，这种情况重写是没有用的。

MaxnumF和MinnumF两个指令在TPU上的行为是正确的，但是在CPU上的行为却有错误，他们的正常语义在输入有nan的时候会选择另一个输入，也就是在输入（nan，1）的时候正常会输出1，这也是TPU的行为，但测试后发现CPU在这个测试会输出nan，这种情况需要注意。

Pattern算法说明：

AddIScalarPattern：
算法逻辑说明
1. sum = x XOR y：计算不带进位的部分。
2. carry = (x AND y) << 1：计算进位。
3. 循环迭代：
• 如果 carry == 0 → 已经加完，保持 sum 不变。
• 否则：
• sum_xor = sum XOR carry → 把进位加到 sum。
• carry_shl = (sum AND carry) << 1 → 计算新的进位。
• 用 SelectOp 根据是否有进位选择更新。
4. 循环 32 次，保证所有位的进位都被处理完。


SubIScalarPattern：
算法同AddIScalarPattern，只是先将第二个输入取反再进行相加。

DivUIScalarPattern：
1. 初始化：
• quotient = 0
• remainder = 0
2. 从最高位 i = 31 到最低位 i = 0 迭代：
• 将 remainder 左移一位：相当于为下一位留空间。
• 将被除数 a 的第 i 位加到 remainder。
remainder |= ((a >> i) & 1)
• 检查 remainder >= b：
• 如果是，说明当前位商为 1：
• remainder -= b
• quotient |= (1 << i)（把商的第 i 位设为 1）
• 否则，商的当前位为 0。

RemSIScalarPattern：
用 Div + Mul + Sub 模拟。

Pattern问题：像AddIScalarPattern中要进行32次循环相加，这样的话每次匹配到AddI操作进行rewrite后都会生成大量的select，cmp，and，xor等基础IR，SubI操作也是如此，在跑DivSI这种会lower到SubI或者AddI的op时测试会跑的非常慢，跑完测试以后dump文件会生成100多万行，效率非常的低，需要考虑重写AddI和SubI的Pattern时采用更加高效的算法。

