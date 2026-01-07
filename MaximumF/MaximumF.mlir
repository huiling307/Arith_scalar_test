// MaximumF.mlir
module {
  func.func @maximumf(%a: f32, %b: f32) -> f32 {
    %res = arith.maximumf %a, %b : f32
    return %res : f32
  }
}
