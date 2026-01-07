// RUN: iree-compile %s --iree-input-type=none -o AddUIExtended.vmfb

module {
  func.func public @addui_extended_test(%a: i32, %b: i32) -> (i32, i1)
      attributes { "iree.module.export" = true } {
    %sum, %carry = arith.addui_extended %a, %b : i32, i1
    return %sum, %carry : i32, i1
  }
}
