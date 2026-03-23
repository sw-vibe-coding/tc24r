//! Simple operand detection and direct r1 loading.
//!
//! A "simple" expression can be loaded into a register with 1-2 instructions
//! and has no side effects. When the RHS of a binary operation is simple,
//! we can skip the push/pop dance and load directly into r1.

use tc24r_ast::Expr;
use tc24r_codegen_state::CodegenState;
use tc24r_emit_macros::emit;

/// Returns true if `expr` can be loaded into a register without side effects
/// and without clobbering other registers (i.e., 1-2 instructions, no calls).
///
/// This predicate is ISA-independent — it classifies expression complexity,
/// not instruction selection.
pub fn is_simple_expr(expr: &Expr, state: &CodegenState) -> bool {
    match expr {
        Expr::IntLit(_) => true,
        Expr::Ident(name) => {
            // Local variables are a single load instruction.
            // Globals require 2 instructions (la + lw) but are still simple.
            state.locals.contains_key(name) || state.globals.contains(name)
        }
        _ => false,
    }
}

/// Load a simple expression directly into r1 instead of r0.
///
/// Caller must verify `is_simple_expr()` first. Panics if called on
/// a non-simple expression.
///
/// NOTE: This function emits COR24-specific instructions (lc, la, lw, lbu).
/// A future ISA abstraction layer would replace this with target-specific
/// register-targeting load helpers.
pub fn gen_simple_into_r1(expr: &Expr, state: &mut CodegenState) {
    match expr {
        Expr::IntLit(val) => {
            if (-128..=127).contains(val) {
                emit!(state, "        lc      r1,{val}");
            } else {
                emit!(state, "        la      r1,{val}");
            }
        }
        Expr::Ident(name) => {
            if state.globals.contains(name) {
                let is_char =
                    state.global_types.get(name) == Some(&tc24r_ast::Type::Char);
                // For globals: load address into r1, then load value.
                // We use r1 as both address holder and destination.
                emit!(state, "        la      r1,_{name}");
                if is_char {
                    emit!(state, "        lbu     r1,0(r1)");
                } else {
                    emit!(state, "        lw      r1,0(r1)");
                }
            } else {
                let offset = state.locals[name];
                emit!(state, "        lw      r1,{offset}(fp)");
            }
        }
        _ => panic!("gen_simple_into_r1 called on non-simple expr: {expr:?}"),
    }
}
