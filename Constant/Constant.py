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
    "arith_scalar_test/Constant/constant_scalar_results.txt"
)


def _write_result_to_file(dtype, name, val, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"dtype : {dtype}\n"
            f"case  : {name}\n"
            f"value : {val}\n"
            f"CPU   : {cpu_val}\n"
            f"TPU   : {tpu_val}\n"
            f"{'-'*60}\n"
        )


# ======================================================
# Utils
# ======================================================

def _to_cpu(x):
    return jax.device_put(x, jax.devices("cpu")[0])


def run_single_constant_test(jit_func, expected, name, dtype):
    # ---------------- CPU ----------------
    with jax.default_device(jax.devices("cpu")[0]):
        ref = jit_func()

    # ---------------- TPU / DLC ----------------
    dlc_dev = jax.devices("iree_dlc")[0]
    out = jax.device_put(jit_func(), dlc_dev)
    out = _to_cpu(out)

    ref = np.asarray(ref).item()
    out = np.asarray(out).item()

    _write_result_to_file(
        dtype=dtype,
        name=name,
        val=expected,
        cpu_val=ref,
        tpu_val=out,
    )

    # ---------------- semantic check ----------------
    if isinstance(ref, float) and np.isnan(ref):
        assert np.isnan(out), (
            f"[{dtype}] constant NaN mismatch in case {name}\n"
            f"CPU={ref}, TPU={out}"
        )
    else:
        assert ref == out, (
            f"[{dtype}] constant mismatch in case {name}\n"
            f"CPU={ref}, TPU={out}"
        )

# ======================================================
# Constant kernels
# ======================================================

def make_const_kernel(val, dtype):
    @jax.jit
    def _kernel():
        return jnp.array(val, dtype=dtype)
    return _kernel


# ======================================================
# Integer edge cases
# ======================================================

INT_CASES = [
    # i32
    (jnp.int32, 0, "i32_zero"),
    (jnp.int32, 1, "i32_one"),
    (jnp.int32, -1, "i32_minus_one"),
    (jnp.int32, 2**31 - 1, "i32_max"),
    (jnp.int32, -2**31, "i32_min"),
]


# ======================================================
# Floating-point edge cases
# ======================================================

FLOAT_CASES = [
    # f32
    (jnp.float32, 0.0, "f32_zero"),
    (jnp.float32, -0.0, "f32_neg_zero"),
    (jnp.float32, 1.0, "f32_one"),
    (jnp.float32, -1.0, "f32_minus_one"),
    (jnp.float32, np.inf, "f32_pos_inf"),
    (jnp.float32, -np.inf, "f32_neg_inf"),
    (jnp.float32, np.nan, "f32_nan"),
]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize("dtype,val,name", INT_CASES)
def test_constant_integer(dtype, val, name):
    kernel = make_const_kernel(val, dtype)
    run_single_constant_test(kernel, val, name, dtype)


@pytest.mark.parametrize("dtype,val,name", FLOAT_CASES)
def test_constant_float(dtype, val, name):
    kernel = make_const_kernel(val, dtype)
    run_single_constant_test(kernel, val, name, dtype)


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/Constant/Constant.py::test_constant_integer && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/Constant/Constant.py::test_constant_float
