import os
import subprocess
import numpy as np
import jax.numpy as jnp
from datetime import datetime

def idx(x):
    return np.int64(x)  # Python 的 index 类型用 int64 表示

# ---------- test cases ----------
def make_index_to_i32_cases():
    info = np.iinfo(np.int32)
    cases = [
        (0, "zero"),
        (1, "one"),
        (7, "seven"),
        (info.max, "i32_max"),
    ]
    return [(idx(a), name) for a, name in cases]

def make_i32_to_index_cases():
    cases = [
        (0, "zero", False),
        (1, "one", False),
        (7, "seven", False),
        (-1, "minus_one", True),     # UB
        (-7, "minus_seven", True),   # UB
    ]
    return [(np.int32(a), name, ub) for a, name, ub in cases]

# ---------- result dump ----------
RESULT_DUMP_PATH = "/root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/IndexCast/indexcast_scalar_results.txt"

def _write_result_to_file(name, a, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    def format_val(val):
        if isinstance(val, (int, np.integer)):
            return str(int(val))
        return str(val)  # 直接写 UB 或其他字符串

    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"case  : {name}\n"
            f"input : a={int(a)}\n"
            f"CPU   : {format_val(cpu_val)}\n"
            f"TPU   : {format_val(tpu_val)}\n"
            f"{'-'*60}\n"
        )


# ---------- reference functions ----------
def index_to_i32_ref(a):
    return np.int32(a)

def i32_to_index_ref(a):
    if a < 0:
        # undefined behavior
        return None
    return idx(a)

# ---------- run helper ----------
def run_dlc_scalar(mlir_file, func_name, a, dtype):
    """
    a: int or np.int32
    dtype: "i32" / "index"
    """
    vmfb_folder = os.path.join(os.path.dirname(mlir_file), "IndexCast_scalar")
    os.makedirs(vmfb_folder, exist_ok=True)
    vmfb_file = os.path.join(vmfb_folder, f"IndexCast_dlc.vmfb")
    dump_file = os.path.join(vmfb_folder, "IndexCast_dlc_dump.txt")

    # compile
    compile_cmd = f"iree-compile --iree-hal-target-backends=dlc --mlir-print-ir-after-all {mlir_file} -o {vmfb_file}"
    compile_result = subprocess.run(
        compile_cmd,
        shell=True,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    with open(dump_file, "w") as f:
        f.write("=== STDOUT ===\n")
        f.write(compile_result.stdout)
        f.write("\n=== STDERR ===\n")
        f.write(compile_result.stderr)

    # run
    # 保证 DLC 输入为有符号 int32
    run_cmd = f"iree-run-module --module={vmfb_file} --function={func_name} --device=dlc --input={int(a)}:{dtype}"
    result = subprocess.run(run_cmd, shell=True, check=True, stdout=subprocess.PIPE, text=True)

    for line in result.stdout.splitlines():
        if "result" in line:
            val_str = line.split(":")[-1].strip()
            if "=" in val_str:
                val_str = val_str.split("=", 1)[1]
            return int(val_str)
    raise RuntimeError(f"Failed to parse DLC output:\n{result.stdout}")

# ---------- tests ----------
def test_index_to_i32():
    mlir_file = os.path.join(os.path.dirname(__file__), "IndexCast.mlir")
    for a, name in make_index_to_i32_cases():
        cpu_val = index_to_i32_ref(a)
        tpu_val = run_dlc_scalar(mlir_file, "index_to_i32", a, "i32")
        _write_result_to_file(name, a, cpu_val, tpu_val)
        assert cpu_val == tpu_val

def test_i32_to_index():
    mlir_file = os.path.join(os.path.dirname(__file__), "IndexCast.mlir")
    for a, name, ub in make_i32_to_index_cases():
        cpu_val = i32_to_index_ref(a)
        if ub and a < 0:
            # skip UB but dump for info
            _write_result_to_file(name, a, 'UB', 'UB')
            continue
        tpu_val = run_dlc_scalar(mlir_file, "i32_to_index", a, "i32")
        _write_result_to_file(name, a, cpu_val, tpu_val)
        assert cpu_val == tpu_val


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/IndexCast/IndexCast.py