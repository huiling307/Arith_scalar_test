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
    "arith_scalar_test/OrI/ori_scalar_results.txt"
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
def ori_i32(a, b):
    return jnp.bitwise_or(a, b)

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
        f"[{dtype}] ori mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

# ======================================================
# Test cases
# ======================================================

def i32(x):
    return jnp.int32(x)

def make_ori_i32_cases():
    info = np.iinfo(np.int32)
    return [
        # trivial
        (i32(0), i32(0), "zero_zero"),
        (i32(0), i32(1), "zero_one"),
        (i32(1), i32(0), "one_zero"),

        # basic bits
        (i32(0b0101), i32(0b0011), "basic_or"),
        (i32(0b1010), i32(0b0101), "complement_bits"),

        # negatives (two's complement)
        (i32(-1), i32(0), "minus_one_or_zero"),
        (i32(-1), i32(1), "minus_one_or_one"),
        (i32(-2), i32(1), "minus_two_or_one"),

        # boundaries
        (i32(info.max), i32(0), "max_or_zero"),
        (i32(info.min), i32(0), "min_or_zero"),
        (i32(info.min), i32(info.max), "min_or_max"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_ori_i32_cases(),
)
def test_ori_scalar_i32(a, b, name):
    run_single_test_scalar(
        ori_i32,
        a,
        b,
        name,
        dtype=jnp.int32,
    )

#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/OrI/OrI.py::test_ori_scalar_i32