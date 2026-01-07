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
    "arith_scalar_test/NegF/negf_scalar_results.txt"
)


def _write_result_to_file(dtype, name, a, cpu, tpu):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"dtype : {dtype}\n"
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
def negf(x):
    return jnp.negative(x)

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

    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=float(a),
        cpu=ref,
        tpu=out,
    )

    if np.isnan(ref):
        assert np.isnan(out), (
            f"[{dtype}] negf NaN mismatch in case {name}"
        )
    else:
        assert ref == out, (
            f"[{dtype}] negf mismatch in case {name}\n"
            f"CPU={ref}, TPU={out}"
        )

# ======================================================
# Test cases
# ======================================================

def f32(x):
    return jnp.float32(x)

def make_negf_f32_cases():
    return [
        (f32(0.0), "pos_zero"),
        (f32(-0.0), "neg_zero"),
        (f32(1.0), "one"),
        (f32(-1.0), "minus_one"),
        (f32(3.5), "pos_float"),
        (f32(-3.5), "neg_float"),
        (f32(np.inf), "pos_inf"),
        (f32(-np.inf), "neg_inf"),
        (f32(np.nan), "nan"),
    ]

# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, name",
    make_negf_f32_cases(),
)
def test_negf_scalar_f32(a, name):
    run_single_test_scalar(
        negf,
        a,
        name,
        dtype=jnp.float32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/NegF/NegF.py::test_negf_scalar_f32