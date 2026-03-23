# tc24r Architecture

## Component Layout

The compiler is split into 4 components, each a Cargo workspace with
multiple crates under a `crates/` directory:

```
components/
  core/                          -- shared types
    crates/
      tc24r-ast/                  -- AST node types (Program, Function, Stmt, Expr, Type)
      tc24r-error/                -- CompileError type
      tc24r-span/                 -- Source location (file, line, column)
      tc24r-token/                -- TokenKind enum and Token struct

  frontend/                      -- source text to AST
    crates/
      tc24r-preprocess/           -- #define, #include, #pragma once
      tc24r-preprocess-tests/     -- preprocessor test suite
      tc24r-lexer/                -- tokenizer (operators, readers, main loop)
      tc24r-lexer-tests/          -- lexer test suite
      tc24r-parse-stream/         -- token stream with expect/peek helpers
      tc24r-parser/               -- recursive-descent parser
      tc24r-parser-tests/         -- parser test suite

  backend/                       -- AST to assembly
    crates/
      tc24r-codegen/              -- COR24 assembly emitter
      tc24r-codegen-tests/        -- golden file tests and codegen checks
      tc24r-codegen-validate/     -- assembler validation (cor24-run and as24)

  cli/                           -- binary entry point
    crates/
      tc24r/                      -- main.rs, argument parsing, orchestration
```

14 crates total. Test crates are separated from library crates so that
test dependencies do not affect the library build.

## Data Flow

Source code flows through the compiler in a linear pipeline:

```
input.c
  |
  v
[preprocess] -- #define substitution, #include expansion, #pragma once
  |
  v
preprocessed source text
  |
  v
[lexer] -- tokenize into TokenKind stream
  |
  v
token stream
  |
  v
[parser] -- recursive descent, produces AST
  |
  v
AST (Program -> Vec<Function> + Vec<Global>)
  |
  v
[codegen] -- walk AST, emit COR24 assembly text
  |
  v
output.s
```

There is no intermediate representation (IR). The AST is walked directly
by the code generator to emit assembly, following the chibicc approach.

## Crate Dependencies

Dependencies flow in one direction: cli -> backend -> frontend -> core.

```
tc24r (cli)
  |
  +-- tc24r-codegen
  |     +-- tc24r-ast
  |     +-- tc24r-error
  |     +-- tc24r-span
  |
  +-- tc24r-parser
  |     +-- tc24r-ast
  |     +-- tc24r-token
  |     +-- tc24r-parse-stream
  |           +-- tc24r-token
  |           +-- tc24r-span
  |           +-- tc24r-error
  |
  +-- tc24r-lexer
  |     +-- tc24r-token
  |     +-- tc24r-span
  |
  +-- tc24r-preprocess
        +-- tc24r-span
```

## Design Constraints

The codebase follows size constraints to keep modules focused:

- **< 5 public functions per module** -- each .rs file has a narrow API
- **< 5 modules per crate** -- crates stay small and single-purpose
- **Prefer many small crates** over few large ones
- **Test crates are separate** -- tc24r-lexer-tests, tc24r-parser-tests, etc.
- **No circular dependencies** -- strictly layered

## Key Design Decisions

### No IR

The compiler emits assembly directly from the AST. This keeps the codebase
small and follows chibicc's architecture. The tradeoff is that optimization
passes would need to work on either the AST or the assembly text.

### Push/Pop Expression Evaluation

Binary expressions are evaluated by:
1. Evaluate left-hand side into r0
2. Push r0
3. Evaluate right-hand side into r0
4. Pop r1 (left-hand side)
5. Apply operator: r0 = r1 op r0

This is simple and correct but generates more push/pop pairs than necessary.
A future peephole pass could eliminate redundant stack traffic.

### Stack-Allocated Locals

At function entry, a pre-pass counts all local variable declarations
(including arrays) and allocates stack space with a single `sub sp,N`.
Variables are accessed at negative offsets from fp. Array elements are
contiguous starting from the variable's base offset.

### Label Generation

Labels are generated from a monotonic counter: L0, L1, L2, etc. Each
control-flow construct consumes one or more labels. The counter is global
across all functions in a translation unit.

### Software Division

COR24 has no hardware divide instruction. When the compiler encounters
`/` or `%`, it emits calls to `__tc24r_div` or `__tc24r_mod` helper
functions. These are emitted once at the end of the assembly output
if used.

## Module Breakdown

### tc24r-codegen Modules

| Module | Purpose |
|--------|---------|
| lib.rs | Top-level codegen entry, _start, globals, runtime helpers |
| func.rs | Function prologue/epilogue, ISR variant |
| stmt.rs | Statement dispatch (if, while, for, return, decl, assign) |
| expr.rs | Expression dispatch (literals, variables, unary, call, cast) |
| binop.rs | Binary operator code generation |
| emit.rs | Assembly text emission helpers |
| runtime.rs | __tc24r_div and __tc24r_mod implementations |

### tc24r-parser Modules

| Module | Purpose |
|--------|---------|
| lib.rs | Top-level parse entry, function and global parsing |
| decl.rs | Type parsing, variable declarations |
| stmt.rs | Statement parsing |
| expr.rs | Expression parsing, precedence climbing |
| arithmetic.rs | Arithmetic and comparison subexpressions |
| bitwise.rs | Bitwise operator subexpressions |
| control.rs | if, while, for, do...while parsing |

### tc24r-lexer Modules

| Module | Purpose |
|--------|---------|
| lib.rs | Main tokenizer loop |
| operators.rs | Multi-character operator recognition |
| readers.rs | String, number, identifier readers |
