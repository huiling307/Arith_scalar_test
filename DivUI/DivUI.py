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
    "arith_scalar_test/DivUI/divui_scalar_results.txt"
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
            + "-"*60 + "\n"
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

    # ---------------- WRITE TO FILE ----------------
    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=a,
        b=b,
        cpu_val=ref,
        tpu_val=out,
    )

    # ---------------- semantic check ----------------
    assert ref == out, (
        f"[{dtype}] DivUI mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

# ======================================================
# Kernel
# ======================================================

@jax.jit
def divui(a: jnp.uint32, b: jnp.uint32) -> jnp.uint32:
    return a//b

# ======================================================
# Edge case generator
# ======================================================

def make_divui_edge_cases():
    u32 = lambda x: np.uint32(x & 0xFFFFFFFF)
    i32_as_u32 = lambda x: np.uint32(np.int32(x).view(np.uint32))
    info = np.iinfo(np.int32)

    return [
        (u32(0), u32(1), "zero_div_one"),
        (u32(1), u32(1), "one_div_one"),
        (u32(1), u32(2), "one_div_two"),
        (u32(2), u32(1), "two_div_one"),
        (u32(7), u32(2), "seven_div_two"),
        (u32(7), u32(3), "seven_div_three"),
        (u32(info.max), u32(1), "max_div_one"),
        (u32(info.max), u32(2), "max_div_two"),
        (u32(info.max), u32(info.max), "max_div_max"),
        (u32(0x80000000), u32(1), "high_bit_div_one"),
        (u32(0x80000000), u32(2), "high_bit_div_two"),
        (i32_as_u32(-1), u32(1), "minus_one_bits_div_one"),
        (u32(6), i32_as_u32(-2), "six_div_minus_two_bits"),
        (u32(1), i32_as_u32(-1), "one_div_all_ones"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_divui_edge_cases()
)
def test_divui_scalar(a, b, name):
    run_single_test_scalar(
        divui,
        a,
        b,
        name,
        jnp.uint32
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/DivUI/DivUI.py::test_divui_scalar
