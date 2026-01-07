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
    "arith_scalar_test/AddF/addf_scalar_results.txt"
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
    # NaN
    if np.isnan(ref):
        assert np.isnan(out), f"[{name}] NaN mismatch: ref={ref}, out={out}"
        return

    # +Inf / -Inf
    if np.isinf(ref):
        assert ref == out, f"[{name}] Inf mismatch: ref={ref}, out={out}"
        return

    # Finite
    assert np.allclose(
        out, ref, rtol=0, atol=0
    ), f"[{dtype}] AddF mismatch in case {name}\nCPU={ref}, TPU={out}"


# ======================================================
# Kernel
# ======================================================

@jax.jit
def elementwise_add_f32(a, b):
    return a + b


# ======================================================
# Edge case generator (float32)
# ======================================================

def make_addf_f32_edge_cases():
    finfo = np.finfo(np.float32)
    tiny = np.nextafter(np.float32(0.0), np.float32(1.0))

    cases = [
        (1.0, 2.0, "normal_add"),
        (-1.5, 3.25, "mixed_sign"),

        (0.0, 0.0, "zero_plus_zero"),
        (-0.0, 0.0, "negzero_plus_zero"),
        (-0.0, -0.0, "negzero_plus_negzero"),

        (np.inf, 1.0, "inf_plus_finite"),
        (-np.inf, -1.0, "neg_inf_plus_finite"),
        (np.inf, -np.inf, "inf_plus_neg_inf"),

        (np.nan, 1.0, "nan_plus_finite"),
        (1.0, np.nan, "finite_plus_nan"),
        (np.nan, np.nan, "nan_plus_nan"),

        (finfo.max, finfo.max, "overflow_to_inf"),
        (tiny, tiny, "subnormal_add"),
    ]

    return [
        (jnp.float32(a), jnp.float32(b), name)
        for a, b, name in cases
    ]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_addf_f32_edge_cases(),
)
def test_addf_scalar_f32(a, b, name):
    run_single_test_scalar(
        elementwise_add_f32,
        a,
        b,
        name,
        jnp.float32,
    )




#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/AddF/AddF.py::test_addf_scalar_f32
