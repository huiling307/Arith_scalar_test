
module {
  func.func @ceildivsi(%a: i32, %b: i32) -> i32 {
    %result = arith.ceildivsi %a, %b : i32
    return %result : i32
  }
}
