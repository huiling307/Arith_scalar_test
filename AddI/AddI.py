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
    "arith_scalar_test/AddI/addi_scalar_results.txt"
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
    assert out == ref, (
        f"[{dtype}] AddI mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )


# ======================================================
# Kernel
# ======================================================

@jax.jit
def elementwise_add_i32(a, b):
    return a + b


# ======================================================
# Edge case generator (int32)
# ======================================================

def make_addi_i32_edge_cases():
    info = np.iinfo(np.int32)

    cases = [
        (1, 2, "normal_add"),
        (-1, 3, "neg_plus_pos"),

        (0, 0, "zero_plus_zero"),
        (0, 42, "zero_plus_pos"),
        (-42, 0, "neg_plus_zero"),

        (info.max, 0, "int_max_plus_zero"),
        (info.min, 0, "int_min_plus_zero"),

        (info.max, 1, "positive_overflow"),
        (info.min, -1, "negative_overflow"),

        (info.max, info.max, "max_plus_max"),
        (info.min, info.min, "min_plus_min"),
    ]

    return [
        (jnp.int32(a), jnp.int32(b), name)
        for a, b, name in cases
    ]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_addi_i32_edge_cases(),
)
def test_addi_scalar_i32(a, b, name):
    run_single_test_scalar(
        elementwise_add_i32,
        a,
        b,
        name,
        jnp.int32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/AddI/AddI.py::test_addi_scalar_i32
