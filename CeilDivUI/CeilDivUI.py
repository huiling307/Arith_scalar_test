import os
import subprocess
import numpy as np
from datetime import datetime

# ======================================================
# Result dump
# ======================================================

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/CeilDivUI/ceildivui_scalar_results.txt"
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

# ======================================================
# Edge case generator
# ======================================================

def make_ceildivui_edge_cases():
    def i32_as_u32(x):
        return np.uint32(np.int32(x).view(np.uint32))

    return [
        (np.uint32(0), np.uint32(1), "zero_div_one"),
        (np.uint32(1), np.uint32(2), "one_div_two"),
        (np.uint32(3), np.uint32(2), "round_up"),
        (np.uint32(0xFFFFFFFF), np.uint32(1), "max_div_one"),
        (np.uint32(0x80000000), np.uint32(1), "high_bit_div_one"),
        (np.uint32(6), i32_as_u32(-2), "six_div_minus_two_unsigned"),
        (np.uint32(1), i32_as_u32(-1), "one_div_all_ones"),
        (np.uint32(10), np.uint32(0x80000000), "small_div_large"),
    ]

# ======================================================
# CPU reference
# ======================================================

def ceildivui_ref(a, b):
    # 使用 uint64 做计算，防止溢出
    a64 = np.uint64(a)
    b64 = np.uint64(b)

    # ceil(a / b) = (a + b - 1) // b
    result64 = (a64 + b64 - 1) // b64

    return np.uint32(result64)

# ======================================================
# DLC Backend runner
# ======================================================

def run_dlc_scalar(mlir_file, a, b):
    """
    Compile MLIR -> VMFB and run on DLC backend, return scalar result.
    """
    # 准备文件夹和 VMFB 名
    fname = os.path.basename(mlir_file)
    dir = os.path.dirname(mlir_file)
    fn = os.path.splitext(fname)[0]
    vmfb_folder = os.path.join(dir, fn + "_scalar")
    os.makedirs(vmfb_folder, exist_ok=True)
    vmfb_file = os.path.join(vmfb_folder, f"{fn}_dlc.vmfb")
    dump_file = os.path.join(vmfb_folder, "CeilDivUI_dlc_dump.txt")

    # -------- Compile --------
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
    # -------- Run --------
    run_cmd = (
        f"iree-run-module "
        f"--module={vmfb_file} "
        f"--function=ceildivui "
        f"--device=dlc "
        f"--input={a} "
        f"--input={b}"
    )
    result = subprocess.run(run_cmd, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # 解析输出
    for line in result.stdout.splitlines():
        if "result" in line:
            val_str = line.split(":")[-1].strip()
            if "=" in val_str:
                val_str = val_str.split("=", 1)[1]
            val_int=int(val_str)
            return np.uint32(val_int&0xFFFFFFFF)

    raise RuntimeError(f"Failed to parse DLC output:\n{result.stdout}")

# ======================================================
# Tests
# ======================================================

def test_ceildivui_scalar():
    mlir_file = os.path.join(
        os.path.dirname(__file__), "CeilDivUI.mlir"
    )

    for a, b, name in make_ceildivui_edge_cases():
        cpu_val = ceildivui_ref(a, b)
        tpu_val = run_dlc_scalar(mlir_file, a, b)

        # Write results
        _write_result_to_file(name, a, b, cpu_val, tpu_val)

        # Check correctness
        assert cpu_val == tpu_val, f"[{name}] mismatch: CPU={cpu_val}, DLC={tpu_val}"

# ======================================================
# Run standalone
# ======================================================

if __name__ == "__main__":
    test_ceildivui_scalar()
    print("All CeilDivUI scalar tests passed!")



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python3 -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/CeilDivUI/CeilDivUI.py