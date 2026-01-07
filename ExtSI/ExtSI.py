import os
import subprocess
import numpy as np
import jax
import jax.numpy as jnp
from datetime import datetime
import pytest

# ======================================================
# Result dump
# ======================================================
RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/ExtSI/extsi_scalar_results.txt"
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
def extsi(a):
    return jax.lax.convert_element_type(a, jnp.int32)

# ======================================================
# Utils
# ======================================================
def i8(x):
    return jnp.int8(x)

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
    assert ref_val == out_val, f"[{dtype}] extsi mismatch in case {name}, CPU={ref_val}, TPU={out_val}"

# ======================================================
# Test cases
# ======================================================
def make_extsi_cases():
    return [
        (i8(0),     "zero"),
        (i8(1),     "one"),
        (i8(2),     "two"),
        (i8(127),   "max_positive_i8"),
        (i8(-1),    "minus_one"),
        (i8(-2),    "minus_two"),
        (i8(-128),  "min_i8"),
    ]

# ======================================================
# Tests
# ======================================================
@pytest.mark.parametrize(
    "a, name",
    make_extsi_cases()
)
def test_extsi_scalar(a, name):
    run_single_test_scalar(
        extsi,
        a,
        name,
        dtype=jnp.int32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/ExtSI/ExtSI.py::test_extsi_scalar