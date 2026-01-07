
module {
  func.func @floordivsi(%a: i32, %b: i32) -> i32
       attributes { iree.module.export = true } {
    %0 = arith.floordivsi %a, %b : i32
    return %0 : i32
  }
}
