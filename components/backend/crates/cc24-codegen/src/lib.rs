//! COR24 assembly code generator.

mod binop;
mod codegen;
mod emit;
mod expr;
mod func;
mod runtime;
mod stmt;

pub use codegen::Codegen;
