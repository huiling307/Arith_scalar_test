// MulSIExtended.mlir
module {
  func.func @mulsi_extended(%a: i32, %b: i32) -> (i32, i32) {
    %lo, %hi = arith.mulsi_extended %a, %b : i32
    return %lo, %hi : i32, i32
  }
}

