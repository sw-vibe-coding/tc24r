//! If/else statement code generation.

use tc24r_ast::{Block, Expr, Stmt};
use tc24r_codegen_state::CodegenState;
use tc24r_emit_core::{emit_bra, new_label};
use tc24r_emit_macros::emit;
use tc24r_stmt_simple::GenStmtFn;
use tc24r_type_infer::GenExprFn;

use crate::condition::gen_condition_skip;

/// Generate code for `if (cond) { then } else { else }`.
///
/// Uses fused compare+branch when the condition is a comparison operator,
/// avoiding boolean materialization.
pub fn gen_if(
    state: &mut CodegenState,
    cond: &Expr,
    then_body: &Block,
    else_body: Option<&Block>,
    gen_expr_fn: GenExprFn,
    gen_stmt_fn: GenStmtFn,
) {
    let else_label = new_label(state);
    let done_label = new_label(state);

    let skip_label = if else_body.is_some() {
        &else_label
    } else {
        &done_label
    };
    gen_condition_skip(state, cond, skip_label, gen_expr_fn);

    emit_block(state, &then_body.stmts, gen_stmt_fn);

    if let Some(eb) = else_body {
        emit_bra(state, &done_label);
        emit!(state, "{else_label}:");
        emit_block(state, &eb.stmts, gen_stmt_fn);
    }

    emit!(state, "{done_label}:");
}

/// Emit code for each statement in a block.
fn emit_block(state: &mut CodegenState, stmts: &[Stmt], gen_stmt_fn: GenStmtFn) {
    for s in stmts {
        gen_stmt_fn(s, state);
    }
}
