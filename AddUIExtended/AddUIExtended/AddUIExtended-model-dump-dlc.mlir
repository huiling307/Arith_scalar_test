// -----// IR Dump After AutoInputConversionPipelinePass (iree-auto-input-conversion) //----- //
module {
  func.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.module.export = true} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IREEImportPublicPass (iree-import-public) //----- //
module {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ImportMLProgramPass (iree-import-ml-program) //----- //
module {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SanitizeModuleNamesPass (iree-sanitize-module-names) //----- //
module {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ConvertShardToFlowPass (iree-convert-shard-to-flow) //----- //
module {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After mlir::iree_compiler::IREE::ABI::ConvertStreamableOpsPass (iree-abi-convert-streamable-ops) //----- //
module {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After mlir::iree_compiler::IREE::ABI::WrapEntryPointsPass (iree-abi-wrap-entry-points) //----- //
module {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %0:2 = util.call @_addui_extended_test(%arg0, %arg1) : (i32, i32) -> (i32, i1)
    util.return %0#0, %0#1 : i32, i1
  }
  util.func private @_addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func private @_addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %0:2 = util.call @_addui_extended_test(%arg0, %arg1) : (i32, i32) -> (i32, i1)
  util.return %0#0, %0#1 : i32, i1
}

// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After Inliner (inline) //----- //
module {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SymbolDCE (symbol-dce) //----- //
module {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After LLVMDLCHostTensorEncoding (iree-llvmdlc-host-tensor-encoding) //----- //
module {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After AssignLegacyTargetDevicesPass (iree-hal-assign-legacy-target-devices) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {hal.device.targets = [#device_target_dlc]} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MaterializeTargetDevicesPass (iree-hal-materialize-target-devices) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ResolveDevicePromisesPass (iree-hal-resolve-device-promises) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ResolveDeviceAliasesPass (iree-hal-resolve-device-aliases) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After VerifyDevicesPass (iree-hal-verify-devices) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After DetachElementwiseFromNamedOpsPass (iree-global-opt-detach-elementwise-from-named-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LinalgNamedOpConversionPass (linalg-named-op-conversion) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After Convert1X1FilterConv2DToMatmulPass (iree-global-opt-convert-1x1-filter-conv2d-to-matmul) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ConvertConvToChannelsLastPass (iree-preprocessing-convert-conv-to-channels-last) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldUnitExtentDimsPass (iree-dispatch-creation-fold-unit-extent-dims) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After CSE (cse) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After AttrBasedPipelinePass (iree-preprocessing-attr-based-pipeline) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After WarnOnUninitializedValuesPass (iree-global-opt-warn-on-uninitialized-values) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After StripDebugOpsPass (iree-util-strip-debug-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LinalgQuantizedConvToConvPass (iree-global-opt-quantized-conv-to-conv) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LinalgQuantizedMatmulToMatmulPass (iree-global-opt-quantized-matmul-to-matmul) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After RemoveZeroExtentTensorsPass (iree-global-opt-remove-zero-extent-tensors) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LLVMDLCLinalgRewriting (iree-llvmdlc-linalg-rewriting) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After DetachElementwiseFromNamedOpsPass (iree-global-opt-detach-elementwise-from-named-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LinalgNamedOpConversionPass (linalg-named-op-conversion) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After EraseUnusedLinalgOperandsPass (iree-global-opt-erase-unused-linalg-operands) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ExpandTensorShapesPass (iree-global-opt-expand-tensor-shapes) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ConvertElementwiseToLinalgPass (convert-elementwise-to-linalg) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After RaiseSpecialOpsPass (iree-global-opt-raise-special-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After DecomposeConcatPass (iree-global-opt-decompose-concat) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After DecomposeSoftmaxPass (iree-codegen-decompose-softmax) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After GeneralizeLinalgNamedOpsPass (iree-global-opt-generalize-linalg-named-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldUnitExtentDimsPass (iree-dispatch-creation-fold-unit-extent-dims) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ConvertStridedContractionToContractionPass (iree-global-opt-convert-strided-contraction-to-contraction) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After DemoteContractionInputsToBF16Pass (iree-global-opt-demote-contraction-inputs-to-bf16) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After PropagateLinalgTransposePass (iree-global-opt-propagate-linalg-transpose) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After GeneralizeLinalgNamedOpsPass (iree-global-opt-generalize-linalg-named-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After GlobalLoopInvariantCodeMotionPass (iree-global-opt-loop-invariant-code-motion) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After HoistIntoGlobalsPass (iree-util-hoist-into-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After JitGlobalsPass (iree-consteval-jit-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After RaiseSpecialOpsPass (iree-global-opt-raise-special-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After InjectTensorTracingPass (iree-flow-inject-tensor-tracing) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After TensorPadToTensorInsertSlicePass (iree-dispatch-creation-tensor-pad-to-tensor-insert-slice) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FixedPointIteratorPass (iree-util-fixed-point-iterator) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FusionPreprocessingPass (iree-dispatch-creation-fusion-preprocessing) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ElementwiseOpFusionPass (iree-dispatch-creation-elementwise-op-fusion) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After BubbleUpExpandShapesPass (iree-dispatch-creation-bubble-up-expand-shapes) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ElementwiseOpFusionPass (iree-dispatch-creation-elementwise-op-fusion) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SinkReshapesPass (iree-dispatch-creation-sink-reshapes) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FuseMultiUseElementwiseProducerPass (iree-dispatch-creation-fuse-multi-use-elementwise-producer) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SplitReductionPass (iree-dispatch-creation-split-reduction-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FormSplitReductionDispatchesPass (iree-dispatch-creation-form-split-reduction-dispatches) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After TransposeGenericOpsPass (iree-dispatch-creation-transpose-generic-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After HoistIntoGlobalsPass (iree-util-hoist-into-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizeScalarTensorPass (iree-dispatch-creation-canonicalize-scalar-tensor) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LLVMDLCHostTensorPadding (iree-llvmdlc-host-tensor-padding) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After HoistIntoGlobalsPass (iree-util-hoist-into-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After JitGlobalsPass (iree-consteval-jit-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After InjectTensorTracingPass (iree-flow-inject-tensor-tracing) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After TensorPadToTensorInsertSlicePass (iree-dispatch-creation-tensor-pad-to-tensor-insert-slice) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FixedPointIteratorPass (iree-util-fixed-point-iterator) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FusionPreprocessingPass (iree-dispatch-creation-fusion-preprocessing) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ElementwiseOpFusionPass (iree-dispatch-creation-elementwise-op-fusion) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After BubbleUpExpandShapesPass (iree-dispatch-creation-bubble-up-expand-shapes) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ElementwiseOpFusionPass (iree-dispatch-creation-elementwise-op-fusion) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SinkReshapesPass (iree-dispatch-creation-sink-reshapes) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FuseMultiUseElementwiseProducerPass (iree-dispatch-creation-fuse-multi-use-elementwise-producer) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SplitReductionPass (iree-dispatch-creation-split-reduction-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FormSplitReductionDispatchesPass (iree-dispatch-creation-form-split-reduction-dispatches) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After TransposeGenericOpsPass (iree-dispatch-creation-transpose-generic-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After HoistIntoGlobalsPass (iree-util-hoist-into-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizeScalarTensorPass (iree-dispatch-creation-canonicalize-scalar-tensor) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LLVMDLCHostTensorPadding (iree-llvmdlc-host-tensor-padding) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After TensorPadToTensorInsertSlicePass (iree-dispatch-creation-tensor-pad-to-tensor-insert-slice) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After DLCPreprocessTensor (dlc-preprocess-tensor) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LLVMDLCLinalgRewriting (iree-llvmdlc-linalg-rewriting) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ConvertElementwiseToLinalgPass (convert-elementwise-to-linalg) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After DetachElementwiseFromNamedOpsPass (iree-global-opt-detach-elementwise-from-named-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FormScalarDispatchesPass (iree-dispatch-creation-form-scalar-dispatches) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FormSmemComputationDispatchesPass (iree-dispatch-creation-form-smem-computation-dispatches) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FormDispatchRegionsPass (iree-dispatch-creation-form-dispatch-regions) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ElementwiseOpFusionPass (iree-dispatch-creation-elementwise-op-fusion) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FuseMultiUseElementwiseProducerPass (iree-dispatch-creation-fuse-multi-use-elementwise-producer) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CloneProducersIntoDispatchRegionsPass (iree-dispatch-creation-clone-producers-into-dispatch-regions) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CollapseDimensionsPass (iree-dispatch-creation-collapse-dimensions) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After HoistUniformScalarComputePass (iree-dispatch-creation-hoist-uniform-scalar-compute) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ConvertEncodingToFlowPass (iree-dispatch-creation-convert-encoding-to-flow) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After HoistIntoGlobalsPass (iree-util-hoist-into-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ConvertDispatchRegionsToWorkgroupsPass (iree-dispatch-creation-convert-dispatch-regions-to-workgroups) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After DLCConvertTensorToFlowPass (iree-dispatch-creation-dlc-convert-tensor-to-flow) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After MaterializeDefaultWorkgroupCountRegionPass (iree-dispatch-creation-materialize-default-workgroup-count-region) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After BitcastUnsupportedElementTypesPass (iree-dispatch-creation-bitcast-unsupported-element-types) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After VerifyInputLegalityPass (iree-verify-input-legality) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After InitializeEmptyTensorsPass (iree-flow-initialize-empty-tensors) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CaptureDynamicDimsPass (iree-flow-capture-dynamic-dims) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OutlineDispatchExternsPass (iree-flow-outline-dispatch-externs) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After OutlineDispatchRegionsPass (iree-flow-outline-dispatch-regions) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After AnnotateDispatchesPass (iree-flow-annotate-dispatches) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After DeduplicateExecutablesPass (iree-flow-deduplicate-executables) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After InjectTensorTracingPass (iree-flow-inject-tensor-tracing) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CleanupTensorShapesPass (iree-flow-cleanup-tensor-shapes) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OutlineConstantsPass (iree-flow-outline-constants) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CanonicalizePass (iree-flow-canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FixedPointIteratorPass (iree-util-fixed-point-iterator) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SymbolDCE (symbol-dce) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After DumpDispatchGraphPass (iree-flow-dump-dispatch-graph-pass) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After VerifyInputPass (iree-stream-verify-input) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After CloneToConsumersPass (iree-stream-clone-to-consumers) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ConvertToStreamPass (iree-stream-conversion) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After VerifyLoweringToTensorsPass (iree-stream-verify-lowering-to-tensors) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After Inliner (inline) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After CombineInitializersPass (iree-util-combine-initializers) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After AddDLCResourceConfigAttrPass (iree-stream-add-dlc-resource-config-attr) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SpecializeEncodingsPass (iree-stream-specialize-encodings) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After EncodeHostTensorsPass (iree-stream-encode-host-tensors) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ConvertElementwiseToLinalgPass (convert-elementwise-to-linalg) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MaterializeEncodingsPass (iree-stream-materialize-encodings) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After VerifyLoweringToAsyncResourcesPass (iree-stream-verify-lowering-to-async-resources) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ElideAsyncTransfersPass (iree-stream-elide-async-transfers) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MaterializeCopyOnWritePass (iree-stream-materialize-copy-on-write) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ElideAsyncCopiesPass (iree-stream-elide-async-copies) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After EmplaceAllocationsPass (iree-stream-emplace-allocations) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After RefineUsagePass (iree-stream-refine-usage) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After VerifyAsyncAccessRangesPass (iree-stream-verify-async-access-ranges) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MergeFillOpsPass (iree-stream-merge-fill-ops) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ScheduleExecutionPass (iree-stream-schedule-execution) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SyncInitializersPass (iree-stream-sync-initializers) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After PropagateTimepointsPass (iree-stream-propagate-timepoints) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MaterializeBuiltinsPass (iree-stream-materialize-builtins) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After VerifyLoweringToAsyncPass (iree-stream-verify-lowering-to-async) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ScheduleAllocationPass (iree-stream-schedule-allocation) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After PackConstantsPass (iree-stream-pack-constants) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LayoutSlicesPass (iree-stream-layout-slices) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After PropagateSubrangesPass (iree-util-propagate-subranges) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After AutomaticReferenceCountingPass (iree-stream-automatic-reference-counting) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MergeFillOpsPass (iree-stream-merge-fill-ops) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After VerifyLoweringToCmdPass (iree-stream-verify-lowering-to-cmd) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SCFToControlFlowPass (convert-scf-to-cf) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ReuseAllocationsPass (iree-stream-reuse-allocations) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ElideTimepointsPass (iree-stream-elide-timepoints) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {iree.fixedpoint.iteration = 0 : index, stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FixedPointIteratorPass (iree-util-fixed-point-iterator) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseDispatchBindingsPass (iree-stream-fuse-dispatch-bindings) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After AnnotateDispatchArgumentsPass (iree-stream-annotate-dispatch-arguments) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After AnnotateDispatchAssumptionsPass (iree-stream-annotate-dispatch-assumptions) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After PackDispatchOperandsPass (iree-stream-pack-dispatch-operands) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FoldUniformOperandsPass (iree-stream-fold-uniform-operands) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After OptimizeIntArithmeticPass (iree-util-optimize-int-arithmetic) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SymbolDCE (symbol-dce) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After AssignLegacyTargetDevicesPass (iree-hal-assign-legacy-target-devices) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MaterializeTargetDevicesPass (iree-hal-materialize-target-devices) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ResolveDevicePromisesPass (iree-hal-resolve-device-promises) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ResolveDeviceAliasesPass (iree-hal-resolve-device-aliases) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After VerifyDevicesPass (iree-hal-verify-devices) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After VerifyDevicesPass (iree-hal-verify-devices) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MaterializeInterfacesPass (iree-hal-materialize-interfaces) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After PruneExecutablesPass (iree-hal-prune-executables) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After DumpExecutableSourcesPass (iree-hal-dump-executable-sources) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After DumpExecutableSourcesPass (iree-hal-dump-executable-sources) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


/root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/AddUIExtended/AddUIExtended.mlir:3:1: remark: Executable benchmarks were requested but none were generated. Run with --debug-only=iree-dump-executable-benchmarks for more details.

module {
^
// -----// IR Dump After DumpExecutableBenchmarksPass (iree-hal-dump-executable-benchmarks) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ConvertToHALPass (iree-hal-conversion) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After OutlineMemoizeRegionsPass (iree-hal-outline-memoize-regions) //----- //
#executable_target_dlc_fb = #hal.executable.target<"dlc", "dlc-fb">
#device_target_dlc = #hal.device.target<"dlc", [#executable_target_dlc_fb]> : !hal.device
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.global private @__device_0 = #device_target_dlc
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After PruneExecutablesPass (iree-hal-prune-executables) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SymbolDCE (symbol-dce) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After LinkAllExecutablesPass (iree-hal-link-all-executables) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ResolveExportOrdinalsPass (iree-hal-resolve-export-ordinals) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MaterializeResourceCachesPass (iree-hal-materialize-resource-caches) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ResolveTopologyQueriesPass (iree-hal-resolve-topology-queries) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MemoizeDeviceSelectionPass (iree-hal-memoize-device-selection) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After MemoizeDeviceQueriesPass (iree-hal-memoize-device-queries) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After ElideRedundantCommandsPass (iree-hal-elide-redundant-commands) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After InitializeDevicesPass (iree-hal-initialize-devices) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After AffineExpandIndexOps (affine-expand-index-ops) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After LowerAffinePass (lower-affine) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SCFToControlFlowPass (convert-scf-to-cf) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After PruneExecutablesPass (iree-hal-prune-executables) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SymbolDCE (symbol-dce) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
module attributes {iree.fixedpoint.iteration = 0 : index, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
module attributes {iree.fixedpoint.iteration = 0 : index, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After IPOPass (iree-util-ipo) //----- //
module attributes {iree.fixedpoint.iteration = 0 : index, stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FixedPointIteratorPass (iree-util-fixed-point-iterator) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After Inliner (inline) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SymbolDCE (symbol-dce) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After CombineInitializersPass (iree-util-combine-initializers) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SCFForLoopCanonicalization (scf-for-loop-canonicalization) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LoopInvariantCodeMotion (loop-invariant-code-motion) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SCFToControlFlowPass (convert-scf-to-cf) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After AffineExpandIndexOps (affine-expand-index-ops) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After LowerAffinePass (lower-affine) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ArithUnsignedWhenEquivalentPass (arith-unsigned-when-equivalent) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After PropagateSubrangesPass (iree-util-propagate-subranges) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After Canonicalizer (canonicalize) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After CSE (cse) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After SymbolDCE (symbol-dce) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After SimplifyGlobalAccessesPass (iree-util-simplify-global-accesses) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After ApplyPatternsPass (iree-util-apply-patterns) //----- //
util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
  %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
  util.return %sum, %overflow : i32, i1
}

// -----// IR Dump After FoldGlobalsPass (iree-util-fold-globals) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


// -----// IR Dump After FuseGlobalsPass (iree-util-fuse-globals) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>} {
  util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
    %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
    util.return %sum, %overflow : i32, i1
  }
}


/root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/AddUIExtended/AddUIExtended.mlir:6:20: error: failed to legalize operation 'arith.addui_extended' that was explicitly marked illegal
    %sum, %carry = arith.addui_extended %a, %b : i32, i1
                   ^
/root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/AddUIExtended/AddUIExtended.mlir:4:3: note: called from
  func.func public @addui_extended_test(%a: i32, %b: i32) -> (i32, i1)
  ^
/root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/AddUIExtended/AddUIExtended.mlir:6:20: note: see current operation: %0:2 = "arith.addui_extended"(%arg0, %arg1) : (i32, i32) -> (i32, i1)
    %sum, %carry = arith.addui_extended %a, %b : i32, i1
                   ^
/root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/AddUIExtended/AddUIExtended.mlir:3:1: error: conversion to vm.module failed
module {
^
/root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/AddUIExtended/AddUIExtended.mlir:3:1: note: see current operation: 
"builtin.module"() ({
  "builtin.module"() ({
    "util.func"() <{function_type = (i32, i32) -> (i32, i1), sym_name = "addui_extended_test"}> ({
    ^bb0(%arg0: i32, %arg1: i32):
      %0:2 = "arith.addui_extended"(%arg0, %arg1) : (i32, i32) -> (i32, i1)
      "util.return"(%0#0, %0#1) : (i32, i1) -> ()
    }) {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} : () -> ()
  }) : () -> ()
}) {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>, vm.toplevel} : () -> ()
// -----// IR Dump After ConversionPass Failed (iree-vm-conversion) //----- //
module attributes {stream.resources = #stream.resource_config<{max_allocation_size = 9223372036854775807, min_buffer_offset_alignment = 512, max_buffer_range = 9223372036854775807, min_buffer_range_alignment = 512, index_bits = 64, alias_mutable_bindings = 0, memory_model = Discrete}>, vm.toplevel} {
  module {
    util.func public @addui_extended_test(%arg0: i32, %arg1: i32) -> (i32, i1) attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @addui_extended_test(%input0: i32, %input1: i32) -> (%output0: i32, %output1: i1)"}} {
      %sum, %overflow = arith.addui_extended %arg0, %arg1 : i32, i1
      util.return %sum, %overflow : i32, i1
    }
  }
}


