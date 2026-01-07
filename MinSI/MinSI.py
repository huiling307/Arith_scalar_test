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
    "arith_scalar_test/MinSI/minsi_scalar_results.txt"
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

    ref = np.asarray(ref).item()
    out = np.asarray(out).item()

    # ---------------- WRITE ----------------
    _write_result_to_file(dtype, name, a, b, ref, out)

    # ---------------- semantic check ----------------
    assert out == ref, (
        f"[{dtype}] minsi mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )


# ======================================================
# Kernel
# ======================================================

@jax.jit
def minsi(a, b):
    return jnp.minimum(a, b)


# ======================================================
# Edge cases
# ======================================================

def i32(x):
    return jnp.int32(x)


def make_minsi_i32_cases():
    info = np.iinfo(np.int32)

    return [
        (i32(0),  i32(0),  "zero_zero"),
        (i32(1),  i32(2),  "one_two"),
        (i32(-1), i32(1),  "minus_one_one"),
        (i32(-7), i32(-3), "minus_seven_minus_three"),

        # boundaries
        (i32(info.max), i32(0),         "i32_max_zero"),
        (i32(info.min), i32(0),         "i32_min_zero"),
        (i32(info.max), i32(info.min),  "i32_max_i32_min"),

        # equal
        (i32(42), i32(42), "equal_values"),
    ]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_minsi_i32_cases(),
)
def test_minsi_scalar_i32(a, b, name):
    run_single_test_scalar(
        minsi,
        a,
        b,
        name,
        dtype=jnp.int32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/MinSI/MinSI.py::test_minsi_scalar_i32