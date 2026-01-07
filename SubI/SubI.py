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
    "arith_scalar_test/SubI/subi_scalar_results.txt"
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
def subi_i32(a, b):
    return a - b

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

    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=int(a),
        b=int(b),
        cpu=ref,
        tpu=out,
    )

    assert ref == out, (
        f"[{dtype}] subi mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

# ======================================================
# Test cases
# ======================================================

def i32(x):
    return jnp.int32(x)


def make_subi_i32_cases():
    i32_info = np.iinfo(np.int32)

    return [
        # trivial
        (i32(0), i32(0), "zero_minus_zero"),
        (i32(1), i32(0), "one_minus_zero"),
        (i32(0), i32(1), "zero_minus_one"),

        # basic arithmetic
        (i32(5), i32(3), "five_minus_three"),
        (i32(3), i32(5), "three_minus_five"),

        # negatives
        (i32(-1), i32(1), "minus_one_minus_one"),
        (i32(-5), i32(-3), "minus_five_minus_minus_three"),

        # wraparound behavior (mod 2^32)
        (i32(i32_info.min), i32(1), "min_minus_one_wrap"),
        (i32(i32_info.max), i32(-1), "max_minus_minus_one_wrap"),

        # bit-pattern sensitive
        (i32(-1), i32(1), "all_ones_minus_one"),
        (i32(0x7FFFFFFF), i32(-1), "max_minus_all_ones"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_subi_i32_cases(),
)
def test_subi_scalar_i32(a, b, name):
    run_single_test_scalar(
        subi_i32,
        a,
        b,
        name,
        dtype=jnp.int32,
    )



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/SubI/SubI.py::test_subi_scalar_i32