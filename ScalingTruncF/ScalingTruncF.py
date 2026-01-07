import os
import numpy as np
from subprocess import run, PIPE
from datetime import datetime

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/ScalingTruncF/scalingtruncf_scalar_results.txt"
)

def _write_result_to_file(name, a, b, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"case  : {name}\n"
            f"input : a={a}, b={b}\n"
            f"CPU   : {cpu_val}\n"
            f"TPU   : {tpu_val}\n"
            f"{'-'*60}\n"
        )

cases = [
    (np.float32(0.0),   np.float32(1.0),   "zero"),
    (np.float32(1.0),   np.float32(1.0),   "one_times_one"),
    (np.float32(-1.5),  np.float32(2.0),   "neg_times_two"),
    (np.float32(0.25),  np.float32(4.0),   "scale_up"),
    (np.float32(4.0),   np.float32(0.25),  "scale_down"),
    (np.float32(1.1),   np.float32(1.1),   "rounding_down"),
    (np.float32(1.9),   np.float32(1.9),   "rounding_up"),
    (np.float32(1e4),   np.float32(1e2),   "large_scale"),
    (np.float32(1e-4),  np.float32(1e-2),  "small_values"),
]

def scalingtruncf_ref(a, scale):
    # CPU 模拟 scaling_truncf: 先乘，再截断，再 cast f16
    return np.float16(np.trunc(a * scale))

def run_dlc_scalar(mlir_file, a, scale):
    vmfb_folder = os.path.join(os.path.dirname(mlir_file), "ScalingTruncF_scalar")
    os.makedirs(vmfb_folder, exist_ok=True)
    vmfb_file = os.path.join(vmfb_folder, "ScalingTruncF_dlc.vmfb")

    # 编译 MLIR
    compile_cmd = f"iree-compile --iree-hal-target-backends=dlc {mlir_file} -o {vmfb_file}"
    run(compile_cmd, shell=True, check=True)

    # 运行 DLC
    run_cmd = f"iree-run-module --module={vmfb_file} --function=scalingtruncf --device=dlc --input={a}:f32 --input={scale}:f32"
    result = run(run_cmd, shell=True, check=True, stdout=PIPE, stderr=PIPE, text=True)

    for line in result.stdout.splitlines():
        if "result" in line:
            val_str = line.split(":")[-1].strip()
            if "=" in val_str:
                val_str = val_str.split("=", 1)[1]
            return np.float16(float(val_str))

def test_scalingtruncf_scalar():
    mlir_file = os.path.join(os.path.dirname(__file__), "ScalingTruncF.mlir")
    failed = []

    for a, scale, name in cases:
        cpu_val = scalingtruncf_ref(a, scale)
        tpu_val = run_dlc_scalar(mlir_file, a, scale)
        _write_result_to_file(name, a, scale, cpu_val, tpu_val)
        if cpu_val != tpu_val:
            failed.append((name, cpu_val, tpu_val))
            print(f"Mismatch {name}: CPU {cpu_val}, DLC {tpu_val}")

    if failed:
        print(f"\nTotal {len(failed)} mismatch(es):")
        for name, cpu_val, tpu_val in failed:
            print(f"  {name}: CPU {cpu_val}, DLC {tpu_val}")



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/ScalingTruncF/ScalingTruncF.py