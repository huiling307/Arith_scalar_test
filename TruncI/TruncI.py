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
    "arith_scalar_test/TruncI/trunci_scalar_results.txt"
)

def _write_result_to_file(dtype, name, a, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"dtype : {dtype}\n"
            f"case  : {name}\n"
            f"input : a={a}\n"
            f"CPU   : {cpu_val}\n"
            f"TPU   : {tpu_val}\n"
            + "-"*60 + "\n"
        )

# ======================================================
# Utils
# ======================================================

def _to_cpu(x):
    return jax.device_put(x, jax.devices("cpu")[0])

def run_single_test_scalar(jit_func, a, name, dtype):
    # ---------------- CPU reference ----------------
    with jax.default_device(jax.devices("cpu")[0]):
        ref = jit_func(a)

    # ---------------- TPU / DLC ----------------
    dlc_dev = jax.devices("iree_dlc")[0]
    a_dlc = jax.device_put(a, dlc_dev)
    out = jit_func(a_dlc)
    out = _to_cpu(out)

    # ---------------- WRITE TO FILE ----------------
    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=a,
        cpu_val=ref,
        tpu_val=out,
    )

    # ---------------- semantic check ----------------
    assert ref == out, (
        f"[{dtype}] TruncI mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

# ======================================================
# Kernel
# ======================================================

@jax.jit
def trunci(x: jnp.int32) -> jnp.int16:
    return x.astype(jnp.int16)

# ======================================================
# Edge case generator
# ======================================================

def make_trunci_edge_cases():
    i16_info = np.iinfo(np.int16)
    i32_info = np.iinfo(np.int32)

    i32 = lambda x: np.int32(x)

    return [
        # trivial
        (i32(0), "zero"),
        (i32(1), "one"),
        (i32(-1), "minus_one"),

        # in-range (no truncation)
        (i32(i16_info.min), "i16_min_exact"),
        (i32(i16_info.max), "i16_max_exact"),

        # truncation (low bits kept)
        (i32(i16_info.max + 1), "i16_max_plus_one"),
        (i32(i16_info.min - 1), "i16_min_minus_one"),

        # pattern bits
        (i32(0x0000FFFF), "low_16_bits_all_ones"),
        (i32(-65536), "high_16_bits_all_ones"),
        (i32(0x12345678), "mixed_bits"),

        # large extremes
        (i32(i32_info.max), "i32_max"),
        (i32(i32_info.min), "i32_min"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, name",
    make_trunci_edge_cases()
)
def test_trunci_scalar(a, name):
    run_single_test_scalar(
        trunci,
        a,
        name,
        jnp.int16
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/TruncI/TruncI.py::test_trunci_scalar