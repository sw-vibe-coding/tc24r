# Codegen Improvement Plan: Register Allocation & Instruction Reduction

## Problem Description

The tc24r compiler produces correct but inefficient assembly compared to the
reference cc24 compiler. Using `docs/demo2.c` as a benchmark, tc24r emits
**184 instructions** vs cc24's **114 instructions** — a **61% overhead**.

The root cause is tc24r's fully stack-based codegen strategy: every binary
operation pushes LHS to the stack, evaluates RHS, then pops — even when both
operands are trivially available in registers. The reference compiler avoids
this by loading simple operands directly into r0/r1.

A secondary issue is that `!=` comparisons materialize a boolean value and
test it, instead of directly flipping the branch sense.

## Benchmark: demo2.c

### Instruction Counts

| Function     | cc24 (ref) | tc24r | Overhead |
|--------------|-----------|-------|----------|
| `led_on`     | 9         | 13    | +44%     |
| `led_off`    | 9         | 13    | +44%     |
| `uart_putc`  | 14        | 19    | +36%     |
| `main`       | 82        | 139   | +70%     |
| **Total**    | **114**   | **184** | **+61%** |

### Comparison 1: Unnecessary push/pop for simple operands

The most impactful inefficiency. When both sides of a binary operation are
"simple" (a literal, a variable load, or an address), tc24r still does a
push/pop round-trip through the stack.

```asm
; tc24r: *(char *)0xFF0000 = 0     (6 instructions)
        lc      r0,0
        push    r0              ; unnecessary — value is a constant
        la      r0,16711680
        mov     r1,r0           ; unnecessary shuffle
        pop     r0              ; unnecessary restore
        sb      r0,0(r1)

; cc24 reference: same expression  (3 instructions)
        la      r0,-65536
        lc      r1,0
        sb      r1,(r0)
```

This pattern repeats for every comparison, assignment through pointer,
and binary operation in the program.

### Comparison 2: != generates 4 extra instructions instead of flipping branch

tc24r synthesizes `!=` as `!(==)` with a double-negate sequence:

```asm
; tc24r: if (a != 65) { ok = 0; }   (7 instructions for the condition)
        lw      r0,-6(fp)       ; load a
        push    r0
        lc      r0,65
        mov     r1,r0
        pop     r0
        ceq     r0,r1           ; compare equal
        mov     r0,c            ; materialize result
        ceq     r0,z            ; negate (== 0?)
        mov     r0,c            ; materialize negation
        ceq     r0,z            ; test for branch
        brt     L7              ; skip body if true (i.e., a == 65)

; cc24 reference: same              (4 instructions for the condition)
        lb      r0,-14(fp)      ; load a
        lc      r1,65
        ceq     r0,r1           ; compare equal
        brt     L21             ; skip body if equal (branch sense flipped)
```

The reference compiler realizes that `if (a != 65) { body }` is the same as
"skip body when a == 65" — so it emits `ceq; brt skip` directly, avoiding
the boolean materialization entirely.

### Comparison 3: Char locals waste stack space

tc24r allocates 3 bytes (word-sized) for every `char` variable and uses
`sw`/`lw` to access them:

```asm
; tc24r: char a = 65     (3 bytes allocated)
        lc      r0,65
        sw      r0,-6(fp)

; cc24: char a = 65      (1 byte allocated)
        lc      r0,65
        sb      r0,-14(fp)
```

main's locals: tc24r uses 21 bytes, cc24 uses 15 bytes.

### Comparison 4: Address literal encoding

```asm
; tc24r:  la r0,16711680    ; 0xFF0000 as positive decimal
; cc24:   la r0,-65536      ; same address, shorter signed representation
```

### Comparison 5: Unsigned byte load for signed char

```asm
; tc24r: lbu r0,0(r0)   ; unsigned load for char pointer dereference
; cc24:  lb  r0,(r0)    ; signed load (matches C char semantics)
```

## Recommendations (ranked by impact)

### R1. Peephole: Skip push/pop for simple operands (HIGH)

**Estimated savings:** ~30 instructions in demo2 main, ~50 overall

When both operands of a binary expression are "simple" — meaning they can be
loaded into a register with 1-2 instructions and no side effects — skip the
push/pop sequence entirely. Load LHS into r0, load RHS into r1 directly.

**Definition of "simple" expression:**
- Integer literal (`lc` or `la`)
- Local variable load (`lw`/`lb` from fp offset)
- Global variable load (`la` + `lw`/`lb`)
- Address-of local (`lc offset; add r0,fp`)
- Parameter load (`lw` from fp+offset)

**Not simple (requires push/pop):**
- Function calls (clobber registers)
- Nested binary operations
- Pointer dereferences through computed addresses
- Expressions with side effects (++/--)

### R2. Conditional branch fusion (HIGH)

**Estimated savings:** ~20 instructions in demo2 main

For `if (a != b) { body }`, instead of:
1. Evaluate `a != b` → boolean in r0
2. Test r0, branch

Emit directly:
1. Load a → r0, load b → r1
2. `ceq r0,r1; brt skip_label` (skip body when equal)

Similarly for all comparison operators used in if/while conditions:

| C operator | Fused branch (skip body) | Instructions saved |
|------------|--------------------------|-------------------|
| `!=`       | `ceq r0,r1; brt skip`   | 3 per use |
| `==`       | `ceq r0,r1; brf skip`   | 1 per use |
| `<`        | `cls r0,r1; brf skip`   | 1 per use |
| `>=`       | `cls r0,r1; brt skip`   | 1 per use |
| `>`        | `cls r1,r0; brf skip`   | 1 per use |
| `<=`       | `cls r1,r0; brt skip`   | 1 per use |

### R3. Char-sized local allocation (MEDIUM)

**Estimated savings:** 6 bytes stack, minor instruction changes

Allocate 1 byte for `char` locals instead of 3. Use `sb`/`lb` for char
local access. Requires changes to local collection and load/store emission.

### R4. Negative address encoding (LOW)

For addresses >= 0x800000 (the MMIO range), emit as negative signed values.
`la r0,-65536` instead of `la r0,16711680`. The assembler may encode these
more compactly.

### R5. Use `lb` for signed char reads (LOW)

Replace `lbu` with `lb` for `char *` dereferences. `lbu` (unsigned byte
load) should only be used for `unsigned char`. This is a correctness fix
for sign-extension behavior, though it doesn't affect the demo since all
char values used are positive.

### R6. Omit zero offset in memory operands (LOW)

Emit `sb r0,(r1)` instead of `sb r0,0(r1)`. Cosmetic but matches cc24
output style and the assembler may prefer it.

## Implementation Plan (TDD)

Each recommendation is implemented as an independent phase. Phases are
ordered by dependency (R1 before R2, since R2 builds on R1's simple-operand
detection). Each phase follows this cycle:

1. Write a focused golden-file test capturing current (inefficient) output
2. Implement the optimization
3. Update the golden file to match the improved output
4. Verify all reg-rs tests still pass (no regressions)

### Phase 1: Simple operand detection (foundation for R1 + R2)

**Goal:** Add an `is_simple_expr()` predicate to classify expressions that
can be loaded into a register without push/pop.

**Files to modify:**
- `components/codegen-expr/crates/tc24r-expr-ops/src/binop.rs` — add predicate
- OR: new shared utility in `components/codegen-state/` if needed elsewhere

**Tests:**
1. Unit test `is_simple_expr()` against AST nodes:
   - `42` → true (literal)
   - `x` (local var) → true
   - `&x` (address-of local) → true
   - `f()` → false (call)
   - `a + b` → false (nested binop)
   - `*p` → false (dereference)
   - `x++` → false (side effect)

**Deliverable:** Predicate only, no codegen changes yet. All existing tests
must still pass unchanged.

### Phase 2: Implement R1 — skip push/pop for simple operands

**Goal:** When `is_simple_expr(lhs)` and `is_simple_expr(rhs)`, generate
direct register loads instead of push/pop.

**Files to modify:**
- `components/codegen-expr/crates/tc24r-expr-ops/src/binop.rs` — modify
  `eval_lhs_rhs()` to check simplicity and use direct path
- May need a `gen_expr_into_r1()` helper (load result into r1 instead of r0)

**New codegen pattern (simple path):**
```asm
; gen_expr(lhs) → r0     (e.g., lw r0,-6(fp))
; gen_expr_r1(rhs) → r1  (e.g., lc r1,65)
; [operation]             (e.g., ceq r0,r1)
```

**Tests:**
1. Golden-file test: compile a minimal C file with simple binary ops
   ```c
   int main() { int x = 10; if (x != 10) { return 1; } return 0; }
   ```
   Verify output contains NO push/pop between operand loads.

2. Golden-file test: compile a file where push/pop IS needed
   ```c
   int f(); int main() { int x = f() + f(); return x; }
   ```
   Verify push/pop still present (both operands are calls).

3. Golden-file test: mixed — one simple, one complex
   ```c
   int f(); int main() { int x = 1 + f(); return x; }
   ```
   Verify push/pop present (one operand is a call).

**Verification:**
```bash
# Compile demo2.c, count push/pop in main:
./components/cli/target/release/tc24r docs/demo2.c -o /tmp/test.s
grep -c 'push\|pop' /tmp/test.s
# Should drop significantly from current count

# All demos still pass:
reg-rs run -p tc24r
```

### Phase 3: Implement R2 — conditional branch fusion

**Goal:** When a comparison is the direct condition of an `if` or `while`,
emit fused compare+branch instead of materializing a boolean.

**Files to modify:**
- `components/codegen-stmt/crates/tc24r-stmt-control/src/` — if/while handlers
- `components/codegen-ops/crates/tc24r-ops-compare/src/compare.rs` — add
  `gen_compare_branch()` that emits compare+branch directly

**New API:**
```rust
/// Emit a comparison that branches to `label` when the condition is FALSE.
/// Returns true if fusion was applied, false if fallback needed.
fn gen_condition_branch(expr: &Expr, false_label: &str, state: &mut CodegenState) -> bool
```

**The key insight:** For `if (cond) { body }`, we need to skip body when
cond is false. So we emit a branch-to-skip when the condition is false:

| C condition | Emit | Branch |
|-------------|------|--------|
| `a == b`    | `ceq r0,r1` | `brf skip` (skip when not equal) |
| `a != b`    | `ceq r0,r1` | `brt skip` (skip when equal) |
| `a < b`     | `cls r0,r1` | `brf skip` (skip when not less) |
| `a >= b`    | `cls r0,r1` | `brt skip` (skip when less) |
| `a > b`     | `cls r1,r0` | `brf skip` (skip when not greater) |
| `a <= b`    | `cls r1,r0` | `brt skip` (skip when greater) |

**Tests:**
1. Golden-file test: `if (x != 0)` should produce `ceq; brt` (no mov r0,c)
2. Golden-file test: `if (x == 0)` should produce `ceq; brf`
3. Golden-file test: `if (x < 5)` should produce `cls; brf`
4. Golden-file test: `while (x != 0)` — same fusion in loop condition
5. Golden-file test: `int y = (a != b)` — must NOT fuse (result is used
   as a value, not a branch condition). Ensure materialization still works.

**Verification:**
```bash
# Compile demo2.c, verify no "mov r0,c" after ceq in if-conditions:
./components/cli/target/release/tc24r docs/demo2.c -o /tmp/test.s
grep -A1 'ceq' /tmp/test.s   # Should show brt/brf, not "mov r0,c"

reg-rs run -p tc24r
```

### Phase 4: Implement R3 — char-sized locals

**Goal:** Allocate 1 byte for `char` locals, use `sb`/`lb` for access.

**Files to modify:**
- `components/codegen-structure/crates/tc24r-struct-locals/src/collect.rs` —
  allocate 1 byte for char type
- `components/codegen-expr/crates/tc24r-expr-variable/src/` — use `sb`/`lb`
  for char locals
- `components/codegen-stmt/crates/tc24r-stmt-simple/src/` — char local decl

**Tests:**
1. Golden-file: `char a = 65; char b = 66;` — verify `sb` used, stack
   allocation smaller
2. Golden-file: mixed `int x; char c; int y;` — verify correct offsets
3. Ensure pointer-to-char (`char *pc = &ch; *pc`) still works

**Verification:**
```bash
reg-rs run -p tc24r   # All demos pass
# Verify stack allocation in main is smaller:
grep 'add.*sp' /tmp/test.s
```

### Phase 5: Implement R4, R5, R6 — polish

**R4: Negative address encoding**
- Modify literal emission to use signed representation when value > 0x7FFFFF
- File: `components/codegen-expr/crates/tc24r-expr-literal/src/`
- Test: `la r0,-65536` instead of `la r0,16711680`

**R5: Use `lb` for signed char reads**
- File: `components/codegen-expr/crates/tc24r-expr-pointer/src/deref.rs`
- Change `lbu` to `lb` for `char *` dereference
- Test: golden file showing `lb` instead of `lbu`

**R6: Omit zero offset**
- File: emission helpers in `components/codegen-emit/`
- Change `sb r0,0(r1)` → `sb r0,(r1)` when offset is 0
- Test: golden file

**Verification:**
```bash
reg-rs run -p tc24r
```

## Verification & Demonstration

### Quantitative Verification

After all phases, recompile `docs/demo2.c` and compare:

```bash
# Instruction count comparison
./components/cli/target/release/tc24r docs/demo2.c -o /tmp/tc24r-demo2-new.s
wc -l /tmp/tc24r-demo2-new.s           # target: <=130 lines (vs 227 current)
grep -c 'push\|pop' /tmp/tc24r-demo2-new.s   # target: <10 (vs ~30 current)
grep -c 'mov.*r0,c' /tmp/tc24r-demo2-new.s   # target: 0 in if-conditions
```

Expected results after all optimizations:

| Function     | cc24 (ref) | tc24r before | tc24r after (est.) |
|--------------|-----------|-------------|-------------------|
| `led_on`     | 9         | 13          | 9                 |
| `led_off`    | 9         | 13          | 9                 |
| `uart_putc`  | 14        | 19          | 15                |
| `main`       | 82        | 139         | ~90               |
| **Total**    | **114**   | **184**     | **~123**          |

### Regression Safety

Every phase must pass before proceeding:

```bash
# 1. All 29 reg-rs demos pass
reg-rs run -p tc24r

# 2. All cargo tests pass
cargo test --manifest-path components/backend/Cargo.toml
cargo test --manifest-path components/frontend/Cargo.toml
cargo test --manifest-path components/dispatch/Cargo.toml

# 3. demo2.c produces correct emulator output
bash demos/run-demo2.sh    # Must print "Demo 2 PASSED"
```

### Demonstration

After implementation, produce a before/after diff:

```bash
# Save "before" (current output, already captured in docs/demo2.s as reference)
# The "after" is the new tc24r output
diff docs/demo2.s /tmp/tc24r-demo2-new.s
```

The goal is for tc24r's output to closely resemble the reference cc24 output
in structure and instruction count, while remaining correct on all demos.

## Implementation Status

### Completed

**R1: Simple operand detection + skip push/pop** — DONE
- Added `is_simple_expr()` and `gen_simple_into_r1()` in `tc24r-type-infer`
- Optimized `eval_lhs_rhs()`, `gen_deref_assign()`, `gen_plain_add_sub()`,
  `gen_ptr_offset()`, `gen_ptr_diff()`

**R2: Conditional branch fusion** — DONE
- Added `gen_compare_branch()` and `gen_compare_branch_true()` in `tc24r-ops-compare`
- Added `gen_condition_skip()` and `gen_condition_loop()` in `tc24r-stmt-control`
- Applied to if, while, for, and do-while statements

**R7: Short branches for local labels** — DONE
- Changed `emit_brt`/`emit_brf`/`emit_bra` to use short branch instructions
  for local labels (Lnn) and long form (la r2 + jmp) for global labels
- COR24 `brt`/`brf` have limited range; local labels are typically nearby,
  global/function labels may be far

### Results

demo2.c instruction counts:

| Metric | Original | After R1+R2+R7 | Reference (cc24) |
|--------|----------|----------------|-------------------|
| Instructions | 196 | **140** | 130 |
| Overhead | +51% | **+8%** | — |

### Remaining (R3-R6)

- **R3: Char-sized locals** — allocate 1 byte, use `sb`/`lb`
- **R4: Negative address encoding** — `la r0,-65536` vs `la r0,16711680`
- **R5: `lb` for signed char** — replace `lbu` with `lb`
- **R6: Omit zero offset** — `sb r0,(r1)` vs `sb r0,0(r1)`

## Dependencies & Risk

- **R1 has no dependencies** and is the highest-impact change
- **R2 depends on R1** (uses simple-operand detection for operand loading)
- **R3-R6 are independent** of each other and of R1/R2
- **R7 (short branches) is independent** but has a range limitation risk
- **Risk:** R2 (branch fusion) touches control flow — highest regression risk.
  The key safety check is that the fused path must only activate when the
  comparison is the *direct* condition of if/while, never when the result
  is used as a value (e.g., `int y = (a != b)`)

## Future: Shared ISA Crate for Branch Range Awareness

### Problem

COR24's `brt`/`brf` instructions have a limited offset range. The compiler
currently uses a heuristic (local labels = short branch, global labels =
long branch) but cannot guarantee short branches are in range for very
large functions. The assembler (cor24-run) errors on out-of-range branches
rather than relaxing them.

### Proposed Solution: `cor24-isa` shared crate

Extract ISA-specific knowledge (instruction encoding, branch ranges,
register definitions) from both the compiler and assembler into a shared
`cor24-isa` library crate:

```
cor24-isa (shared library)
├── Instruction encoding formats and sizes
├── Branch range limits (e.g., brt/brf: ±N bytes)
├── Register definitions (r0-r2, fp, sp, c, z, ir)
├── Addressing modes
└── Instruction validation

tc24r (compiler)                  cor24-run (assembler/emulator)
├── Uses cor24-isa for:           ├── Uses cor24-isa for:
│   ├── Branch range estimation   │   ├── Instruction encoding
│   ├── Instruction size calc     │   ├── Range validation
│   └── Register names            │   └── Branch relaxation
```

### Two approaches for branch safety

**Option A: Compiler-side estimation (two-pass)**
1. First pass: emit short branches, track estimated byte offsets
2. Second pass: check each short branch against `cor24-isa` range limits
3. Relax out-of-range branches to long form (la + jmp)

**Option B: Assembler-side relaxation (preferred)**
1. Compiler always emits short branches
2. Assembler detects out-of-range `brt`/`brf` targets
3. Assembler automatically relaxes to the long-branch sequence
4. This is how GNU `as` handles it — the compiler doesn't worry about ranges

Option B is cleaner because it keeps the compiler simple and puts encoding
knowledge where it belongs (the assembler). The `cor24-isa` crate would
provide the relaxation logic, ensuring both tools agree on encoding sizes
and branch limits.

### ISA pluggability

This also supports the broader goal of making tc24r's codegen ISA-pluggable.
COR24-specific emission (register names, instruction mnemonics, branch
encoding) is already annotated with `NOTE: COR24-specific` comments in:
- `tc24r-type-infer/src/simple.rs` — `gen_simple_into_r1()`
- `tc24r-ops-compare/src/compare.rs` — `gen_compare_branch()`
- `tc24r-emit-core/src/emit.rs` — branch emission
- `tc24r-emit-core/src/immediate.rs` — immediate loading

A future refactor would replace these with trait-based dispatch through
a target-specific backend, with `cor24-isa` being the first (and currently
only) target implementation.
