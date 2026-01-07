import os
import subprocess
import numpy as np
from datetime import datetime

def u32(x):
    return np.uint32(x)

info = np.iinfo(np.uint32)

cases = [
    (u32(0), u32(0), "zero_zero"),
    (u32(1), u32(7), "one_seven"),
    (u32(7), u32(7), "seven_seven"),

    # boundaries
    (u32(info.max), u32(1), "max_times_one"),
    (u32(info.max), u32(2), "max_times_two"),

    # full-width
    (u32(info.max), u32(info.max), "max_times_max"),

    # mixed
    (u32(0x80000000), u32(2), "highbit_times_two"),
    (u32(0xFFFFFFFF), u32(0xFFFFFFFF), "all_ones_times_all_ones"),
]

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/MulUIExtended/mului_extended_scalar_results.txt"
)

def _write_result_to_file(name, a, b, hi, lo):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"case  : {name}\n"
            f"input : a={a}, b={b}\n"
            f"HI    : {hi}\n"
            f"LO    : {lo}\n"
            f"{'-'*60}\n"
        )

def muluiextended_ref(a, b):
    full = np.uint64(a) * np.uint64(b)
    hi = np.uint32(full >> 32)
    lo = np.uint32(full & 0xFFFFFFFF)
    return hi, lo

def run_dlc_scalar(mlir_file, a, b):
    vmfb_folder = os.path.join(os.path.dirname(mlir_file), "MulUIExtended_scalar")
    os.makedirs(vmfb_folder, exist_ok=True)
    vmfb_file = os.path.join(vmfb_folder, "MulUIExtended_dlc.vmfb")

    # 编译
    compile_cmd = (
        f"iree-compile --iree-hal-target-backends=dlc "
        f"{mlir_file} -o {vmfb_file}"
    )
    subprocess.run(compile_cmd, shell=True, check=True)

    # 运行
    run_cmd = (
        f"iree-run-module --module={vmfb_file} --function=mului_extended "
        f"--device=dlc --input={a}:ui32 --input={b}:ui32"
    )
    result = subprocess.run(
        run_cmd,
        shell=True,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )

    hi = lo = None
    for line in result.stdout.splitlines():
        if "hi" in line.lower():
            hi = int(line.split(":")[-1].strip())
        if "lo" in line.lower():
            lo = int(line.split(":")[-1].strip())
    if hi is None or lo is None:
        raise RuntimeError(f"Failed to parse DLC output:\n{result.stdout}")
    return hi, lo

def test_mului_extended_scalar():
    mlir_file = os.path.join(os.path.dirname(__file__), "MulUIExtended.mlir")
    failed = []

    for a, b, name in cases:
        hi_ref, lo_ref = muluiextended_ref(a, b)
        hi_tpu, lo_tpu = run_dlc_scalar(mlir_file, a, b)

        _write_result_to_file(name, a, b, hi_tpu, lo_tpu)

        if hi_ref != hi_tpu or lo_ref != lo_tpu:
            failed.append(
                f"{name}: CPU=(hi={hi_ref}, lo={lo_ref}), TPU=(hi={hi_tpu}, lo={lo_tpu})"
            )

    if failed:
        raise AssertionError(
            "MulUIExtended mismatches:\n" + "\n".join(failed)
        )

if __name__ == "__main__":
    test_mului_extended_scalar()
    print("All MulUIExtended scalar tests passed!")


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/MulUIExtended/MulUIExtended.py