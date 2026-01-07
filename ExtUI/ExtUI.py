import os
import subprocess
import numpy as np
import jax
import jax.numpy as jnp
from datetime import datetime

# ======================================================
# Result dump
# ======================================================
RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/ExtUI/extui_scalar_results.txt"
)

def _write_result_to_file(name, a, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"case  : {name}\n"
            f"input : a={int(a)}\n"
            f"CPU   : {int(cpu_val)}\n"
            f"TPU   : {int(tpu_val)}\n"
            f"{'-'*60}\n"
        )

# ======================================================
# Kernel
# ======================================================
@jax.jit
def extui(a):
    return jax.lax.convert_element_type(a, jnp.uint32)

# ======================================================
# Utils
# ======================================================
def u8(x):
    return jnp.uint8(x)

def _to_cpu(x):
    return jax.device_put(x, jax.devices("cpu")[0])

def run_single_test_scalar(jit_func, a, name, dtype):
    # ---------------- CPU reference ----------------
    with jax.default_device(jax.devices("cpu")[0]):
        ref = jit_func(a)

    # ---------------- DLC / TPU ----------------
    dlc_dev = jax.devices("iree_dlc")[0]
    a_dlc = jax.device_put(a, dlc_dev)
    out = jit_func(a_dlc)
    out = _to_cpu(out)

    ref_val = int(np.asarray(ref).item())
    out_val = int(np.asarray(out).item())

    _write_result_to_file(name, a, ref_val, out_val)
    assert ref_val == out_val, f"[{dtype}] extui mismatch in case {name}, CPU={ref_val}, TPU={out_val}"

# ======================================================
# Test cases
# ======================================================
def make_extui_cases():
    return [
        # ---------- basic ----------
        (u8(0),   "zero"),
        (u8(1),   "one"),
        (u8(2),   "two"),

        # ---------- boundary ----------
        (u8(127), "max_signed_u8"),
        (u8(128), "high_bit_set"),
        (u8(255), "all_ones"),

        # ---------- pattern ----------
        (u8(0x55), "pattern_01010101"),
        (u8(0xAA), "pattern_10101010"),
    ]

# ======================================================
# Tests
# ======================================================
import pytest

@pytest.mark.parametrize(
    "a, name",
    make_extui_cases()
)
def test_extui_scalar(a, name):
    run_single_test_scalar(
        extui,
        a,
        name,
        dtype=jnp.uint32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/ExtUI/ExtUI.py::test_extui_scalar