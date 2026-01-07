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
    "arith_scalar_test/RemUI/remui_scalar_results.txt"
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
def remui_u32(a, b):
    return a % b

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

    ref_val = int(np.asarray(ref).item())
    out_val = int(np.asarray(out).item())

    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=int(a),
        b=int(b),
        cpu=ref_val,
        tpu=out_val,
    )

    assert ref_val == out_val, (
        f"[{dtype}] remui mismatch in case {name}\n"
        f"CPU={ref_val}, TPU={out_val}"
    )

# ======================================================
# Test cases
# ======================================================

def u32(x):
    return jnp.uint32(x)


def make_remui_u32_cases():
    u32_info = np.iinfo(np.uint32)

    return [
        (u32(7), u32(3), "basic"),
        (u32(6), u32(3), "exact_div"),
        (u32(2), u32(5), "lhs_lt_rhs"),
        (u32(u32_info.max), u32(1), "max_div_one"),
        (u32(u32_info.max), u32(2), "max_div_two"),
        (u32(u32_info.max), u32(u32_info.max), "max_div_max"),
        (u32(0x80000000), u32(2), "highbit_div_two"),
        (u32(0xFFFFFFFF), u32(0xFFFFFFFE), "all_ones_div_almost_all_ones"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_remui_u32_cases(),
)
def test_remui_scalar_u32(a, b, name):
    run_single_test_scalar(
        remui_u32,
        a,
        b,
        name,
        dtype=jnp.uint32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/RemUI/RemUI.py::test_remui_scalar_u32