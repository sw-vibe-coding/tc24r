# tc24r Architecture Refactor Plan

## Design Philosophy

The compiler is a **pipeline of configured, composable stages**. Each
stage is independently testable, replaceable, and extensible. Features
are not locations in code -- they are **handlers that plug into
dispatch chains**. Adding, reimplementing, or removing a feature should
not require modifying other features.

The architecture has these **top-down roles**:

1. **Configuration** -- what the compiler should do (data, no behavior)
2. **Building** -- construct the configured pipeline (wiring, no execution)
3. **Dispatch** -- route work to the right handler (delegation, no logic)
4. **Functional** -- do the actual work (pure transforms, stateless where possible)
5. **Testing** -- verify everything works (shared helpers, fixtures, fakes)

## Architectural Components

Every component below represents an **architectural role**, not a
grouping of existing code. Components are sparse by design -- many small
parts are better than few large ones.

### config/ -- Configuration (data only)

Defines what the compiler does. No behavior, no I/O.

```
config/
  crates/
    tc24r-config/          -- CompilerConfig struct: source path, output path,
                             include dirs, target, optimization level, flags
    tc24r-target/          -- TargetConfig: COR24-TB register addresses,
                             word size, stack init, ISR conventions
```

A CompilerConfig is a plain data struct. It does not know how to parse
CLI args or read files. It is constructed by the builder.

### builder/ -- Pipeline Construction (wiring only)

Builds the configured pipeline from CLI args, env vars, and defaults.
Registers handlers. Instantiates stages. Produces a ready-to-run pipeline.

```
builder/
  crates/
    tc24r-cli-args/        -- parse CLI args into raw options
    tc24r-pipeline-builder/-- build Pipeline from CompilerConfig:
                             register stmt/expr/op handlers,
                             configure preprocessor include paths,
                             set target, wire stages together
```

The builder is the only place that knows about all the handler crates.
It imports them and registers them. The dispatch component does not
know what handlers exist.

### dispatch/ -- Chain-of-Responsibility (delegation only)

Generic dispatch infrastructure. Knows nothing about C, assembly, or
COR24. Pure delegation pattern.

```
dispatch/
  crates/
    tc24r-dispatch/        -- Handler<Input,State> trait, Chain<H> struct,
                             ChainBuilder, registration API
```

```rust
pub trait Handler<Input, State> {
    fn can_handle(&self, input: &Input) -> bool;
    fn handle(&self, input: &Input, state: &mut State);
}

pub struct Chain<H> {
    handlers: Vec<Box<H>>,
}
```

Statement dispatch, expression dispatch, operator dispatch, and
preprocessor directive dispatch all use the same Chain infrastructure
with different Input/State type parameters.

### core/ -- Shared Types and Traits (no behavior)

Data types and trait definitions. No implementations, no logic.

```
core/
  crates/
    tc24r-span/            -- Span (unchanged)
    tc24r-error/           -- CompileError (unchanged)
    tc24r-token/           -- Token, TokenKind (unchanged)
    tc24r-ast/             -- AST nodes: Program, Function, Stmt, Expr
    tc24r-types/           -- Type enum (Char, Int, Ptr, Array, Void)
    tc24r-traits/          -- Emitter trait, TypeQuery trait,
                             StmtHandler, ExprHandler, OpHandler
```

tc24r-traits defines the interfaces. Implementations live elsewhere.

### codegen-state/ -- Codegen State (struct only)

The mutable state threaded through code generation. No methods.

```
codegen-state/
  crates/
    tc24r-codegen-state/   -- CodegenState struct (pub fields):
                             output buffer, label counter, locals map,
                             local_types map, globals, break/continue
                             stacks, string literals, runtime flags
```

This crate has zero behavior. It is a plain data carrier.

### codegen-emit/ -- Low-Level Emission (mutating, target-specific)

Functions that write to the output buffer. Know about COR24 assembly
syntax but not about C language constructs.

```
codegen-emit/
  crates/
    tc24r-emit-core/       -- emit(), new_label(), load_immediate()
    tc24r-emit-data/       -- emit_data_section(), emit_start()
    tc24r-emit-load-store/ -- gen_load_by_name(), gen_store_by_name(),
                             load/store for globals vs locals, char vs int
```

### codegen-query/ -- Read-Only Analysis (non-mutating)

Pure functions that inspect AST nodes and state without modifying anything.

```
codegen-query/
  crates/
    tc24r-type-infer/      -- expr_type(): infer type of expression from state
    tc24r-type-query/      -- is_char_ptr(), pointee_type(), element_size()
```

### codegen-handlers/ -- Feature Handlers (one per feature)

Each handler implements a trait from tc24r-traits. Each handler is a
small crate with 1-3 functions. Adding a new C feature = adding a new
handler crate and registering it in the builder.

```
codegen-handlers/
  crates/
    tc24r-handle-return/       -- Stmt::Return handler
    tc24r-handle-if/           -- Stmt::If handler
    tc24r-handle-while/        -- Stmt::While handler
    tc24r-handle-dowhile/      -- Stmt::DoWhile handler
    tc24r-handle-for/          -- Stmt::For handler
    tc24r-handle-break/        -- Stmt::Break handler
    tc24r-handle-continue/     -- Stmt::Continue handler
    tc24r-handle-local-decl/   -- Stmt::LocalDecl handler
    tc24r-handle-asm/          -- Stmt::Asm handler
    tc24r-handle-expr-stmt/    -- Stmt::Expr handler

    tc24r-handle-intlit/       -- Expr::IntLit handler
    tc24r-handle-stringlit/    -- Expr::StringLit handler
    tc24r-handle-ident/        -- Expr::Ident (variable load + array decay)
    tc24r-handle-assign/       -- Expr::Assign handler
    tc24r-handle-call/         -- Expr::Call handler
    tc24r-handle-addr-of/      -- Expr::AddrOf handler
    tc24r-handle-deref/        -- Expr::Deref + DerefAssign handler
    tc24r-handle-cast/         -- Expr::Cast handler
    tc24r-handle-incdec/       -- PreInc, PreDec, PostInc, PostDec handler
    tc24r-handle-unary/        -- UnaryOp (neg, bitnot, lognot)

    tc24r-handle-add-sub/      -- BinOp::Add, Sub (with pointer arithmetic)
    tc24r-handle-mul/          -- BinOp::Mul
    tc24r-handle-div-mod/      -- BinOp::Div, Mod (software divide)
    tc24r-handle-bitwise/      -- BinOp::BitAnd, BitOr, BitXor, Shl, Shr
    tc24r-handle-compare/      -- BinOp::Eq, Ne, Lt, Gt, Le, Ge
    tc24r-handle-logical/      -- BinOp::LogAnd, LogOr (short-circuit)
```

### codegen-runtime/ -- Runtime Library Templates

Assembly templates emitted when certain features are used.

```
codegen-runtime/
  crates/
    tc24r-runtime-divmod/  -- __tc24r_div, __tc24r_mod assembly
    tc24r-runtime-isr/     -- ISR prologue/epilogue templates
    tc24r-runtime-start/   -- _start entry point template
```

### codegen/ -- Orchestrator (wiring only)

Thin orchestrator that owns the pipeline and drives it. Calls the builder,
then runs dispatch chains over the AST.

```
codegen/
  crates/
    tc24r-codegen/         -- generate(): build state, walk AST,
                             dispatch each node, emit runtime, emit data
    tc24r-func-codegen/    -- gen_function(): prologue, walk body, epilogue
    tc24r-locals-collect/  -- pre-pass to collect local variable declarations
```

### preprocess/ -- Preprocessor

```
preprocess/
  crates/
    tc24r-preprocess/
    tc24r-preprocess-tests/
```

### lexer/ -- Tokenization

```
lexer/
  crates/
    tc24r-lexer/
    tc24r-lexer-tests/
```

### parser/ -- Parsing

```
parser/
  crates/
    tc24r-parse-stream/
    tc24r-parser/
    tc24r-parser-tests/
```

### testing/ -- Test Infrastructure

Shared test helpers, fixtures, and validation. Every test crate depends
on this instead of duplicating compile/assert helpers.

```
testing/
  crates/
    tc24r-test-compile/    -- compile(): source -> assembly string
    tc24r-test-golden/     -- golden_test(): compare against .expected.s
    tc24r-test-cor24/      -- cor24-run path lookup, assemble_with_cor24_run()
    tc24r-test-as24/       -- as24 HTTP client, assert_assembles_http()
    tc24r-test-fixtures/   -- fixture path resolution, fixture management
```

### cli/ -- Entry Point (thin)

```
cli/
  crates/
    tc24r/                 -- main(): parse args -> build config -> build
                             pipeline -> read source -> run pipeline ->
                             write output
```

## Feature Lifecycle

Adding a new feature (e.g., switch/case):

1. Add `Stmt::Switch` to tc24r-ast (core)
2. Add `Switch` token to tc24r-token (core)
3. Add keyword to tc24r-lexer (lexer)
4. Add parsing to tc24r-parser (parser)
5. Create `tc24r-handle-switch` crate (codegen-handlers)
6. Register handler in tc24r-pipeline-builder (builder)
7. Create test in testing component
8. Create demo

Steps 1-4 touch existing crates minimally (add a variant, add a match arm).
Step 5 is a new crate -- no existing code modified.
Step 6 is one line: `chain.register(SwitchHandler);`

Removing a feature: delete the handler crate, remove registration.
Reimplementing: replace the handler crate, same interface.

## Phased Execution

### Phase 1: Infrastructure (config, builder, dispatch, testing)

Create the 5 architectural role components with minimal implementations.
Move existing compile/test helpers into testing component. Wire the
existing monolithic codegen through the new dispatch infrastructure.
All existing tests must still pass.

### Phase 2: Extract handlers from monolithic codegen

One handler at a time, extract from tc24r-codegen into a handler crate.
Each extraction is a small commit. The monolithic codegen shrinks as
handlers are extracted. Eventually the monolithic crate is empty and
deleted.

### Phase 3: Extract query and emit

Move type inference and read-only queries into codegen-query.
Move emit functions into codegen-emit.
Move runtime templates into codegen-runtime.

### Phase 4: Extract parser and lexer

Move preprocess, lexer, parser into their own components.
Remove the frontend component.

## Invariants

- Every commit: all tests pass, zero sw-checklist failures
- Every handler crate: 1-3 functions, 1-2 modules
- Every component: 2-4 crates
- No circular dependencies between components
- Config has no dependencies on any other component
- Dispatch has no dependencies on handlers
- Handlers depend on: core, codegen-state, codegen-emit, codegen-query
- Builder depends on: config, dispatch, all handler crates
- CLI depends on: config, builder, and the pipeline result
