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
    "arith_scalar_test/CmpF/cmpf_scalar_results.txt"
)


def _write_result_to_file(dtype, pred, name, a, b, cpu_val, tpu_val):
    os.makedirs(os.path.dirname(RESULT_DUMP_PATH), exist_ok=True)
    with open(RESULT_DUMP_PATH, "a") as f:
        f.write(
            f"[{datetime.now()}]\n"
            f"dtype     : {dtype}\n"
            f"predicate : {pred}\n"
            f"case      : {name}\n"
            f"input     : a={a}, b={b}\n"
            f"CPU       : {cpu_val}\n"
            f"TPU       : {tpu_val}\n"
            f"{'-'*60}\n"
        )


# ======================================================
# Utils
# ======================================================

def _bool_to_i32(x):
    # 显式转换，避免 i1 走到 IREE
    return jnp.where(x, jnp.int32(1), jnp.int32(0))


def _to_cpu(x):
    return jax.device_put(x, jax.devices("cpu")[0])


def run_single_test_scalar(jit_func, a, b, pred, name, dtype):
    # ---------------- CPU reference ----------------
    with jax.default_device(jax.devices("cpu")[0]):
        ref = jit_func(a, b)

    # ---------------- TPU / DLC ----------------
    dlc_dev = jax.devices("iree_dlc")[0]
    out = jit_func(
        jax.device_put(a, dlc_dev),
        jax.device_put(b, dlc_dev),
    )
    out = _to_cpu(out)

    ref = bool(np.asarray(ref))
    out = bool(np.asarray(out))

    _write_result_to_file(
        dtype=dtype,
        pred=pred,
        name=name,
        a=float(a),
        b=float(b),
        cpu_val=ref,
        tpu_val=out,
    )

    assert ref == out, (
        f"[{dtype}] cmpf({pred}) mismatch in case {name}\n"
        f"a={a}, b={b}\n"
        f"CPU={ref}, TPU={out}"
    )


# ======================================================
# Kernel generators (cmpf predicates)
# ======================================================

def make_cmpf_kernel(pred):
    if pred == "oeq":
        return jax.jit(lambda a, b: _bool_to_i32(a == b))

    if pred == "one":
        return jax.jit(lambda a, b: _bool_to_i32(a != b))

    if pred == "olt":
        return jax.jit(lambda a, b: _bool_to_i32(a < b))

    if pred == "ole":
        return jax.jit(lambda a, b: _bool_to_i32(a <= b))

    if pred == "ogt":
        return jax.jit(lambda a, b: _bool_to_i32(a > b))

    if pred == "oge":
        return jax.jit(lambda a, b: _bool_to_i32(a >= b))

    # unordered: NaN -> true
    if pred == "ueq":
        return jax.jit(
            lambda a, b: _bool_to_i32(
                jnp.isnan(a) | jnp.isnan(b) | (a == b)
            )
        )

    if pred == "une":
        return jax.jit(
            lambda a, b: _bool_to_i32(
                jnp.isnan(a) | jnp.isnan(b) | (a != b)
            )
        )

    if pred == "ult":
        return jax.jit(
            lambda a, b: _bool_to_i32(
                jnp.isnan(a) | jnp.isnan(b) | (a < b)
            )
        )

    if pred == "ule":
        return jax.jit(
            lambda a, b: _bool_to_i32(
                jnp.isnan(a) | jnp.isnan(b) | (a <= b)
            )
        )

    if pred == "ugt":
        return jax.jit(
            lambda a, b: _bool_to_i32(
                jnp.isnan(a) | jnp.isnan(b) | (a > b)
            )
        )

    if pred == "uge":
        return jax.jit(
            lambda a, b: _bool_to_i32(
                jnp.isnan(a) | jnp.isnan(b) | (a >= b)
            )
        )

    raise ValueError(pred)



# ======================================================
# Edge cases (float32)
# ======================================================

def make_cmpf_f32_cases():
    nan = np.float32(np.nan)
    inf = np.float32(np.inf)
    ninf = np.float32(-np.inf)

    return [
        (jnp.float32(1.0), jnp.float32(1.0), "equal"),
        (jnp.float32(1.0), jnp.float32(2.0), "less"),
        (jnp.float32(-0.0), jnp.float32(0.0), "signed_zero"),
        (jnp.float32(1.0), inf, "finite_vs_inf"),
        (ninf, jnp.float32(1.0), "ninf_vs_finite"),
        (nan, jnp.float32(1.0), "nan_lhs"),
        (jnp.float32(1.0), nan, "nan_rhs"),
        (nan, nan, "nan_nan"),
    ]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "pred",
    [
        "oeq", "one", "olt", "ole", "ogt", "oge",
        "ueq", "une", "ult", "ule", "ugt", "uge",
    ],
)
@pytest.mark.parametrize(
    "a, b, name",
    make_cmpf_f32_cases(),
)
def test_cmpf_scalar_f32(pred, a, b, name):
    kernel = make_cmpf_kernel(pred)
    run_single_test_scalar(
        kernel,
        a,
        b,
        pred,
        name,
        jnp.float32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/CmpF/CmpF.py::test_cmpf_scalar_f32