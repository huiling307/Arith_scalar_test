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
    "arith_scalar_test/ShRUI/shrui_scalar_results.txt"
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
        f"[{dtype}] ShRUI mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

# ======================================================
# Kernel
# ======================================================

@jax.jit
def shrui(a: jnp.int32, b: jnp.int32) -> jnp.int32:
    return jax.lax.shift_right_logical(a, b)


# ======================================================
# Edge case generator
# ======================================================

i32_info = np.iinfo(np.int32)

def make_shrui_edge_cases():
    return [
        # trivial
        (np.int32(0), np.int32(0), "zero_shift_zero"),
        (np.int32(0), np.int32(1), "zero_shift_one"),

        # basic shifts
        (np.int32(1), np.int32(0), "one_shift_zero"),
        (np.int32(1), np.int32(1), "one_shift_one"),
        (np.int32(8), np.int32(1), "eight_shift_one"),
        (np.int32(8), np.int32(3), "eight_shift_three"),

        # unsigned semantics on negative values
        (np.int32(-1), np.int32(1), "all_ones_shift_one"),
        (np.int32(-1), np.int32(31), "all_ones_shift_31"),
        (np.int32(-2), np.int32(1), "minus_two_shift_one"),

        # boundary bits
        (np.int32(-2147483648), np.int32(1), "msb_only_shift_one"),
        (np.int32(-2147483648), np.int32(31), "msb_only_shift_31"),

        # no-op large value
        (np.int32(i32_info.max), np.int32(0), "max_shift_zero"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_shrui_edge_cases()
)
def test_shrui_scalar(a, b, name):
    run_single_test_scalar(
        shrui,
        a,
        b,
        name,
        jnp.int32
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/ShRUI/ShRUI.py::test_shrui_scalar