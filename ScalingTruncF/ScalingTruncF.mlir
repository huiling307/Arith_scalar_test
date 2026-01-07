// ScalingTruncF.mlir
module {
  func.func @scalingtruncf(%a: f32, %scale: f32) -> f16 {
  %result = "arith.scaling_truncf"(%a, %scale) : (f32, f32) -> f16
  return %result : f16
}
}
