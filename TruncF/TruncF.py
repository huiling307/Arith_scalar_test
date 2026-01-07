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
    "arith_scalar_test/TruncF/truncf_scalar_results.txt"
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
        f"[{dtype}] TruncF mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

# ======================================================
# Kernel
# ======================================================

@jax.jit
def truncf(x: jnp.float32) -> jnp.float16:
    return x.astype(jnp.float16)

# ======================================================
# Edge case generator
# ======================================================

def make_truncf_edge_cases():
    f32 = lambda x: np.float32(x)
    f16_info = np.finfo(np.float16)

    return [
        # trivial
        (f32(0.0), "zero"),
        (f32(1.0), "one"),
        (f32(-1.0), "minus_one"),

        # exactly representable
        (f32(0.5), "half"),
        (f32(2.0), "two"),
        (f32(64.0), "power_of_two"),

        # rounding required
        (f32(1.1), "rounding_1_1"),
        (f32(1.00097656), "rounding_boundary"),  # ~1 + 2^-10

        # subnormal / underflow
        (f32(f16_info.tiny / 2), "subnormal_half"),
        (f32(f16_info.tiny), "smallest_normal"),

        # overflow to inf
        (f32(f16_info.max * 2), "overflow_to_inf"),

        # special values
        (f32(np.inf), "positive_inf"),
        (f32(-np.inf), "negative_inf"),
        (f32(np.nan), "nan"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, name",
    make_truncf_edge_cases()
)
def test_truncf_scalar(a, name):
    run_single_test_scalar(
        truncf,
        a,
        name,
        jnp.float16
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/TruncF/TruncF.py::test_truncf_scalar