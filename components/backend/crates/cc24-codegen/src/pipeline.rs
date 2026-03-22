//! Dispatch pipeline: bridges the chain-of-responsibility dispatch
//! into the monolithic codegen.
//!
//! `build_stmt_chain()` creates a `Chain` of statement handlers.
//! `dispatch_stmt()` tries the chain first; returns `false` if no
//! handler matched (caller falls back to the existing match).
//!
//! The chain starts empty -- every statement still hits the fallback.
//! As handlers are extracted in later phases, they get registered here,
//! removing arms from the match in `stmt.rs` one at a time.

use cc24_ast::Stmt;
use cc24_dispatch::{Chain, Handler};

use crate::Codegen;

/// The concrete chain type used for statement dispatch.
pub(crate) type StmtChain = Chain<dyn Handler<Stmt, Codegen>>;

/// Build the statement handler chain.
///
/// Currently returns an empty chain (no handlers registered yet).
/// Each extracted handler will be added here.
pub(crate) fn build_stmt_chain() -> StmtChain {
    Chain::new()
}

/// Try dispatching a statement through the chain.
/// Returns `true` if a handler processed it, `false` otherwise.
pub(crate) fn dispatch_stmt(chain: &StmtChain, stmt: &Stmt, cg: &mut Codegen) -> bool {
    chain.dispatch(stmt, cg)
}
