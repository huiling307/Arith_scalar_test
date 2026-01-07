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
    "arith_scalar_test/UIToFP/uitofp_u32_f32_scalar_results.txt"
)


def _write_result_to_file(dtype_in, dtype_out, name, a, cpu, tpu):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"from  : {dtype_in}\n"
            f"to    : {dtype_out}\n"
            f"case  : {name}\n"
            f"input : a={a}\n"
            f"CPU   : {cpu}\n"
            f"TPU   : {tpu}\n"
            f"{'-'*60}\n"
        )

# ======================================================
# Kernel
# ======================================================

@jax.jit
def uitofp_u32_to_f32(a):
    return a.astype(jnp.float32)

# ======================================================
# Utils
# ======================================================

def _to_cpu(x):
    return jax.device_put(x, jax.devices("cpu")[0])


def run_single_test_scalar(jit_func, a, name, dtype_in, dtype_out):
    # ---------------- CPU reference ----------------
    with jax.default_device(jax.devices("cpu")[0]):
        ref = jit_func(a)

    # ---------------- TPU / DLC ----------------
    dlc_dev = jax.devices("iree_dlc")[0]
    a_dlc = jax.device_put(a, dlc_dev)
    out = jit_func(a_dlc)
    out = _to_cpu(out)

    ref_val = float(np.asarray(ref).item())
    out_val = float(np.asarray(out).item())

    _write_result_to_file(
        dtype_in=dtype_in,
        dtype_out=dtype_out,
        name=name,
        a=int(a),
        cpu=ref_val,
        tpu=out_val,
    )

    assert ref_val == out_val, (
        f"[{dtype_in} -> {dtype_out}] uitofp mismatch in case {name}\n"
        f"CPU={ref_val}, TPU={out_val}"
    )

# ======================================================
# Test cases
# ======================================================

def u32(x):
    return jnp.uint32(x)


def make_uitofp_u32_f32_cases():
    info = np.iinfo(np.uint32)
    return [
        # trivial
        (u32(0), "zero"),
        (u32(1), "one"),

        # small integers (exact)
        (u32(2), "two"),
        (u32(15), "fifteen"),
        (u32(255), "byte_max"),

        # powers of two (exact in f32)
        (u32(2**8), "pow2_8"),
        (u32(2**16), "pow2_16"),
        (u32(2**24), "pow2_24_exact"),

        # rounding boundary (f32 mantissa = 24 bits)
        (u32(2**24 + 1), "pow2_24_plus_one"),
        (u32(2**25 - 1), "pow2_25_minus_one"),

        # large values
        (u32(2**31), "high_bit_set"),
        (u32(info.max), "uint32_max"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, name",
    make_uitofp_u32_f32_cases(),
)
def test_uitofp_scalar_u32_to_f32(a, name):
    run_single_test_scalar(
        uitofp_u32_to_f32,
        a,
        name,
        dtype_in=jnp.uint32,
        dtype_out=jnp.float32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/UIToFP/UIToFP.py::test_uitofp_scalar_u32_to_f32