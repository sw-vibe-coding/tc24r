//! For-loop statement code generation.

use tc24r_ast::{Block, Expr, Stmt};
use tc24r_codegen_state::CodegenState;
use tc24r_emit_core::{emit_bra, new_label};
use tc24r_emit_macros::emit;
use tc24r_stmt_simple::GenStmtFn;
use tc24r_type_infer::GenExprFn;

use crate::condition::gen_condition_skip;

/// Generate code for `for (init; cond; inc) { body }`.
///
/// The continue label points to the increment, not the condition check.
/// Uses fused compare+branch when the condition is a comparison operator.
pub fn gen_for(
    state: &mut CodegenState,
    init: Option<&Stmt>,
    cond: Option<&Expr>,
    inc: Option<&Expr>,
    body: &Block,
    gen_expr_fn: GenExprFn,
    gen_stmt_fn: GenStmtFn,
) {
    if let Some(init_stmt) = init {
        gen_stmt_fn(init_stmt, state);
    }

    let loop_label = new_label(state);
    let cont_label = new_label(state);
    let done_label = new_label(state);
    state.break_labels.push(done_label.clone());
    state.continue_labels.push(cont_label.clone());

    emit!(state, "{loop_label}:");
    if let Some(cond_expr) = cond {
        gen_condition_skip(state, cond_expr, &done_label, gen_expr_fn);
    }

    emit_block(state, &body.stmts, gen_stmt_fn);

    emit!(state, "{cont_label}:");
    if let Some(inc_expr) = inc {
        gen_expr_fn(inc_expr, state);
    }

    emit_bra(state, &loop_label);
    emit!(state, "{done_label}:");
    state.break_labels.pop();
    state.continue_labels.pop();
}

/// Emit code for each statement in a block.
fn emit_block(state: &mut CodegenState, stmts: &[Stmt], gen_stmt_fn: GenStmtFn) {
    for s in stmts {
        gen_stmt_fn(s, state);
    }
}
