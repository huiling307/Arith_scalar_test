import os
import subprocess
import numpy as np
from datetime import datetime

# ======================================================
# Helpers
# ======================================================

cases = [
    # ---------------- basic ----------------
    (0, 1, "zero_div_pos"),
    (0, -1, "zero_div_neg"),

    (1, 1, "one_div_one"),
    (1, 2, "one_div_two"),
    (2, 1, "two_div_one"),

    # ---------------- sign combinations ----------------
    (7, 2, "pos_pos_exact"),
    (7, 3, "pos_pos_round_up"),

    (7, -2, "pos_neg_round_up"),  
    (7, -3, "pos_neg_exact"),

    (-7, 2, "neg_pos_round_up"),    
    (-7, 3, "neg_pos_exact"),

    (-7, -2, "neg_neg_round_up"),  
    (-7, -3, "neg_neg_exact"),

    # ---------------- boundary-ish ----------------
    (np.iinfo(np.int32).max, 1, "max_div_one"),
    (np.iinfo(np.int32).min + 1, 1, "min_plus_one_div_one"),

    (np.iinfo(np.int32).max, -1, "max_div_neg_one"),
    (np.iinfo(np.int32).min + 1, -1, "min_plus_one_div_neg_one"),
]

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/CeilDivSI/ceildivsi_scalar_results.txt"
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

def ceildivsi_ref(a: int, b: int) -> int:
    if b == 0:
        raise ZeroDivisionError("division by zero")
    
    if b > 0:
        return (a + (b - 1)) // b
    else:  # b < 0
        return (a + (b + 1)) // b



def run_dlc_scalar(mlir_file, a, b):
    vmfb_folder = os.path.join(os.path.dirname(mlir_file), "CeilDivSi_scalar")
    os.makedirs(vmfb_folder, exist_ok=True)
    vmfb_file = os.path.join(vmfb_folder, "CeilDivSi_dlc.vmfb")
    dump_file = os.path.join(vmfb_folder, "CeilDivSI_dlc_dump.txt")

    # 编译
    compile_cmd = (
        f"iree-compile --iree-hal-target-backends=dlc "
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

    # 运行
    run_cmd = (
        f"iree-run-module --module={vmfb_file} --function=ceildivsi --device=dlc "
        f"--input={a}:i32 --input={b}:i32"
    )
    result = subprocess.run(
        run_cmd,
        shell=True,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )

    for line in result.stdout.splitlines():
        if "result" in line:
            val_str = line.split(":")[-1].strip()
            if "=" in val_str:
                val_str = val_str.split("=", 1)[1]
            return int(val_str)

    raise RuntimeError(f"Failed to parse DLC output:\n{result.stdout}")

def test_ceildivsi_scalar():
    mlir_file = os.path.join(os.path.dirname(__file__), "CeilDivSI.mlir")

    failed = []

    for a, b, name in cases:
        cpu_val = ceildivsi_ref(a, b)
        tpu_val = run_dlc_scalar(mlir_file, a, b)

        _write_result_to_file(name, a, b, cpu_val, tpu_val)

        if cpu_val != tpu_val:
            failed.append(f"{name}: CPU={cpu_val}, TPU={tpu_val}")

    if failed:
        raise AssertionError(
            "CeilDivSi mismatches:\n" + "\n".join(failed)
        )

if __name__ == "__main__":
    test_ceildivsi_scalar()
    print("All CeilDivSi scalar tests passed!")




#rm -f sim* && source set-env && cmake --build ../iree-build/  && python3 -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/CeilDivSI/CeilDivSI.py