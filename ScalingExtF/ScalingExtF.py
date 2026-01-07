import os
import subprocess
import numpy as np
from datetime import datetime

# ======================================================
# helpers
# ======================================================

def f32(x):
    return np.float32(x)

# ======================================================
# test cases
# ======================================================

cases = [
    (f32(0.0),   f32(1.0),   "zero"),
    (f32(1.0),   f32(1.0),   "one_times_one"),
    (f32(-1.5),  f32(2.0),   "neg_times_two"),
    (f32(0.25),  f32(4.0),   "fraction_scale_up"),
    (f32(4.0),   f32(0.25),  "fraction_scale_down"),
    (f32(10.0),  f32(16.0),  "large_scale"),
    (f32(1e-3),  f32(1e-2),  "small_values"),
]

# ======================================================
# result dump
# ======================================================

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/ScalingExtF/scalingextf_scalar_results.txt"
)

def _write_result_to_file(name, a, scale, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"case  : {name}\n"
            f"input : a={a}, scale={scale}\n"
            f"CPU   : {cpu_val}\n"
            f"TPU   : {tpu_val}\n"
            f"{'-'*60}\n"
        )

# ======================================================
# reference
# ======================================================

def scalingextf_ref(a, scale):
    return np.float32(a) * np.float32(scale)

# ======================================================
# run helper
# ======================================================

def run_dlc_scalar(mlir_file, a, scale):
    vmfb_folder = os.path.join(os.path.dirname(mlir_file), "ScalingExtF_scalar")
    os.makedirs(vmfb_folder, exist_ok=True)
    vmfb_file = os.path.join(vmfb_folder, "ScalingExtF_dlc.vmfb")
    dump_file = os.path.join(vmfb_folder, "ScalingExtF_dlc_dump.txt")

    # compile
    compile_cmd = (
        f"iree-compile "
        f"--iree-hal-target-backends=dlc "
        f"--mlir-print-ir-after-all "
        f"{mlir_file} -o {vmfb_file}"
    )
    compile_result = subprocess.run(
        compile_cmd,
        shell=True,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )

    # 保存 stdout 和 stderr 到文件
    with open(dump_file, "w") as f:
        f.write("=== STDOUT ===\n")
        f.write(compile_result.stdout)
        f.write("\n=== STDERR ===\n")
        f.write(compile_result.stderr)

    # run
    run_cmd = (
        f"iree-run-module "
        f"--module={vmfb_file} "
        f"--function=scalingextf "
        f"--device=dlc "
        f"--input={a}:f32 --input={scale}:f32"
    )
    result = subprocess.run(
        run_cmd,
        shell=True,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )

    # 解析结果
    for line in result.stdout.splitlines():
        line = line.strip()
        if line.startswith("result"):
            # 支持 "result[0]: f32=2.0" 或 "result[0]: 2.0"
            val_str = line.split("=")[-1].strip()
            return np.float32(val_str)

    raise RuntimeError(f"Failed to parse DLC output:\n{result.stdout}")

# ======================================================
# test
# ======================================================

def test_scalingextf_scalar():
    mlir_file = os.path.join(os.path.dirname(__file__), "ScalingExtF.mlir")
    failed = []

    for a, scale, name in cases:
        cpu_val = scalingextf_ref(a, scale)
        tpu_val = run_dlc_scalar(mlir_file, a, scale)

        _write_result_to_file(name, a, scale, cpu_val, tpu_val)

        # 浮点比较
        if not np.isclose(cpu_val, tpu_val, rtol=1e-3, atol=1e-5):
            failed.append(f"{name}: CPU={cpu_val}, TPU={tpu_val}")

    if failed:
        raise AssertionError(
            "ScalingExtF mismatches:\n" + "\n".join(failed)
        )

if __name__ == "__main__":
    test_scalingextf_scalar()
    print("All ScalingExtF scalar tests passed!")



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/ScalingExtF/ScalingExtF.py