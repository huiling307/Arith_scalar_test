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
    "arith_scalar_test/SubF/subf_scalar_results.txt"
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
def subf_f32(a, b):
    return a - b

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
    # normal float compare
    return np.allclose(a, b, rtol=0, atol=0)


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
        a=float(a),
        b=float(b),
        cpu=ref,
        tpu=out,
    )

    assert _float_equal(ref, out), (
        f"[{dtype}] subf mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

# ======================================================
# Test cases
# ======================================================

def f32(x):
    return jnp.float32(x)


def make_subf_f32_cases():
    return [
        # trivial
        (f32(0.0), f32(0.0), "zero_minus_zero"),
        (f32(1.0), f32(0.0), "one_minus_zero"),
        (f32(0.0), f32(1.0), "zero_minus_one"),

        # basic arithmetic
        (f32(5.0), f32(3.0), "five_minus_three"),
        (f32(3.0), f32(5.0), "three_minus_five"),

        # negatives
        (f32(-1.0), f32(1.0), "minus_one_minus_one"),
        (f32(-5.0), f32(-3.0), "minus_five_minus_minus_three"),

        # fractional
        (f32(1.5), f32(0.5), "fractional"),
        (f32(1.0), f32(1.0), "self_cancel"),

        # rounding sensitive
        (f32(1.0000001), f32(1.0), "rounding_sensitive"),

        # infinities
        (f32(np.inf), f32(1.0), "inf_minus_one"),
        (f32(1.0), f32(np.inf), "one_minus_inf"),

        # NaN propagation
        (f32(np.nan), f32(1.0), "nan_minus_one"),
        (f32(1.0), f32(np.nan), "one_minus_nan"),

        # signed zero
        (f32(0.0), f32(-0.0), "pos_zero_minus_neg_zero"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_subf_f32_cases(),
)
def test_subf_scalar_f32(a, b, name):
    run_single_test_scalar(
        subf_f32,
        a,
        b,
        name,
        dtype=jnp.float32,
    )



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/SubF/SubF.py::test_subf_scalar_f32