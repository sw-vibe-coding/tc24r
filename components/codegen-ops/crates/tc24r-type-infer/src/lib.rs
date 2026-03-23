//! Type inference and operand classification for COR24 code generation.

mod infer;
mod simple;

pub use infer::expr_type;
pub use simple::{gen_simple_into_r1, is_simple_expr};

/// Callback type for expression code generation.
///
/// Used by operator crates that need to recursively generate code for
/// sub-expressions (e.g., short-circuit logical operators, pointer arithmetic).
/// The caller at a higher DAG level passes its `gen_expr` function.
pub type GenExprFn = fn(&tc24r_ast::Expr, &mut tc24r_codegen_state::CodegenState);
