import os
import subprocess
import numpy as np
from datetime import datetime

# i32 helper
def i32(x):
    return np.int32(x)

# 测试数据
cases = [
    (i32(0),  i32(0),  "zero_zero"),
    (i32(1),  i32(7),  "one_seven"),
    (i32(-1), i32(7),  "minus_one_seven"),
    (i32(-3), i32(-7), "minus_three_minus_seven"),

    # boundaries
    (i32(np.iinfo(np.int32).max), i32(1), "max_times_one"),
    (i32(np.iinfo(np.int32).min), i32(1), "min_times_one"),

    # overflow into high
    (i32(np.iinfo(np.int32).max), i32(2), "max_times_two"),
    (i32(np.iinfo(np.int32).min), i32(2), "min_times_two"),

    # large * large
    (i32(np.iinfo(np.int32).max), i32(np.iinfo(np.int32).max), "max_times_max"),
    (i32(np.iinfo(np.int32).min), i32(np.iinfo(np.int32).min), "min_times_min"),
]

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/MulSIExtended/mulsiextended_scalar_results.txt"
)

def _write_result_to_file(name, a, b, lo_cpu, hi_cpu, lo_tpu, hi_tpu):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"case  : {name}\n"
            f"input : a={a}, b={b}\n"
            f"CPU   : lo={lo_cpu}, hi={hi_cpu}\n"
            f"TPU   : lo={lo_tpu}, hi={hi_tpu}\n"
            f"{'-'*60}\n"
        )

def mulsiextended_ref(a, b):
    prod = np.int64(a) * np.int64(b)
    lo = np.int32(prod & 0xFFFFFFFF)
    hi = np.int32((prod >> 32) & 0xFFFFFFFF)
    return lo, hi

def run_dlc_scalar(mlir_file, a, b):
    vmfb_folder = os.path.join(os.path.dirname(mlir_file), "MulSIExtended_scalar")
    os.makedirs(vmfb_folder, exist_ok=True)
    vmfb_file = os.path.join(vmfb_folder, "MulSIExtended_dlc.vmfb")

    # 编译 MLIR
    compile_cmd = f"iree-compile --iree-hal-target-backends=dlc {mlir_file} -o {vmfb_file}"
    subprocess.run(compile_cmd, shell=True, check=True)

    # 运行
    run_cmd = (
        f"iree-run-module --module={vmfb_file} --function=muls_extended --device=dlc "
        f"--input={a}:i32 --input={b}:i32"
    )
    result = subprocess.run(
        run_cmd, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
    )

    lo_val = hi_val = None
    for line in result.stdout.splitlines():
        if "result" in line:
            val_str = line.split(":")[-1].strip()
            if "=" in val_str:
                val_str = val_str.split("=", 1)[1]
            # DLC 输出为 tuple: lo, hi
            lo_val, hi_val = [np.int32(int(x.strip())) for x in val_str.strip("()").split(",")]
            break

    if lo_val is None or hi_val is None:
        raise RuntimeError(f"Failed to parse DLC output:\n{result.stdout}")

    return lo_val, hi_val

def test_mulsiextended_scalar():
    mlir_file = os.path.join(os.path.dirname(__file__), "MulSIExtended.mlir")
    failed = []

    for a, b, name in cases:
        lo_cpu, hi_cpu = mulsiextended_ref(a, b)
        lo_tpu, hi_tpu = run_dlc_scalar(mlir_file, a, b)

        _write_result_to_file(name, a, b, lo_cpu, hi_cpu, lo_tpu, hi_tpu)

        if lo_cpu != lo_tpu or hi_cpu != hi_tpu:
            failed.append(f"{name}: CPU=(lo={lo_cpu}, hi={hi_cpu}), TPU=(lo={lo_tpu}, hi={hi_tpu})")

    if failed:
        raise AssertionError("MulSIExtended mismatches:\n" + "\n".join(failed))

if __name__ == "__main__":
    test_mulsiextended_scalar()
    print("All MulSIExtended scalar tests passed!")


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/MulSIExtended/MulSIExtended.py