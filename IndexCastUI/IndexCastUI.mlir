module {
  func.func @index_to_u32(%a: index) -> i32 {
    %result = arith.index_castui %a : index to i32
    return %result : i32
  }
  func.func @u32_to_index(%a: i32) -> index {
    %result = arith.index_castui %a : i32 to index
    return %result : index
  }
}