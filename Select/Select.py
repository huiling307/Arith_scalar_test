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
    "arith_scalar_test/Select/select_scalar_results.txt"
)

def _write_result_to_file(dtype, name, cond, a, b, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"dtype : {dtype}\n"
            f"case  : {name}\n"
            f"input : cond={cond}, a={a}, b={b}\n"
            f"CPU   : {cpu_val}\n"
            f"TPU   : {tpu_val}\n"
            + "-"*60 + "\n"
        )

# ======================================================
# Utils
# ======================================================

def _to_cpu(x):
    return jax.device_put(x, jax.devices("cpu")[0])

def run_single_test_scalar(jit_func, cond, a, b, name, dtype):
    # ---------------- CPU reference ----------------
    with jax.default_device(jax.devices("cpu")[0]):
        ref = jit_func(cond, a, b)

    # ---------------- TPU / DLC ----------------
    dlc_dev = jax.devices("iree_dlc")[0]
    cond_dlc = jax.device_put(cond, dlc_dev)
    a_dlc = jax.device_put(a, dlc_dev)
    b_dlc = jax.device_put(b, dlc_dev)
    out = jit_func(cond_dlc, a_dlc, b_dlc)
    out = _to_cpu(out)

    # ---------------- WRITE TO FILE ----------------
    _write_result_to_file(
        dtype=dtype,
        name=name,
        cond=cond,
        a=a,
        b=b,
        cpu_val=ref,
        tpu_val=out,
    )

    # ---------------- semantic check ----------------
    assert ref == out, (
        f"[{dtype}] Select mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

# ======================================================
# Kernel
# ======================================================

@jax.jit
def select_scalar(cond_i32: jnp.int32, a: jnp.int32, b: jnp.int32) -> jnp.int32:
    cond_bool = cond_i32 != 0
    return jnp.where(cond_bool, a, b)

# ======================================================
# Test cases
# ======================================================

cases = [
    # basic
    (np.int32(1),  np.int32(1),  np.int32(2),  "cond_true_pick_a"),
    (np.int32(0),  np.int32(1),  np.int32(2),  "cond_false_pick_b"),

    # zeros
    (np.int32(1),  np.int32(0),  np.int32(42), "true_pick_zero"),
    (np.int32(0),  np.int32(42), np.int32(0),  "false_pick_zero"),

    # negatives
    (np.int32(1),  np.int32(-1), np.int32(7),  "true_pick_negative"),
    (np.int32(0),  np.int32(7),  np.int32(-1), "false_pick_negative"),

    # extreme values
    (np.int32(1),  np.int32(0x7fffffff), np.int32(-1), "true_pick_max"),
    (np.int32(0),  np.int32(-1), np.int32(-2147483648), "false_pick_min"),

    # identical operands
    (np.int32(1),  np.int32(5), np.int32(5), "same_values_true"),
    (np.int32(0),  np.int32(5), np.int32(5), "same_values_false"),
]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize("cond, a, b, name", cases)
def test_select_scalar(cond, a, b, name):
    run_single_test_scalar(
        select_scalar,
        cond,
        a,
        b,
        name,
        jnp.int32
    )



#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/Select/Select.py::test_select_scalar