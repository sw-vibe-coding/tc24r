//! Data section emission.

use tc24r_ast::{Expr, Program, Type};
use tc24r_codegen_state::CodegenState;
use tc24r_emit_macros::emit;

/// Emit the `.data` section for globals and string literals.
pub fn emit_data_section(state: &mut CodegenState, program: &Program) {
    let has_globals = !program.globals.is_empty();
    let has_strings = !state.string_literals.is_empty();
    if !has_globals && !has_strings {
        return;
    }
    emit!(state, "");
    emit!(state, "        .data");
    for g in &program.globals {
        let name = &g.name;
        emit!(state, "_{name}:");
        let val = match &g.init {
            Some(Expr::IntLit(v)) => *v,
            _ => 0,
        };
        match &g.ty {
            Type::Char => {
                emit!(state, "        .byte   {val}");
            }
            Type::Array(elem_ty, count) => {
                // Emit `count` zero-initialized elements
                let directive = if **elem_ty == Type::Char {
                    ".byte"
                } else {
                    ".word"
                };
                for _ in 0..*count {
                    emit!(state, "        {directive}   0");
                }
            }
            _ => {
                emit!(state, "        .word   {val}");
            }
        }
    }
    for (i, s) in state.string_literals.clone().iter().enumerate() {
        emit!(state, "_S{i}:");
        let bytes: Vec<String> = s
            .bytes()
            .chain(std::iter::once(0))
            .map(|b| b.to_string())
            .collect();
        let byte_str = bytes.join(",");
        emit!(state, "        .byte   {byte_str}");
    }
}
