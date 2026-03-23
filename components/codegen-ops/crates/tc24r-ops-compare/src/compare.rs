//! Comparison operators. Assumes r0=lhs, r1=rhs already evaluated.
//!
//! Two modes:
//! - **Materialize**: produce a 0/1 boolean in r0 (for use as a value)
//! - **Branch fusion**: emit compare + branch directly (for if/while conditions)

use tc24r_ast::BinOp;
use tc24r_codegen_state::CodegenState;
use tc24r_emit_core::{emit_brf, emit_brt};
use tc24r_emit_macros::emit;

/// Equality comparison: r0 = (r0 == r1) or r0 = (r0 != r1).
///
/// Pass `negate: false` for `==`, `true` for `!=`.
pub fn gen_compare_eq(state: &mut CodegenState, negate: bool) {
    emit!(state, "        ceq     r0,r1");
    emit!(state, "        mov     r0,c");
    if negate {
        emit!(state, "        ceq     r0,z");
        emit!(state, "        mov     r0,c");
    }
}

/// Relational comparison. Assumes r0=lhs, r1=rhs already evaluated.
///
/// `kind` selects the comparison:
/// - `Lt`: r0 < r1
/// - `Gt`: r0 > r1
/// - `Le`: r0 <= r1
/// - `Ge`: r0 >= r1
pub fn gen_compare_rel(state: &mut CodegenState, kind: RelKind) {
    match kind {
        RelKind::Lt => {
            emit!(state, "        cls     r0,r1");
            emit!(state, "        mov     r0,c");
        }
        RelKind::Gt => {
            emit!(state, "        cls     r1,r0");
            emit!(state, "        mov     r0,c");
        }
        RelKind::Le => {
            emit!(state, "        cls     r1,r0");
            emit!(state, "        mov     r0,c");
            emit!(state, "        ceq     r0,z");
            emit!(state, "        mov     r0,c");
        }
        RelKind::Ge => {
            emit!(state, "        cls     r0,r1");
            emit!(state, "        mov     r0,c");
            emit!(state, "        ceq     r0,z");
            emit!(state, "        mov     r0,c");
        }
    }
}

/// Relational comparison kind.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RelKind {
    Lt,
    Gt,
    Le,
    Ge,
}

/// Returns true if `op` is a comparison operator (==, !=, <, >, <=, >=).
pub fn is_comparison_op(op: BinOp) -> bool {
    matches!(
        op,
        BinOp::Eq | BinOp::Ne | BinOp::Lt | BinOp::Gt | BinOp::Le | BinOp::Ge
    )
}

/// Emit a comparison of r0 vs r1 and branch to `skip_label` when the
/// condition is FALSE. Used for branch fusion in if/while/for conditions.
///
/// For `if (a != b) { body }`, we want to skip body when a == b:
/// - Ne → ceq r0,r1; branch-if-true (skip when equal)
/// - Eq → ceq r0,r1; branch-if-false (skip when not equal)
///
/// NOTE: This emits COR24-specific branch instructions (ceq, cls, brt, brf).
pub fn gen_compare_branch(state: &mut CodegenState, op: BinOp, skip_label: &str) {
    match op {
        BinOp::Eq => {
            // skip body when NOT equal
            emit!(state, "        ceq     r0,r1");
            emit_brf(state, skip_label);
        }
        BinOp::Ne => {
            // skip body when equal
            emit!(state, "        ceq     r0,r1");
            emit_brt(state, skip_label);
        }
        BinOp::Lt => {
            // skip body when NOT (r0 < r1)
            emit!(state, "        cls     r0,r1");
            emit_brf(state, skip_label);
        }
        BinOp::Ge => {
            // skip body when r0 < r1
            emit!(state, "        cls     r0,r1");
            emit_brt(state, skip_label);
        }
        BinOp::Gt => {
            // skip body when NOT (r1 < r0)
            emit!(state, "        cls     r1,r0");
            emit_brf(state, skip_label);
        }
        BinOp::Le => {
            // skip body when r1 < r0
            emit!(state, "        cls     r1,r0");
            emit_brt(state, skip_label);
        }
        _ => panic!("gen_compare_branch called with non-comparison op: {op:?}"),
    }
}

/// Like `gen_compare_branch` but branches when the condition is TRUE.
/// Used for do-while loops (loop back when condition holds).
pub fn gen_compare_branch_true(state: &mut CodegenState, op: BinOp, loop_label: &str) {
    match op {
        BinOp::Eq => {
            emit!(state, "        ceq     r0,r1");
            emit_brt(state, loop_label);
        }
        BinOp::Ne => {
            emit!(state, "        ceq     r0,r1");
            emit_brf(state, loop_label);
        }
        BinOp::Lt => {
            emit!(state, "        cls     r0,r1");
            emit_brt(state, loop_label);
        }
        BinOp::Ge => {
            emit!(state, "        cls     r0,r1");
            emit_brf(state, loop_label);
        }
        BinOp::Gt => {
            emit!(state, "        cls     r1,r0");
            emit_brt(state, loop_label);
        }
        BinOp::Le => {
            emit!(state, "        cls     r1,r0");
            emit_brf(state, loop_label);
        }
        _ => panic!("gen_compare_branch_true called with non-comparison op: {op:?}"),
    }
}
