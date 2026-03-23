//! While-loop statement code generation.

use tc24r_ast::{Block, Expr, Stmt};
use tc24r_codegen_state::CodegenState;
use tc24r_emit_core::{emit_bra, new_label};
use tc24r_emit_macros::emit;
use tc24r_stmt_simple::GenStmtFn;
use tc24r_type_infer::GenExprFn;

use crate::condition::gen_condition_skip;

/// Generate code for `while (cond) { body }`.
///
/// Uses fused compare+branch when the condition is a comparison operator.
pub fn gen_while(
    state: &mut CodegenState,
    cond: &Expr,
    body: &Block,
    gen_expr_fn: GenExprFn,
    gen_stmt_fn: GenStmtFn,
) {
    let loop_label = new_label(state);
    let done_label = new_label(state);
    state.break_labels.push(done_label.clone());
    state.continue_labels.push(loop_label.clone());

    emit!(state, "{loop_label}:");
    gen_condition_skip(state, cond, &done_label, gen_expr_fn);

    emit_block(state, &body.stmts, gen_stmt_fn);
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
