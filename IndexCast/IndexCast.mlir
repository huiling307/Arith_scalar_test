
module {
  func.func @index_to_i32(%a: index) -> i32 {
    %result = arith.index_cast %a : index to i32
    return %result : i32
  }
  func.func @i32_to_index(%a: i32) -> index {
    %result = arith.index_cast %a : i32 to index
    return %result : index
  }
}
