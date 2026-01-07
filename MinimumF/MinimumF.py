import os
import subprocess
import numpy as np
from datetime import datetime

def f32(x):
    return np.float32(x)

cases = [
    # basic
    (f32(0.0), f32(0.0), "zero_zero"),
    (f32(1.0), f32(2.0), "one_two"),
    (f32(-1.0), f32(1.0), "minus_one_one"),

    # signed zero
    (f32(+0.0), f32(-0.0), "pos_zero_neg_zero"),
    (f32(-0.0), f32(+0.0), "neg_zero_pos_zero"),

    # infinities
    (f32(np.inf),  f32(1.0), "pos_inf_one"),
    (f32(-np.inf), f32(1.0), "neg_inf_one"),
    (f32(np.inf),  f32(-np.inf), "pos_inf_neg_inf"),

    # NaNs
    (f32(np.nan), f32(1.0), "nan_one"),
    (f32(1.0),    f32(np.nan), "one_nan"),
    (f32(np.nan), f32(np.nan), "nan_nan"),

    # equal values
    (f32(3.5), f32(3.5), "equal_values"),
]

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/MinimumF/minimumf_scalar_results.txt"
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

def minimumf_ref(a, b):
    """
    Strict reference implementation for arith.minimumf semantics:
    - Returns NaN if either operand is NaN
    - Treats -0.0 as less than +0.0
    """
    # 处理 NaN
    if np.isnan(a) or np.isnan(b):
        return np.float32(np.nan)

    # 处理 ±0
    if a == 0.0 and b == 0.0:
        # 如果 a 是 -0.0 或 b 是 -0.0，就返回 -0.0
        return np.float32(a if np.signbit(a) else b)

    # 一般情况返回最小值
    return np.float32(a if a < b else b)


def run_dlc_scalar(mlir_file, a, b):
    vmfb_folder = os.path.join(os.path.dirname(mlir_file), "MinimumF_scalar")
    os.makedirs(vmfb_folder, exist_ok=True)
    vmfb_file = os.path.join(vmfb_folder, "MinimumF_dlc.vmfb")

    # 编译 MLIR 文件到 DLC VMFB
    compile_cmd = (
        f"iree-compile --iree-hal-target-backends=dlc "
        f"{mlir_file} -o {vmfb_file}"
    )
    subprocess.run(compile_cmd, shell=True, check=True)

    # 运行 VMFB
    run_cmd = (
        f"iree-run-module --module={vmfb_file} --function=minimumf --device=dlc "
        f"--input={a}:f32 --input={b}:f32"
    )
    result = subprocess.run(
        run_cmd,
        shell=True,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )

    # 提取 f32 值
    for line in result.stdout.splitlines():
        if "result" in line:
            val_str = line.split(":")[-1].strip()
            if "=" in val_str:
                val_str = val_str.split("=", 1)[1]
            return np.float32(val_str)

    raise RuntimeError(f"Failed to parse DLC output:\n{result.stdout}")

def test_minimumf_scalar():
    mlir_file = os.path.join(os.path.dirname(__file__), "MinimumF.mlir")
    failed = []

    for a, b, name in cases:
        cpu_val = minimumf_ref(a, b)
        tpu_val = run_dlc_scalar(mlir_file, a, b)

        _write_result_to_file(name, a, b, cpu_val, tpu_val)

        ok = True
        if np.isnan(cpu_val):
            ok = np.isnan(tpu_val)
        else:
            # signed zero: only compare numeric value
            ok = (cpu_val == tpu_val)

        if not ok:
            failed.append(f"{name}: CPU={cpu_val}, TPU={tpu_val}")

    if failed:
        raise AssertionError(
            "MinimumF mismatches:\n" + "\n".join(failed)
        )

if __name__ == "__main__":
    test_minimumf_scalar()
    print("All MinimumF scalar tests passed!")



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/MinimumF/MinimumF.py