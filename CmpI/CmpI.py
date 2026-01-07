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
    "arith_scalar_test/CmpI/cmpi_scalar_results.txt"
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
    # 显式转换，避免 i1 直接走 IREE
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
        a=int(a),
        b=int(b),
        cpu_val=ref,
        tpu_val=out,
    )

    assert ref == out, (
        f"[{dtype}] cmpi({pred}) mismatch in case {name}\n"
        f"a={a}, b={b}\n"
        f"CPU={ref}, TPU={out}"
    )


# ======================================================
# Kernel generators (cmpi predicates, signed)
# ======================================================

def make_cmpi_kernel(pred):
    # equality (signless)
    if pred == "eq":
        return jax.jit(lambda a, b: _bool_to_i32(a == b))

    if pred == "ne":
        return jax.jit(lambda a, b: _bool_to_i32(a != b))

    # ---------- signed ----------
    if pred == "slt":
        return jax.jit(lambda a, b: _bool_to_i32(a < b))

    if pred == "sle":
        return jax.jit(lambda a, b: _bool_to_i32(a <= b))

    if pred == "sgt":
        return jax.jit(lambda a, b: _bool_to_i32(a > b))

    if pred == "sge":
        return jax.jit(lambda a, b: _bool_to_i32(a >= b))

    # ---------- unsigned ----------
    if pred == "ult":
        return jax.jit(
            lambda a, b: _bool_to_i32(
                jnp.uint32(a) < jnp.uint32(b)
            )
        )

    if pred == "ule":
        return jax.jit(
            lambda a, b: _bool_to_i32(
                jnp.uint32(a) <= jnp.uint32(b)
            )
        )

    if pred == "ugt":
        return jax.jit(
            lambda a, b: _bool_to_i32(
                jnp.uint32(a) > jnp.uint32(b)
            )
        )

    if pred == "uge":
        return jax.jit(
            lambda a, b: _bool_to_i32(
                jnp.uint32(a) >= jnp.uint32(b)
            )
        )

    raise ValueError(pred)



# ======================================================
# Edge cases (int32)
# ======================================================

def make_cmpi_i32_cases():
    return [
        (jnp.int32(0),  jnp.int32(0),  "zero_eq"),
        (jnp.int32(1),  jnp.int32(2),  "one_vs_two"),
        (jnp.int32(-1), jnp.int32(1),  "neg_vs_pos"),
        (jnp.int32(-1), jnp.int32(0),  "minus_one_vs_zero"),
        (jnp.int32(-1), jnp.int32(-2), "neg_vs_neg"),
        (jnp.int32(-2147483648), jnp.int32(0), "sign_bit_vs_zero"),
        (jnp.int32(-1), jnp.int32(1), "all_ones_vs_one"),
    ]



# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "pred",
    [
        # equality
        "eq", "ne",
        # signed
        "slt", "sle", "sgt", "sge",
        # unsigned
        "ult", "ule", "ugt", "uge",
    ],
)
@pytest.mark.parametrize(
    "a, b, name",
    make_cmpi_i32_cases(),
)
def test_cmpi_scalar_i32_signless(pred, a, b, name):
    kernel = make_cmpi_kernel(pred)
    run_single_test_scalar(
        kernel,
        a,
        b,
        pred,
        name,
        jnp.int32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/CmpI/CmpI.py::test_cmpi_scalar_i32_signless

