//! Pre-pass to collect local variable declarations and allocate stack slots.

use cc24_ast::Stmt;
use cc24_codegen_state::CodegenState;

/// Walk a block of statements, allocating stack slots for any local
/// variable declarations found (including nested scopes).
pub fn collect_locals_block(state: &mut CodegenState, stmts: &[Stmt]) {
    for stmt in stmts {
        collect_locals_stmt(state, stmt);
    }
}

/// Allocate a stack slot for a local declaration, or recurse into
/// compound statements to find nested declarations.
pub fn collect_locals_stmt(state: &mut CodegenState, stmt: &Stmt) {
    match stmt {
        Stmt::LocalDecl { name, ty, .. } => {
            if !state.locals.contains_key(name) {
                let alloc = ty.size().max(3); // min 3 (word-aligned)
                state.locals_size += alloc;
                let offset = -state.locals_size;
                state.locals.insert(name.clone(), offset);
                state.local_types.insert(name.clone(), ty.clone());
            }
        }
        Stmt::If {
            then_body,
            else_body,
            ..
        } => {
            collect_locals_block(state, &then_body.stmts);
            if let Some(eb) = else_body {
                collect_locals_block(state, &eb.stmts);
            }
        }
        Stmt::While { body, .. } | Stmt::DoWhile { body, .. } => {
            collect_locals_block(state, &body.stmts);
        }
        Stmt::For { init, body, .. } => {
            if let Some(init_stmt) = init {
                collect_locals_stmt(state, init_stmt);
            }
            collect_locals_block(state, &body.stmts);
        }
        _ => {}
    }
}
