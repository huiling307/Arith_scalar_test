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
    "arith_scalar_test/ExtF/extf_f16_to_f32_results.txt"
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
    if np.isnan(ref) and np.isnan(out):
        return  # both NaN, OK
    assert ref == out, (
        f"[{dtype}] ExtF f16->f32 mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

# ======================================================
# Kernel: f16 -> f32
# ======================================================

@jax.jit
def extf_f16_to_f32(a: jnp.float16) -> jnp.float32:
    return a.astype(jnp.float32)

# ======================================================
# Edge case generator
# ======================================================

def make_extf_f16_edge_cases():
    f16 = lambda x: jnp.float16(x)
    return [
        (f16(0.0),   "zero"),
        (f16(-0.0),  "minus_zero"),
        (f16(1.0),   "one"),
        (f16(-1.0),  "minus_one"),
        (f16(0.5),   "fraction"),
        (f16(np.inf),   "pos_inf"),
        (f16(-np.inf),  "neg_inf"),
        (f16(np.nan),   "nan"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, name",
    make_extf_f16_edge_cases()
)
def test_extf_f16_to_f32_scalar(a, name):
    run_single_test_scalar(
        extf_f16_to_f32,
        a,
        name,
        jnp.float32
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/ExtF/ExtF.py::test_extf_f16_to_f32_scalar