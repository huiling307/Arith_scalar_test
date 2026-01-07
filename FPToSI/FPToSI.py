import jax
import jax.numpy as jnp
import pytest
import numpy as np
import math

import os
from datetime import datetime

# ======================================================
# Result dump
# ======================================================

RESULT_DUMP_PATH = (
    "/root/iree/tests/e2e/dlc_specific/test_set/"
    "arith_scalar_test/FPToSI/fptosi_scalar_results.txt"
)


def _write_result_to_file(dtype, name, a, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)

    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"cast  : fptosi\n"
            f"dtype : {dtype}\n"
            f"case  : {name}\n"
            f"input : a={a}\n"
            f"CPU   : {cpu_val}\n"
            f"TPU   : {tpu_val}\n"
            f"{'-'*60}\n"
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

    ref = np.asarray(ref).item()
    out = np.asarray(out).item()

    # ---------------- WRITE ----------------
    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=float(a),
        cpu_val=ref,
        tpu_val=out,
    )

    # ---------------- semantic check ----------------
    # NaN / Inf / overflow are UB → do NOT assert equality
    if not np.isfinite(float(a)):
        return

    info = np.iinfo(np.int32)
    if float(a) >= info.max or float(a) <= info.min:
        return

    # well-defined region
    assert out == ref, (
        f"[{dtype}] FpToSI mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )


# ======================================================
# Kernel
# ======================================================

@jax.jit
def elementwise_fptosi_f32_to_i32(a):
    return a.astype(jnp.int32)


# ======================================================
# Edge case generator
# ======================================================

def f32(x):
    return jnp.float32(x)


def make_fptosi_f32_to_i32_edge_cases():
    return [
        # ---------------- exact integers ----------------
        (f32(0.0), "zero"),
        (f32(-0.0), "minus_zero"),
        (f32(1.0), "one"),
        (f32(-1.0), "minus_one"),

        # ---------------- fractional ----------------
        (f32(1.9), "pos_fraction_trunc"),
        (f32(-1.9), "neg_fraction_trunc"),
        (f32(0.9), "small_pos_fraction"),
        (f32(-0.9), "small_neg_fraction"),

        # ---------------- boundaries ----------------
        (f32(2**31 - 1), "int32_max_exact"),
        (f32(-(2**31)), "int32_min_exact"),

        # ---------------- UB cases (record only) ----------------
        (f32(np.nan), "nan"),
        (f32(np.inf), "pos_inf"),
        (f32(-np.inf), "neg_inf"),
        (f32(1e30), "overflow_pos"),
        (f32(-1e30), "overflow_neg"),
    ]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, name",
    make_fptosi_f32_to_i32_edge_cases(),
)
def test_fptosi_scalar_f32_to_i32(a, name):
    run_single_test_scalar(
        elementwise_fptosi_f32_to_i32,
        a,
        name,
        jnp.int32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/FPToSI/FPToSI.py::test_fptosi_scalar_f32_to_i32