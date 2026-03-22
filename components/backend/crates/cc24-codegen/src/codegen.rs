use std::collections::{HashMap, HashSet};

use cc24_ast::{Program, Stmt, Type};
use cc24_dispatch::{Chain, Handler};

use crate::runtime;

/// Code generator state.
#[derive(Default)]
pub struct Codegen {
    pub(crate) out: String,
    pub(crate) label_counter: usize,
    pub(crate) locals: HashMap<String, i32>,
    pub(crate) local_types: HashMap<String, Type>,
    pub(crate) locals_size: i32,
    pub(crate) globals: HashSet<String>,
    pub(crate) global_types: HashMap<String, Type>,
    pub(crate) return_label: String,
    pub(crate) string_literals: Vec<String>,
    pub(crate) needs_div: bool,
    pub(crate) needs_mod: bool,
    pub(crate) break_labels: Vec<String>,
    pub(crate) continue_labels: Vec<String>,
}

impl Codegen {
    pub fn new() -> Self {
        Self::default()
    }

    /// Generate COR24 assembly for a program.
    pub fn generate(&mut self, program: &Program) -> String {
        let stmt_chain = build_stmt_chain();
        for g in &program.globals {
            self.globals.insert(g.name.clone());
            self.global_types.insert(g.name.clone(), g.ty.clone());
        }
        self.emit("        .text");
        self.emit("");
        self.emit_start();
        for func in &program.functions {
            self.emit("");
            self.gen_function(func, &stmt_chain);
        }
        runtime::emit_runtime(self);
        self.emit_data_section(program);
        self.out.clone()
    }
}

// --- Statement dispatch pipeline ---

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
