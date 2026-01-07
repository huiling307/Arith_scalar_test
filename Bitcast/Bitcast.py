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
    "arith_scalar_test/Bitcast/bitcast_scalar_results.txt"
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

    # ---------------- WRITE TO FILE ----------------
    _write_result_to_file(
        dtype=dtype,
        name=name,
        a=a,
        cpu_val=ref,
        tpu_val=out,
    )

    # ---------------- semantic check ----------------
    # 对浮点值特殊处理 NaN
    if np.issubdtype(dtype, np.floating):
        if np.isnan(ref) and np.isnan(out):
            return  # 都是 NaN，认为匹配
        assert ref == out, (
            f"[{dtype}] Bitcast mismatch in case {name}\n"
            f"CPU={ref}, TPU={out}"
        )
    else:
        assert ref == out, (
            f"[{dtype}] Bitcast mismatch in case {name}\n"
            f"CPU={ref}, TPU={out}"
        )



# ======================================================
# Kernel
# ======================================================

@jax.jit
def bitcast_u32_to_f32(a):
    return jax.lax.bitcast_convert_type(a, jnp.float32)


# ======================================================
# Edge case generator
# ======================================================

def make_bitcast_edge_cases():
    return [
        (0x00000000, "positive_zero"),
        (0x80000000, "negative_zero"),
        (0x3F800000, "float_1"),
        (0xBF800000, "float_minus_1"),
        (0x7F800000, "pos_inf"),
        (0xFF800000, "neg_inf"),
        (0x7FC00000, "quiet_nan"),
        (0x7FA00000, "nan_variant"),
        (0xFFFFFFFF, "all_ones"),
        (0x00FFFFFF, "max_exact_float32"),
    ]


# ======================================================
# Tests
# ======================================================

@pytest.mark.parametrize(
    "a, name",
    [(jnp.uint32(a), name) for a, name in make_bitcast_edge_cases()],
)
def test_bitcast_scalar_u32_to_f32(a, name):
    run_single_test_scalar(
        bitcast_u32_to_f32,
        a,
        name,
        jnp.float32,
    )


#rm -f sim* && source set-env && cmake --build ../iree-build/  && python -m pytest -vs /root/iree/tests/e2e/dlc_specific/test_set/arith_scalar_test/Bitcast/Bitcast.py::test_bitcast_scalar_u32_to_f32
