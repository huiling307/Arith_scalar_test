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
    "arith_scalar_test/SIToFP/sitofp_scalar_results.txt"
)


def _write_result_to_file(src_dtype, dst_dtype, name, a, cpu, tpu):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"from  : {src_dtype}\n"
            f"to    : {dst_dtype}\n"
            f"case  : {name}\n"
            f"input : a={a}\n"
            f"CPU   : {cpu}\n"
            f"TPU   : {tpu}\n"
            f"{'-'*60}\n"
        )

# ======================================================
# Kernel
# ======================================================

@jax.jit
def sitofp_i32_to_f32(a):
    return a.astype(jnp.float32)

# ======================================================
# Utils
# ======================================================

def _to_cpu(x):
    return jax.device_put(x, jax.devices("cpu")[0])


def _float_equal(a, b):
    # NaN == NaN
    if np.isnan(a) and np.isnan(b):
        return True
    # inf handling
    if np.isinf(a) or np.isinf(b):
        return a == b
    return np.allclose(a, b, rtol=0, atol=0)


def run_single_test_scalar(jit_func, a, name, src_dtype, dst_dtype):
    # ---------------- CPU reference ----------------
    with jax.default_device(jax.devices("cpu")[0]):
        ref = jit_func(a)

    # ---------------- TPU / DLC ----------------
    dlc_dev = jax.devices("iree_dlc")[0]
    a_dlc = jax.device_put(a, dlc_dev)
    out = jit_func(a_dlc)
    out = _to_cpu(out)

    ref_val = float(np.asarray(ref).item())
    out_val = float(np.asarray(out).item())

    _write_result_to_file(
        src_dtype=src_dtype,
        dst_dtype=dst_dtype,
        name=name,
        a=int(a),
        cpu=ref_val,
        tpu=out_val,
    )

    assert _float_equal(ref_val, out_val), (
        f"[{src_dtype} -> {dst_dtype}] sitofp mismatch in case {name}\n"
        f"CPU={ref_val}, TPU={out_val}"
    )

# ======================================================
# Test cases
# ======================================================

def i32(x):
    return jnp.int32(x)


def make_sitofp_i32_to_f32_cases():
    info = np.iinfo(np.int32)

    return [
        # trivial
        (i32(0), "zero"),
        (i32(1), "one"),
        (i32(-1), "minus_one"),

        # small integers
        (i32(2), "two"),
        (i32(-2), "minus_two"),
        (i32(123), "positive_small"),
        (i32(-123), "negative_small"),

        # exact boundary for f32 mantissa (2^24)
        (i32(2**24), "exact_mantissa_limit"),
        (i32(-(2**24)), "exact_mantissa_limit_negative"),

        # rounding required
        (i32(2**24 + 1), "rounding_positive"),
        (i32(-(2**24 + 1)), "rounding_negative"),

        # int32 boundaries
        (i32(info.max), "int32_max"),
        (i32(info.min), "int32_min"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, name",
    make_sitofp_i32_to_f32_cases(),
)
def test_sitofp_scalar_i32_to_f32(a, name):
    run_single_test_scalar(
        sitofp_i32_to_f32,
        a,
        name,
        src_dtype=jnp.int32,
        dst_dtype=jnp.float32,
    )



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/SIToFP/SIToFP.py::test_sitofp_scalar_i32_to_f32