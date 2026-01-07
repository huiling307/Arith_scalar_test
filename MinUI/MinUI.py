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
    "arith_scalar_test/MinUI/minui_scalar_results.txt"
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
        f"[{dtype}] minui mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )


# ======================================================
# Kernel
# ======================================================

@jax.jit
def minui(a, b):
    return jnp.minimum(a, b)


# ======================================================
# Edge cases
# ======================================================

def u32(x):
    return jnp.uint32(x)


def make_minui_u32_cases():
    info = np.iinfo(np.uint32)

    return [
        (u32(0),  u32(0),  "zero_zero"),
        (u32(1),  u32(2),  "one_two"),
        (u32(7),  u32(3),  "seven_three"),

        # boundaries
        (u32(info.max), u32(0),        "u32_max_zero"),
        (u32(info.max), u32(1),        "u32_max_one"),
        (u32(info.max), u32(info.max), "u32_max_u32_max"),

        # wrap-style interesting values
        (u32(0),  u32(info.max), "zero_u32_max"),

        # equal
        (u32(42), u32(42), "equal_values"),
    ]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_minui_u32_cases(),
)
def test_minui_scalar_u32(a, b, name):
    run_single_test_scalar(
        minui,
        a,
        b,
        name,
        dtype=jnp.uint32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/MinUI/MinUI.py::test_minui_scalar_u32