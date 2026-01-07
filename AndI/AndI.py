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
    "arith_scalar_test/AndI/andi_scalar_results.txt"
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
        f"[{dtype}] AndI mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )


# ======================================================
# Kernel
# ======================================================

@jax.jit
def elementwise_and_i32(a, b):
    return a & b


# ======================================================
# Edge case generator (int32)
# ======================================================

def make_andi_i32_edge_cases():
    info = np.iinfo(np.int32)

    def i32(x):
        return np.array(x, dtype=np.uint32).view(np.int32)[()]

    cases = [
        (0, 0, "zero_and_zero"),
        (1, 1, "one_and_one"),
        (1, 0, "one_and_zero"),

        (info.max, info.max, "max_and_max"),
        (info.min, info.min, "min_and_min"),

        (info.max, 0, "max_and_zero"),
        (info.min, 0, "min_and_zero"),

        (i32(0xAAAAAAAA), i32(0x55555555), "alternating_bits"),
        (i32(0xFFFFFFFF), i32(0x0F0F0F0F), "full_mask_and_partial"),
        (i32(0x80000000), i32(0x7FFFFFFF), "sign_bit_and_rest"),

        (-1, 1, "neg_one_and_one"),
        (-1, 0, "neg_one_and_zero"),
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
    make_andi_i32_edge_cases(),
)
def test_andi_scalar_i32(a, b, name):
    run_single_test_scalar(
        elementwise_and_i32,
        a,
        b,
        name,
        jnp.int32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/AndI/AndI.py::test_andi_scalar_i32