import os
import subprocess
import numpy as np
from datetime import datetime

info = np.iinfo(np.int32)

cases = [
    (0, 1, "zero_div_one"),
    (0, -1, "zero_div_neg_one"),
    (1, 1, "one_div_one"),
    (1, 2, "one_div_two"),
    (7, 2, "pos_pos"),
    (7, -2, "pos_neg"),
    (-7, 2, "neg_pos"),
    (-7, -2, "neg_neg"),
    (7, 3, "pos_pos_floor"),      
    (-7, 3, "neg_pos_floor"),     
    (7, -3, "pos_neg_floor"),     
    (-7, -3, "neg_neg_floor"),    
    (info.max, 1, "max_div_one"),
    (info.min + 1, 1, "min_plus_one_div_one"),
    (info.max, -1, "max_div_neg_one"),
    (info.min + 1, -1, "min_plus_one_div_neg_one"),
]

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/FloorDivSI/floordivsi_scalar_results.txt")

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


def floordivsi_ref(a, b):
    if b == 0:
        raise ValueError("Division by zero is undefined for floor_divsi")
    return np.int32(np.floor(a / b))

def run_dlc_scalar(mlir_file, a, b):
    vmfb_folder = os.path.join(os.path.dirname(mlir_file), "FloorDivSI_scalar")
    os.makedirs(vmfb_folder, exist_ok=True)
    vmfb_file = os.path.join(vmfb_folder, "FloorDivSI_dlc.vmfb")
    dump_file = os.path.join(vmfb_folder, "FloorDivSI_dlc_dump.txt")

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

    # 运行 DLC，标量输入用 i32 格式
    run_cmd = (
        f"iree-run-module --module={vmfb_file} --function=floordivsi --device=dlc "
        f"--input={a}:i32 --input={b}:i32"
    )
    result = subprocess.run(run_cmd, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # 解析 DLC 输出
    for line in result.stdout.splitlines():
        if "result" in line:
            val_str = line.split(":")[-1].strip()
            if "=" in val_str:
                val_str = val_str.split("=", 1)[1]  # 去掉 i32= 前缀
            return np.int32(val_str)

    raise RuntimeError(f"Failed to parse DLC output:\n{result.stdout}")


def test_floordivsi_scalar():
    mlir_file = os.path.join(os.path.dirname(__file__), "FloorDivSI.mlir")
    for a, b, name in cases:
        cpu_val = floordivsi_ref(a, b)
        tpu_val = run_dlc_scalar(mlir_file, a, b)
        _write_result_to_file(name, a, b, cpu_val, tpu_val)
        assert cpu_val == tpu_val, f"[{name}] mismatch: CPU={cpu_val}, DLC={tpu_val}"

if __name__ == "__main__":
    test_floordivsi_scalar()
    print("All FloorDivSI scalar tests passed!")



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/FloorDivSI/FloorDivSI.py