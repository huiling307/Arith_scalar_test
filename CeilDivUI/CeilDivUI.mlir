
module {
  func.func @ceildivui(%a: i32, %b: i32) -> i32 {
    %result = arith.ceildivui %a, %b : i32
    return %result : i32
  }
}
