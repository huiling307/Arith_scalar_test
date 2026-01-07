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
    "arith_scalar_test/MulF/mulf_scalar_results.txt"
)


def _write_result_to_file(dtype, name, a, b, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"dtype : {dtype}\n"
            f"case  : {name}\n"
            f"input : a={a}, b={b}\n"
            f"CPU   : {cpu_val}\n"
            f"TPU   : {tpu_val}\n"
            f"{'-'*60}\n"
        )


# ======================================================
# Utils
# ======================================================

def _to_cpu(x):
    return jax.device_put(x, jax.devices("cpu")[0])


def mulf_ref(a, b):
    """CPU reference: strict IEEE float32 mul"""
    a_np = np.float32(a)
    b_np = np.float32(b)
    return np.float32(a_np * b_np)


def run_single_test_scalar(jit_func, a, b, name, dtype):
    # ---------------- CPU reference ----------------
    cpu_val = mulf_ref(a, b)
    cpu_val = np.asarray(cpu_val).item()

    # ---------------- TPU / DLC ----------------
    dlc_dev = jax.devices("iree_dlc")[0]
    a_dlc = jax.device_put(a, dlc_dev)
    b_dlc = jax.device_put(b, dlc_dev)

    tpu_val = jit_func(a_dlc, b_dlc)
    tpu_val = _to_cpu(tpu_val)
    tpu_val = np.asarray(tpu_val).item()

    # ---------------- WRITE ----------------
    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=float(a),
        b=float(b),
        cpu_val=cpu_val,
        tpu_val=tpu_val,
    )

    # ---------------- semantic check ----------------

    # NaN propagation
    if np.isnan(cpu_val):
        assert np.isnan(tpu_val), (
            f"[{dtype}] mulf NaN mismatch in case {name}\n"
            f"CPU={cpu_val}, TPU={tpu_val}"
        )
        return

    # signed zero
    if cpu_val == 0.0 and tpu_val == 0.0:
        assert np.signbit(cpu_val) == np.signbit(tpu_val), (
            f"[{dtype}] mulf signed-zero mismatch in case {name}\n"
            f"CPU={cpu_val}, TPU={tpu_val}"
        )
        return

    # exact match (IEEE mulf is deterministic here)
    assert tpu_val == cpu_val, (
        f"[{dtype}] mulf mismatch in case {name}\n"
        f"CPU={cpu_val}, TPU={tpu_val}"
    )


# ======================================================
# Kernel
# ======================================================

@jax.jit
def mulf(a, b):
    return jnp.multiply(a, b)


# ======================================================
# Edge cases
# ======================================================

def f32(x):
    return jnp.float32(x)


def make_mulf_f32_cases():
    return [
        # basic
        (f32(0.0),  f32(0.0),  "zero_zero"),
        (f32(1.0),  f32(2.0),  "one_two"),
        (f32(-1.0), f32(2.0),  "minus_one_two"),
        (f32(-1.0), f32(-2.0), "minus_one_minus_two"),

        # signed zero
        (f32(0.0),  f32(1.0),   "pos_zero_one"),
        (f32(-0.0), f32(1.0),   "neg_zero_one"),
        (f32(0.0),  f32(-1.0),  "pos_zero_minus_one"),
        (f32(-0.0), f32(-1.0),  "neg_zero_minus_one"),

        # infinities
        (f32(np.inf),  f32(1.0),     "pos_inf_one"),
        (f32(-np.inf), f32(1.0),     "neg_inf_one"),
        (f32(np.inf),  f32(-1.0),    "pos_inf_minus_one"),
        (f32(np.inf),  f32(0.0),     "pos_inf_zero"),
        (f32(-np.inf), f32(0.0),     "neg_inf_zero"),

        # NaNs
        (f32(np.nan), f32(1.0),   "nan_one"),
        (f32(1.0),    f32(np.nan), "one_nan"),
        (f32(np.nan), f32(np.nan), "nan_nan"),

        # overflow / underflow
        (f32(1e20),   f32(1e20),   "overflow"),
        (f32(1e-20),  f32(1e-20),  "underflow"),

        # identity
        (f32(3.5),  f32(1.0),  "mul_one"),
        (f32(3.5),  f32(-1.0), "mul_minus_one"),
    ]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_mulf_f32_cases(),
)
def test_mulf_scalar_f32(a, b, name):
    run_single_test_scalar(
        mulf,
        a,
        b,
        name,
        dtype=jnp.float32,
    )



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/MulF/MulF.py::test_mulf_scalar_f32