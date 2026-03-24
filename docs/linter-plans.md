# Linter Options for tc24r

## What We Have Today

| Tool | What it checks | When |
|------|---------------|------|
| `cargo clippy` | Rust source quality | Every build |
| reg-rs (26 baselines) | Assembly output stability | On demand |
| Codegen unit tests (22) | Structural correctness | `cargo test` |
| Demo scripts (46) | End-to-end correctness | On demand |

## Option 1: Inline asm() Validation (LOW effort, HIGH value)

Validate `asm("...")` strings at compile time using the shared `cor24-isa`
crate. Catch errors before the user runs the assembler.

**What it catches:**
- Invalid mnemonics (`asm("noop")` → unknown instruction)
- Bad register names (`asm("add r3,r0")` → r3 not valid for add)
- Invalid register combinations with no encoding (`asm("add fp,sp")`)
- Malformed operands (`asm("lc r0,")` → missing immediate)

**Implementation:**
- Add `cor24-isa` dependency to `tc24r-stmt-simple` (where `gen_asm` lives)
- Parse each line of the asm string through a lightweight validator
- Emit compiler warnings (not errors — the assembler is the authority)
- Reuse `cor24-isa::encode::encode_instruction()` for encoding validation

**Effort:** ~1 day. The encoding tables already exist in cor24-isa.

## Option 2: Generated Assembly Validation (LOW effort, MEDIUM value)

After codegen, pipe the full assembly output through the cor24-rs assembler
in dry-run mode to catch encoding errors, out-of-range branches, etc.

**What it catches:**
- Branch target too far (already fixed via deferred resolution, but safety net)
- Invalid instruction forms the codegen accidentally produces
- Label conflicts or undefined references

**Implementation:**
- Add `cor24-emulator` as an optional dev-dependency of tc24r-cli
- After generating assembly, call `Assembler::assemble()` and check errors
- Gate behind `--verify` flag (adds assembler overhead)

**Effort:** ~half day. Assembler already exists, just wire it up.

## Option 3: C Source Linter (MEDIUM effort, MEDIUM value)

Warn about C patterns that compile but produce surprising results on COR24.

**What it catches:**
- `>>` on signed int with negative values (implementation-defined behavior)
- Integer overflow beyond 24 bits (`int x = 100000 * 200`)
- `sizeof(int)` assumptions (3 bytes, not 4)
- Uninitialized global arrays used before assignment
- `char` signedness assumptions (tc24r char is signed)
- Large stack allocations that might exceed EBR

**Implementation:**
- Add a new `tc24r-lint` crate that walks the AST after parsing
- Emit warnings to stderr (separate from errors)
- Run as part of normal compilation (like GCC `-Wall`)

**Effort:** ~2-3 days for a useful initial set.

## Option 4: Assembly Pattern Linter (MEDIUM effort, LOW value)

Check the generated assembly for known-bad patterns.

**What it catches:**
- Unbalanced push/pop within a function
- Clobbering r1 (return address) without saving it
- Inline asm that modifies fp/sp without restoring
- Dead code after unconditional branch

**Implementation:**
- Post-pass over `state.out` after each function
- Pattern-match on instruction sequences
- Could live in `tc24r-codegen-validate` (already exists but empty)

**Effort:** ~2 days.

## Option 5: Assembler Compatibility Linter (LOW effort, LOW value)

Warn about assembly syntax that works in cor24-rs but not in the reference
as24 assembler (or vice versa).

**What it catches:**
- `0x` prefix in `.byte` directives (cor24-rs silently drops, as24 may differ)
- Instruction syntax differences between cor24-rs and as24
- Directives supported by one but not the other

**Implementation:**
- Table of known incompatibilities
- Check inline asm strings and generated output

**Effort:** ~half day.

## Recommendation

Start with **Option 1** (inline asm validation) — highest value-to-effort
ratio, and the `cor24-isa` infrastructure is already in place. Then add
**Option 2** (assembly verification behind `--verify`) as a safety net.
Options 3-5 are worth doing if specific classes of bugs keep recurring.
