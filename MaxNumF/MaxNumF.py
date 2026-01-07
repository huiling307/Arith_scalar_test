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
    "arith_scalar_test/MaxNumF/maxnumf_scalar_results.txt"
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
def maxnumf(a, b):
    return jax.lax.max(a, b)

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

    ref_val = float(np.asarray(ref).item())
    out_val = float(np.asarray(out).item())

    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=float(a),
        b=float(b),
        cpu=ref_val,
        tpu=out_val,
    )

    # NaN 处理：NaN != NaN
    if np.isnan(ref_val) and np.isnan(out_val):
        return
    assert ref_val == out_val, (
        f"[{dtype}] maxnumf mismatch in case {name}\n"
        f"CPU={ref_val}, TPU={out_val}"
    )

# ======================================================
# Test cases
# ======================================================

def f32(x):
    return jnp.float32(x)

def make_maxnumf_f32_cases():
    return [
        (f32(0.0),  f32(0.0),   "zero_zero"),
        (f32(1.0),  f32(2.0),   "one_two"),
        (f32(-1.0), f32(1.0),   "minus_one_one"),

        # signed zero
        (f32(0.0),  f32(-0.0),  "pos_zero_neg_zero"),
        (f32(-0.0), f32(0.0),   "neg_zero_pos_zero"),

        # infinities
        (f32(np.inf),  f32(1.0),     "pos_inf_one"),
        (f32(-np.inf), f32(1.0),     "neg_inf_one"),
        (f32(np.inf),  f32(-np.inf), "pos_inf_neg_inf"),

        # NaNs (DIFFERENT from minnumf!)
        (f32(np.nan), f32(1.0),      "nan_one"),
        (f32(1.0),    f32(np.nan),   "one_nan"),
        (f32(np.nan), f32(np.nan),   "nan_nan"),

        # equal
        (f32(3.5), f32(3.5), "equal_values"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_maxnumf_f32_cases(),
)
def test_maxnumf_scalar_f32(a, b, name):
    run_single_test_scalar(
        maxnumf,
        a,
        b,
        name,
        dtype=jnp.float32,
    )



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/MaxNumF/MaxNumF.py::test_maxnumf_scalar_f32