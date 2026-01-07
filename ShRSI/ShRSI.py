import jax
import jax.numpy as jnp
import pytest
import numpy as np
import os
from datetime import datetime

# ======================================================
# Result dump
# ======================================================

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/ShRSI/shrsi_scalar_results.txt"
)


def _write_result_to_file(dtype, name, a, b, cpu, tpu):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"dtype : {dtype}\n"
            f"case  : {name}\n"
            f"input : a={a}, b={b}\n"
            f"CPU   : {cpu}\n"
            f"TPU   : {tpu}\n"
            f"{'-'*60}\n"
        )

# ======================================================
# Kernel
# ======================================================

@jax.jit
def shrsi_i32(a, b):
    return a >> b

# ======================================================
# Utils
# ======================================================

def _to_cpu(x):
    return jax.device_put(x, jax.devices("cpu")[0])


def run_single_test_scalar(jit_func, a, b, name, dtype):
    # ---------------- CPU reference ----------------
    with jax.default_device(jax.devices("cpu")[0]):
        ref = jit_func(a, b)

    # ---------------- TPU / DLC ----------------
    dlc_dev = jax.devices("iree_dlc")[0]
    a_dlc = jax.device_put(a, dlc_dev)
    b_dlc = jax.device_put(b, dlc_dev)
    out = jit_func(a_dlc, b_dlc)
    out = _to_cpu(out)

    ref_val = int(np.asarray(ref).item())
    out_val = int(np.asarray(out).item())

    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=int(a),
        b=int(b),
        cpu=ref_val,
        tpu=out_val,
    )

    assert ref_val == out_val, (
        f"[{dtype}] shrsi mismatch in case {name}\n"
        f"CPU={ref_val}, TPU={out_val}"
    )

# ======================================================
# Test cases
# ======================================================

def i32(x):
    return jnp.int32(x)


def make_shrsi_i32_cases():
    i32_info = np.iinfo(np.int32)

    return [
        # trivial
        (i32(0), i32(0), "zero_shift_zero"),
        (i32(1), i32(0), "one_shift_zero"),
        (i32(1), i32(1), "one_shift_one"),

        # positive numbers
        (i32(8), i32(1), "eight_shift_one"),
        (i32(8), i32(2), "eight_shift_two"),
        (i32(7), i32(1), "seven_shift_one"),

        # negative numbers (sign extension)
        (i32(-1), i32(1), "minus_one_shift_one"),
        (i32(-1), i32(31), "minus_one_shift_31"),
        (i32(-2), i32(1), "minus_two_shift_one"),

        # MSB set values
        (i32(i32_info.min), i32(1), "min_shift_one"),
        (i32(i32_info.min), i32(31), "min_shift_31"),

        # mixed patterns
        (i32(-2147483648), i32(4), "msb_only_shift_four"),
        (i32(-123456789), i32(3), "negative_random_shift_three"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_shrsi_i32_cases(),
)
def test_shrsi_scalar_i32(a, b, name):
    run_single_test_scalar(
        shrsi_i32,
        a,
        b,
        name,
        dtype=jnp.int32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/ShRSI/ShRSI.py::test_shrsi_scalar_i32