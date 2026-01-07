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
    "arith_scalar_test/ShLI/shli_scalar_results.txt"
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
def shli_i32(a, b):
    return a << b

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
        f"[{dtype}] shli mismatch in case {name}\n"
        f"CPU={ref_val}, TPU={out_val}"
    )

# ======================================================
# Test cases
# ======================================================

def i32(x):
    return jnp.int32(x)


def make_shli_i32_cases():
    i32_info = np.iinfo(np.int32)

    return [
        # trivial
        (i32(0), i32(0), "zero_shift_zero"),
        (i32(1), i32(0), "one_shift_zero"),
        (i32(1), i32(1), "one_shift_one"),

        # basic shifts
        (i32(2), i32(1), "two_shift_one"),
        (i32(3), i32(2), "three_shift_two"),
        (i32(5), i32(3), "five_shift_three"),

        # sign bit interactions
        (i32(1), i32(31), "one_shift_31"),
        (i32(-1), i32(1), "minus_one_shift_one"),
        (i32(-1), i32(4), "minus_one_shift_four"),

        # wraparound behavior (mod 2^32)
        (i32(i32_info.max), i32(1), "max_shift_one_wrap"),
        (i32(i32_info.min), i32(1), "min_shift_one_wrap"),

        # bit-pattern sensitive
        (i32(0x40000000), i32(1), "bit30_shift_one"),
        (i32(0x10000000), i32(4), "bit28_shift_four"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_shli_i32_cases(),
)
def test_shli_scalar_i32(a, b, name):
    run_single_test_scalar(
        shli_i32,
        a,
        b,
        name,
        dtype=jnp.int32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/ShLI/ShLI.py::test_shli_scalar_i32