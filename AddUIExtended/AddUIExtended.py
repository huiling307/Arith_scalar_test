import os
import numpy as np
from datetime import datetime
import pytest
import sys
TEST_RUNNER_PATH ="/root/iree/tests/e2e/dlc_specific"
CURRENT_PATH = os.path.dirname(__file__)
sys.path.append(TEST_RUNNER_PATH)
from test_runner import run_single_test

# ======================================================
# Result dump
# ======================================================

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/AddUIExtended/adduiextended_scalar_results.txt"
)

def _write_result_to_file(name, a, b, lo_cpu, hi_cpu, lo_dlc, hi_dlc):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"case  : {name}\n"
            f"input : a={a}, b={b}\n"
            f"CPU   : lo={lo_cpu}, hi={hi_cpu}\n"
            f"DLC   : lo={lo_dlc}, hi={hi_dlc}\n"
            f"{'-'*60}\n"
        )

# ======================================================
# Test cases
# ======================================================

info = np.iinfo(np.uint32)

def make_adduiextended_cases():
    return [
        (0, 0, "zero_plus_zero"),
        (1, 2, "normal_add"),
        (info.max, 0, "max_plus_zero"),
        (info.max, 1, "overflow_by_one"),
        (info.max, info.max, "max_plus_max"),
        (info.max - 1, 1, "edge_no_overflow"),
        (0xFFFFFFFF, 0xFFFFFFFF, "double_carry"),
    ]

# ======================================================
# CPU reference
# ======================================================

def adduiextended_ref(a, b):
    sum64 = np.uint64(a) + np.uint64(b)
    lo = np.uint32(sum64 & 0xFFFFFFFF)
    hi = np.uint32((sum64 >> 32) & 0xFFFFFFFF)
    return lo, hi

# ======================================================
# Run with run_single_test
# ======================================================


def run_dlc_with_run_single_test(mlir_file, a, b):
    """
    使用 run_single_test 运行 DLC 后端，获取 CeilDivSI 的标量输出
    """
    import numpy as np

    # 标量输入
    predefined_inputs = [np.int32(a), np.int32(b)]

    # run_single_test 返回输出文件路径列表
    output_fns = run_single_test(mlir_file, predefined_input_arrays=predefined_inputs, mode="scalar")

    if not output_fns or len(output_fns) == 0:
        raise RuntimeError("run_single_test 没有生成输出文件")

    # 读取第一个输出文件，CeilDivSI 只有一个输出标量
    out_file = output_fns[0]
    val = np.fromfile(out_file, dtype=np.int32)[0]
    return int(val)

# ======================================================
# Tests
# ======================================================

def test_adduiextended_scalar():
    mlir_file = os.path.join(
        os.path.dirname(__file__), "AddUIExtended.mlir"
    )

    for a, b, name in make_adduiextended_cases():
        # CPU 参考
        lo_cpu, hi_cpu = adduiextended_ref(a, b)

        # DLC 后端
        lo_dlc, hi_dlc = run_dlc_with_run_single_test(mlir_file, a, b)

        # 写入结果
        _write_result_to_file(name, a, b, lo_cpu, hi_cpu, lo_dlc, hi_dlc)

        # 检查正确性
        assert lo_cpu == lo_dlc, f"[{name}] lo mismatch: CPU={lo_cpu}, DLC={lo_dlc}"
        assert hi_cpu == hi_dlc, f"[{name}] hi mismatch: CPU={hi_cpu}, DLC={hi_dlc}"

# ======================================================
# Run standalone
# ======================================================

if __name__ == "__main__":
    test_adduiextended_scalar()
    print("All AddUIExtended scalar tests passed!")



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/AddUIExtended/AddUIExtended.py