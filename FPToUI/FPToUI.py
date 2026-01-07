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
    "arith_scalar_test/FPToUI/fptoui_scalar_results.txt"
)


def _write_result_to_file(dtype, name, a, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)

    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"cast  : fptoui\n"
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
    # UB cases: do NOT assert equality
    if not np.isfinite(float(a)):
        return

    if float(a) < 0:
        return

    info = np.iinfo(np.uint32)
    if float(a) > info.max:
        return

    # well-defined region
    assert out == ref, (
        f"[{dtype}] FpToUI mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )


# ======================================================
# Kernel
# ======================================================

@jax.jit
def elementwise_fptoui_f32_to_u32(a):
    return a.astype(jnp.uint32)


# ======================================================
# Edge case generator
# ======================================================

def f32(x):
    return jnp.float32(x)


def make_fptoui_f32_to_u32_edge_cases():
    return [
        # ---------------- exact integers ----------------
        (f32(0.0), "zero"),
        (f32(1.0), "one"),
        (f32(2.0), "two"),

        # ---------------- fractional ----------------
        (f32(1.9), "fraction_trunc"),
        (f32(0.9), "small_fraction"),

        # ---------------- boundaries ----------------
        (f32(4294967296.0), "overflow_exact_2pow32"),


        # ---------------- UB cases (record only) ----------------
        (f32(-1.0), "negative_one"),
        (f32(-0.9), "negative_fraction"),
        (f32(np.nan), "nan"),
        (f32(np.inf), "pos_inf"),
        (f32(-np.inf), "neg_inf"),
        (f32(1e30), "overflow_pos"),
    ]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, name",
    make_fptoui_f32_to_u32_edge_cases(),
)
def test_fptoui_scalar_f32_to_u32(a, name):
    run_single_test_scalar(
        elementwise_fptoui_f32_to_u32,
        a,
        name,
        jnp.uint32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/FPToUI/FPToUI.py::test_fptoui_scalar_f32_to_u32