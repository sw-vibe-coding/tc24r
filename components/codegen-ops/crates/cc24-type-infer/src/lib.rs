//! Type inference for COR24 code generation.

mod infer;

pub use infer::expr_type;

/// Callback type for expression code generation.
///
/// Used by operator crates that need to recursively generate code for
/// sub-expressions (e.g., short-circuit logical operators, pointer arithmetic).
/// The caller at a higher DAG level passes its `gen_expr` function.
pub type GenExprFn = fn(&cc24_ast::Expr, &mut cc24_codegen_state::CodegenState);
