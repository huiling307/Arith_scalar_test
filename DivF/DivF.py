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
    "arith_scalar_test/DivF/divf_scalar_results.txt"
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

    ref = np.asarray(ref).item()
    out = np.asarray(out).item()

    # ---------------- WRITE TO FILE ----------------
    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=float(a),
        b=float(b),
        cpu_val=ref,
        tpu_val=out,
    )

    # ---------------- semantic check ----------------
    if np.isnan(ref):
        assert np.isnan(out), (
        f"[{dtype}] DivF NaN mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

    elif np.isinf(ref):
    # Inf: value and sign must match
        assert np.isinf(out) and math.copysign(1.0, out) == math.copysign(1.0, ref), (
        f"[{dtype}] DivF Inf mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

    elif ref == 0.0:
    # handle +0.0 / -0.0 sign explicitly
        assert out == 0.0 and math.copysign(1.0, out) == math.copysign(1.0, ref), (
        f"[{dtype}] DivF zero-sign mismatch in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )

    else:
    # finite, non-zero: allow approximation
        assert np.isclose(out, ref, rtol=1e-4, atol=0.0), (
        f"[{dtype}] DivF mismatch (approx) in case {name}\n"
        f"CPU={ref}, TPU={out}"
    )


# ======================================================
# Kernel
# ======================================================

@jax.jit
def elementwise_divf_f32(a, b):
    return a / b


# ======================================================
# Edge case generator (float32)
# ======================================================

def f32(x):
    return jnp.float32(x)


def make_divf_f32_edge_cases():
    return [
        # ---------------- basic ----------------
        (f32(6.0),  f32(2.0),  "six_div_two"),
        (f32(1.0),  f32(2.0),  "one_div_two"),

        # ---------------- zero ----------------
        (f32(0.0),  f32(1.0),   "zero_div_one"),
        (f32(0.0),  f32(-1.0),  "zero_div_minus_one"),

        # ---------------- division by zero ----------------
        (f32(1.0),   f32(0.0),  "one_div_zero"),
        (f32(-1.0),  f32(0.0),  "minus_one_div_zero"),

        # ---------------- infinities ----------------
        (f32(1.0),    f32(np.inf),   "one_div_inf"),
        (f32(-1.0),   f32(np.inf),   "minus_one_div_inf"),
        (f32(np.inf), f32(1.0),      "inf_div_one"),
        (f32(-np.inf), f32(1.0),     "minus_inf_div_one"),

        # ---------------- NaNs ----------------
        (f32(np.nan), f32(1.0),       "nan_div_one"),
        (f32(1.0),    f32(np.nan),    "one_div_nan"),
        (f32(np.nan), f32(np.nan),    "nan_div_nan"),

        # ---------------- signed zero ----------------
        (f32(1.0),   f32(-0.0), "one_div_minus_zero"),
        (f32(-1.0),  f32(-0.0), "minus_one_div_minus_zero"),
    ]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, b, name",
    make_divf_f32_edge_cases(),
)
def test_divf_scalar_f32(a, b, name):
    run_single_test_scalar(
        elementwise_divf_f32,
        a,
        b,
        name,
        jnp.float32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/DivF/DivF.py::test_divf_scalar_f32