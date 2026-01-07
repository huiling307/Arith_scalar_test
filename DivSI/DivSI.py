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
    "arith_scalar_test/DivSI/divsi_scalar_results.txt"
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
        f"[{dtype}] DivSI mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

# ======================================================
# Kernel
# ======================================================

@jax.jit
def divsi(a: jnp.int32, b: jnp.int32) -> jnp.int32:
    return jax.lax.div(a, b)

# ======================================================
# Test cases
# ======================================================

info = np.iinfo(np.int32)

cases = [
    # ---------------- basic ----------------
    (0, 1, "zero_div_one"),
    (0, -1, "zero_div_neg_one"),

    (1, 1, "one_div_one"),
    (1, 2, "one_div_two"),
    (2, 1, "two_div_one"),

    # ---------------- sign combinations ----------------
    (7, 2, "pos_pos"),
    (7, -2, "pos_neg"),
    (-7, 2, "neg_pos"),
    (-7, -2, "neg_neg"),

    # ---------------- trunc toward zero ----------------
    (7, 3, "pos_pos_trunc"),
    (-7, 3, "neg_pos_trunc"),
    (7, -3, "pos_neg_trunc"),
    (-7, -3, "neg_neg_trunc"),

    # ---------------- boundaries ----------------
    (info.max, 1, "max_div_one"),
    (info.min , 1, "min_div_one"),
    (info.max, -1, "max_div_neg_one"),
    (info.min + 1, -1, "min_plus_one_div_neg_one"),
]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    [(jnp.int32(a), jnp.int32(b), name) for a, b, name in cases]
)
def test_divsi_scalar(a, b, name):
    run_single_test_scalar(
        divsi,
        a,
        b,
        name,
        jnp.int32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/DivSI/DivSI.py::test_divsi_scalar
