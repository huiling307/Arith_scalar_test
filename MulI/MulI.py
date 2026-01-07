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
    "arith_scalar_test/MulI/muli_scalar_results.txt"
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

    # ---------------- WRITE ----------------
    _write_result_to_file(dtype, name, a, b, ref, out)

    # ---------------- semantic check ----------------
    # muli: wrap-around, exact integer equality
    assert out == ref, (
        f"[{dtype}] muli mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )


# ======================================================
# Kernels
# ======================================================

@jax.jit
def muli_i32(a, b):
    return a * b

@jax.jit
def muli_u32(a, b):
    return a * b


# ======================================================
# Edge cases
# ======================================================


def u32(x):
    return jnp.uint32(x)



def make_muli_u32_cases():
    info = np.iinfo(np.uint32)
    return [
        (u32(0), u32(0), "zero_zero"),
        (u32(1), u32(7), "one_seven"),
        (u32(2), u32(3), "two_three"),

        # identity
        (u32(1), u32(info.max), "mul_one_max"),

        # overflow (wrap-around)
        (u32(info.max), u32(2), "overflow_wrap"),
        (u32(info.max), u32(info.max), "max_times_max"),
    ]


# ======================================================
# Tests
# ======================================================



@pytest.mark.parametrize(
    "a, b, name",
    make_muli_u32_cases(),
)
def test_muli_scalar_u32(a, b, name):
    run_single_test_scalar(
        muli_u32,
        a,
        b,
        name,
        dtype=jnp.uint32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/MulI/MulI.py::test_muli_scalar_u32