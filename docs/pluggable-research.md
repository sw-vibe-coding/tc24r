# Pluggable Target ISA: Research & Feasibility

## Current Architecture

### Register Set (COR24)

COR24 has 8 registers, all 24-bit wide:

| Register | Alias | Role |
|----------|-------|------|
| r0 | — | GPR, return value, primary scratch (caller-saved) |
| r1 | — | Link register / GPR, second scratch (caller-saved) |
| r2 | — | GPR, register variable (callee-saved) |
| r3 | fp | Frame pointer (callee-saved) |
| r4 | sp | Stack pointer (grows downward) |
| r5 | z | Zero register (read-only) |
| r6 | iv | Interrupt vector |
| r7 | ir | Interrupt return address |

Only r0, r1, r2 are truly general-purpose for arithmetic/logic.

### Register Allocation Strategy

There is **no traditional register allocator** (no liveness analysis, no graph
coloring, no spilling heuristics). The compiler uses fixed register assignments:

- **r0** always holds the current expression result
- **r1** holds the second operand in binary operations
- **r2** is callee-saved across function calls

Binary expressions use a push/pop stack strategy
(`codegen-ops/crates/tc24r-ops-arithmetic/src/arithmetic.rs`):

```
1. Evaluate LHS → r0
2. push r0
3. Evaluate RHS → r0
4. mov r1, r0
5. pop r0
6. op r0, r1        ; result in r0
```

The stack **is** the spill mechanism. This is simple but generates many
push/pop pairs.

### Codegen Organization

The codegen is split across ~20 small crates:

```
codegen-state/     → CodegenState (mutable bag of state)
codegen-emit/      → emit primitives, load/store, data section
codegen-structure/ → prologue/epilogue, locals collection, ISR
codegen-expr/      → literals, variables, calls, pointers, structs
codegen-ops/       → arithmetic, bitwise, compare, logical, divmod
codegen-stmt/      → control flow, simple statements
backend/           → Codegen orchestrator, dispatch
```

Handler traits (`StmtHandler`, `ExprHandler` in
`core/crates/tc24r-traits/src/traits.rs`) provide pluggable dispatch for
statements and expressions, but they operate on a COR24-specific
`CodegenState`.

---

## Modularity Assessment

### What is already well-factored

- Clean crate boundaries with one-directional dependencies
- Handler trait pattern (`StmtHandler`/`ExprHandler`) for dispatch
- `TargetConfig` crate exists (`config/crates/tc24r-target/`) — currently
  holds only hardware addresses, but is the right shape for expansion
- Small focused modules (< 5 public functions each)
- Design constraints enforced: no circular deps, few modules per crate

### What is tightly coupled to COR24

- **Register names** (`R0`, `R1`, `R2`, `FP`, `SP`, `Z`) are hardcoded as
  string literals throughout all codegen crates
- **`Reg` enum** (`macros/crates/tc24r-asm-dsl/src/reg.rs`) is a fixed
  8-register set
- **Calling convention** (push fp/r2/r1, frame layout, arg offsets at fp+9)
  is baked into `codegen-structure`
- **Push/pop evaluation strategy** assumes COR24's 3-byte word push/pop
- **`load_immediate`** hardcodes `lc`/`la` instruction selection thresholds
- **Branch helpers** (`emit_bra`/`emit_brt`/`emit_brf`) emit COR24-specific
  instruction sequences

---

## Target Description File Design

A TOML profile could describe a pluggable ISA:

```toml
[isa]
name = "COR24"
word_size = 3          # bytes
endian = "big"

[registers]
gpr = ["r0", "r1", "r2"]
frame_pointer = "fp"
stack_pointer = "sp"
zero = "z"
link = "r1"            # doubles as GPR
return_value = "r0"
callee_saved = ["r2"]
caller_saved = ["r0", "r1"]

[registers.special]
interrupt_vector = "iv"
interrupt_return = "ir"

[abi]
arg_passing = "stack"          # vs "register" for RISC-V, ARM, etc.
stack_growth = "down"
arg_slot_size = 3
frame_saved_regs = ["fp", "r2", "r1"]  # push order in prologue

[immediates]
signed_small_range = [-128, 127]       # use short encoding (lc)
# anything outside this range uses full-width encoding (la)

[instructions]
add = "add"
sub = "sub"
mul = "mul"
load_word = "lw"
store_word = "sw"
load_byte = "lb"
load_byte_unsigned = "lbu"
store_byte = "sb"
push = "push"
pop = "pop"
jump = "jmp"
jump_and_link = "jal"
branch_true = "brt"
branch_false = "brf"
compare_eq = "ceq"
compare_lt_signed = "cls"
compare_lt_unsigned = "clu"
load_const_short = "lc"
load_const_long = "la"
move = "mov"
shift_left = "shl"
shift_right_logical = "srl"
shift_right_arith = "sra"
bitwise_and = "and"
bitwise_or = "or"
bitwise_xor = "xor"
```

A second ISA (hypothetical 32-bit RISC with more registers) might look like:

```toml
[isa]
name = "RV32-subset"
word_size = 4
endian = "little"

[registers]
gpr = ["a0", "a1", "a2", "a3", "t0", "t1", "t2"]
frame_pointer = "s0"
stack_pointer = "sp"
zero = "x0"
link = "ra"
return_value = "a0"
callee_saved = ["s0", "s1", "s2"]
caller_saved = ["a0", "a1", "a2", "a3", "t0", "t1", "t2"]

[abi]
arg_passing = "register"       # first 4 args in a0-a3, rest on stack
arg_registers = ["a0", "a1", "a2", "a3"]
stack_growth = "down"
arg_slot_size = 4
frame_saved_regs = ["ra", "s0"]
```

---

## Refactoring Plan

### Layer-by-layer changes

| Layer | Current State | Target-Agnostic Version |
|-------|--------------|------------------------|
| `Reg` enum | Fixed 8 COR24 registers | Dynamic `RegisterFile` loaded from config |
| `emit_bra/brt/brf` | Hardcoded COR24 sequences | `TargetEmitter` trait with per-ISA impls |
| `load_immediate` | COR24 `lc`/`la` thresholds | Config-driven immediate ranges |
| Prologue/epilogue | Hardcoded push fp/r2/r1 | Generated from `abi.frame_saved_regs` |
| Binary op pattern | Fixed r0/r1 push/pop | Parameterized by `gpr[0]`/`gpr[1]` |
| `CodegenState` | COR24 offsets (fp+9, etc.) | Computed from `frame_saved_regs.len() * word_size` |
| Arg passing | Stack-only | Conditional: register-first if `arg_registers` defined |

### Recommended refactoring order

1. **Create `TargetDesc` struct** loaded from TOML (extend the existing
   `tc24r-target` crate using `serde` + `toml`)
2. **Thread `TargetDesc` through `CodegenState`** — it already flows to all
   codegen functions
3. **Replace hardcoded register names** with `target.reg.return_value`,
   `target.reg.frame_pointer`, etc.
4. **Extract an `Emitter` trait** from `tc24r-emit-core` with methods like
   `emit_branch`, `emit_load_immediate`, `emit_prologue`
5. **Parameterize the binary-op push/pop pattern** by primary/secondary GPR
6. **Compute ABI offsets** from config (`frame_saved_regs.len() * word_size`
   replaces hardcoded `+9`)
7. **Keep the handler traits** — `StmtHandler`/`ExprHandler` are already
   the right shape, just need `TargetDesc` in scope

### Migration strategy

The crate structure helps here — each crate is small enough to refactor
independently. Start with `codegen-emit` (the lowest layer) and work upward.
Each crate can be migrated while keeping the rest of the compiler functional.

---

## Effort Estimate

**Difficulty: Medium.**

The hard part is not architectural — the crate boundaries are clean. The work
is in the ~50-100 places where COR24 mnemonics and register names appear as
string literals in emit calls. But the small-crate design means each crate
can be migrated and tested independently.

### What stays the same across targets

- AST representation (`tc24r-ast`)
- Parser and lexer (`tc24r-parser`, `tc24r-lexer`)
- Preprocessor (`tc24r-preprocessor`)
- Type system and type inference (`tc24r-ops-type-infer`)
- Handler trait dispatch pattern
- Overall pipeline: source → AST → codegen → assembly text

### What changes per target

- Register file definition
- Instruction mnemonics
- Calling convention and ABI
- Immediate encoding thresholds
- Branch/jump sequences
- Prologue/epilogue generation
- Load/store instruction selection
- Runtime helpers (division, modulo, floating point)

### Limitations of a pure TOML approach

A TOML profile can describe the **data** of a target (registers, mnemonics,
ABI parameters) but cannot express **behavioral differences** like:

- Complex addressing modes (base+index*scale on x86)
- Multi-instruction sequences for operations the ISA lacks
- Register-pair conventions (e.g., 64-bit results in two 32-bit registers)
- ISA-specific peephole optimizations

For these, a hybrid approach works: TOML for data + a Rust trait impl per
target for behavioral overrides. The TOML handles 80% of the configuration;
the trait impl handles the remaining 20% that requires procedural logic.
