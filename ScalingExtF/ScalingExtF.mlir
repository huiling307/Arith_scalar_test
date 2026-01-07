
module {
  func.func @scalingextf(%a: f16, %scale: f16) -> f32 {
    %0 = arith.scaling_extf %a, %scale : f16, f16 to f32
    return %0 : f32
  }
}
