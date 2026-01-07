// MinimumF.mlir
module {
  func.func @minimumf(%a: f32, %b: f32) -> f32 {
    %res = arith.minimumf %a, %b : f32
    return %res : f32
  }
}