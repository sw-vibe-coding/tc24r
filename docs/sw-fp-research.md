# Software IEEE Floating Point: Research & Feasibility

## Summary

Software IEEE 754 floating point is **feasible** on COR24 with 3 GPRs.
It would be slow and code-heavy, but functionally correct. The existing
`divmod` runtime pattern provides a direct template for implementation.

---

## The Core Challenge

### Data width mismatch

IEEE 754 single-precision requires 32 bits:

```
[1 sign][8 exponent][23 mantissa]  = 32 bits
```

COR24 words are 24 bits. A float must be stored as **two words** (48 bits
total, 16 bits unused) or in a packed layout.

### Storage options

| Layout | Pros | Cons |
|--------|------|------|
| **2-word (hi:lo)** | Simple extraction, aligned | Wastes 16 bits per float |
| **Packed 24+8** | No wasted bits | Splitting across words is complex |
| **24-bit mini-float** | Fits in 1 register | Not IEEE compliant, reduced range/precision |

**Recommended: 2-word layout.** Simplicity outweighs the space cost. Store
the upper 24 bits in one word and the lower 8 bits in another (zero-padded).

```
Word 0 (hi): [sign][exp7..exp0][mant22..mant8]   ; bits 31..8
Word 1 (lo): [mant7..mant0][0000_0000_0000_0000]  ; bits 7..0, padded
```

---

## Register Pressure Analysis

COR24 has 3 GPRs: r0, r1, r2.

### Inside a float add routine

A simplified IEEE float addition needs to:

1. Extract sign, exponent, mantissa from both operands (6 fields)
2. Align mantissas (shift by exponent difference)
3. Add/subtract mantissas
4. Normalize result
5. Round
6. Repack sign + exponent + mantissa

With 3 registers, intermediate values must spill to the stack constantly.
A rough count of the scratch space needed:

| Value | Where stored |
|-------|-------------|
| sign_a, sign_b | Stack |
| exp_a, exp_b | Stack (one in r2 during comparison) |
| mant_a | Stack or r0 |
| mant_b | Stack or r1 |
| exp_diff | r0 (temporary) |
| result mantissa | r0 |
| result exponent | Stack → r1 for repacking |
| result sign | Stack |

**This is workable.** 8-bit microcontrollers (AVR with 32 registers, PIC with
1 working register) handle 32-bit IEEE floats in software with similar or
worse constraints. COR24's 24-bit multiply instruction (albeit 24 cycles)
helps with mantissa multiplication.

---

## Implementation Approach

### Follow the divmod pattern

The compiler already has a runtime-helper pattern in
`codegen-ops/crates/tc24r-ops-divmod/src/divmod.rs`:

1. Codegen emits a call to `__tc24r_div` / `__tc24r_mod`
2. A flag (`state.needs_div`) tracks whether the runtime is needed
3. At end of compilation, the runtime routine is emitted into the assembly

Float operations would follow the same pattern:

```rust
// In codegen, when encountering float addition:
state.needs_fadd = true;
emit!(state, "        push    r0");       // push float_a lo word
emit!(state, "        push    r0");       // push float_a hi word
// ... (push operands onto stack)
emit!(state, "        jal     __soft_fadd");
emit!(state, "        add     sp,12");    // caller cleanup (4 words)
```

### Required runtime routines

| Routine | Description | Approx. instructions |
|---------|-------------|---------------------|
| `__soft_fadd` | Float addition/subtraction | 150-250 |
| `__soft_fmul` | Float multiplication | 100-150 |
| `__soft_fdiv` | Float division | 150-200 |
| `__soft_fcmp` | Float comparison (sets C flag) | 50-80 |
| `__soft_itof` | Int-to-float conversion | 40-60 |
| `__soft_ftoi` | Float-to-int conversion | 30-50 |
| `__soft_fneg` | Float negation (flip sign bit) | 10-15 |

**Total runtime size: ~500-800 instructions**, emitted only when needed.

### Calling convention for float routines

Since floats are 2 words, arguments go on the stack:

```
; __soft_fadd(a_hi, a_lo, b_hi, b_lo) → result in r0:r1
;
; Stack on entry:
;   sp+12: a_hi
;   sp+9:  a_lo
;   sp+6:  b_hi
;   sp+3:  b_lo
;   sp+0:  return address (pushed by jal → saved r1)
;
; Returns:
;   r0 = result hi word
;   r1 = result lo word
```

The caller would then store both words to the destination (local variable
or push for further computation).

---

## Mantissa Multiplication Detail

IEEE float multiply requires multiplying two 24-bit mantissas (including
implicit leading 1) to produce a 48-bit product.

COR24 has `mul r0, r1` (24-bit × 24-bit, 24 cycles), but it likely produces
only the lower 24 bits of the result. A full 48-bit product requires
multi-word multiplication:

```
; Multiply A (24-bit) × B (24-bit) → 48-bit result
; Split each into 12-bit halves:
;   A = A_hi * 2^12 + A_lo
;   B = B_hi * 2^12 + B_lo
;
; A × B = A_hi*B_hi*2^24 + (A_hi*B_lo + A_lo*B_hi)*2^12 + A_lo*B_lo
;
; 4 multiplications of 12-bit values (each fits in 24 bits)
; Plus shifts and additions to combine partial products
```

This is the most complex part of the float runtime but well-understood
(it's the same approach used in every software float library).

---

## Performance Estimates

| Operation | Estimated cycles | Notes |
|-----------|-----------------|-------|
| Float add | 200-400 | Alignment shift + add + normalize |
| Float mul | 300-500 | 4 partial muls (24 cyc each) + combine |
| Float div | 400-800 | Iterative (Newton-Raphson or long division) |
| Float cmp | 50-100 | Compare exponents, then mantissas |
| Int→float | 60-100 | Count leading zeros + shift |
| Float→int | 40-80 | Shift mantissa by exponent |

For comparison, a COR24 integer `mul` takes 24 cycles, and software
`__tc24r_div` likely takes 100-200 cycles.

---

## Compiler Changes Required

### New AST / type support

The parser and type system would need `float` as a type:

- `Type::Float` variant in `tc24r-ast`
- Parser recognizes `float` keyword
- Type inference handles float promotion (int + float → float)
- Float literals parsed (e.g., `3.14` → hi/lo word pair)

### New codegen crate

A new `tc24r-ops-float` crate (parallel to `tc24r-ops-divmod`):

```
codegen-ops/crates/tc24r-ops-float/
  src/
    lib.rs           - pub use
    float_arith.rs   - gen_float_add(), gen_float_mul(), etc.
    float_conv.rs    - gen_int_to_float(), gen_float_to_int()
    float_runtime.rs - emit_float_runtime() (the actual asm routines)
```

### CodegenState additions

```rust
pub needs_fadd: bool,
pub needs_fmul: bool,
pub needs_fdiv: bool,
pub needs_fcmp: bool,
pub needs_itof: bool,
pub needs_ftoi: bool,
```

### Local variable allocation

Floats need 2 words (6 bytes) instead of the usual 1 word (3 bytes).
The locals collector (`tc24r-struct-locals/src/collect.rs`) already handles
variable-size allocation via `ty.size().max(3)` — it just needs
`Type::Float` to report `size() = 6`.

---

## Alternative: 24-bit Mini-Float

If IEEE compliance is not required, a 24-bit float fits in one register:

```
[1 sign][7 exponent][16 mantissa]  = 24 bits
```

| Property | IEEE 754 single | 24-bit mini-float |
|----------|----------------|-------------------|
| Total bits | 32 | 24 |
| Exponent | 8 bits (bias 127) | 7 bits (bias 63) |
| Mantissa | 23 bits | 16 bits |
| Range | ~1.2e-38 to 3.4e+38 | ~1.2e-19 to 8.5e+18 |
| Precision | ~7 decimal digits | ~5 decimal digits |
| Storage | 2 words | 1 word |
| Register pressure | High | Same as int |

**Advantage:** Fits in a single register, no 2-word pairs, much simpler
codegen. Arithmetic routines are shorter since everything stays 24-bit.

**Disadvantage:** Not IEEE compliant, reduced range and precision, no
ecosystem compatibility.

---

## Recommendation

1. **Start with the 2-word IEEE 754 approach** — it follows the existing
   divmod runtime pattern directly and produces standards-compliant results.

2. **Implement `fadd` and `fmul` first** — these are the most commonly
   needed and exercise the full extraction/normalize/repack pipeline.

3. **The 3-GPR constraint is not a blocker.** It makes the runtime routines
   stack-heavy and slow, but not incorrect. Every 8-bit micro handles this.

4. **Consider the mini-float as a separate option** if performance matters
   more than IEEE compliance for a particular use case.
