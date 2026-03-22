//! Output helpers.

use cc24_ast::{Expr, Program, Type};

use crate::Codegen;

impl Codegen {
    pub(crate) fn emit(&mut self, line: &str) {
        self.out.push_str(line);
        self.out.push('\n');
    }

    pub(crate) fn new_label(&mut self) -> String {
        let label = format!("L{}", self.label_counter);
        self.label_counter += 1;
        label
    }

    pub(crate) fn load_immediate(&mut self, val: i32) {
        if (-128..=127).contains(&val) {
            self.emit(&format!("        lc      r0,{val}"));
        } else {
            self.emit(&format!("        la      r0,{val}"));
        }
    }

    /// Emit startup code that calls _main and halts.
    pub(crate) fn emit_start(&mut self) {
        self.emit("        .globl  _start");
        self.emit("_start:");
        self.emit("        la      r0,_main");
        self.emit("        jal     r1,(r0)");
        self.emit("_halt:");
        self.emit("        bra     _halt");
    }

    /// Emit runtime helper routines (div, mod) if needed.
    pub(crate) fn emit_runtime(&mut self) {
        if self.needs_div || self.needs_mod {
            self.emit("");
            self.emit_divmod_routine();
        }
    }

    fn emit_divmod_routine(&mut self) {
        // Shared loop: r0=dividend, r1=divisor -> r0=remainder, r2=quotient
        // Called with args on stack: 9(fp)=dividend, 12(fp)=divisor

        if self.needs_div {
            self.emit("__cc24_div:");
            self.emit("        push    fp");
            self.emit("        push    r2");
            self.emit("        push    r1");
            self.emit("        mov     fp,sp");
            self.emit("        lw      r0,9(fp)");
            self.emit("        lw      r1,12(fp)");
            self.emit("        lc      r2,0");
            self.emit("__cc24_div_lp:");
            self.emit("        cls     r0,r1");
            self.emit("        brt     __cc24_div_dn");
            self.emit("        sub     r0,r1");
            self.emit("        add     r2,1");
            self.emit("        bra     __cc24_div_lp");
            self.emit("__cc24_div_dn:");
            self.emit("        mov     r0,r2"); // return quotient
            self.emit("        mov     sp,fp");
            self.emit("        pop     r1");
            self.emit("        pop     r2");
            self.emit("        pop     fp");
            self.emit("        jmp     (r1)");
        }

        if self.needs_mod {
            self.emit("__cc24_mod:");
            self.emit("        push    fp");
            self.emit("        push    r2");
            self.emit("        push    r1");
            self.emit("        mov     fp,sp");
            self.emit("        lw      r0,9(fp)");
            self.emit("        lw      r1,12(fp)");
            self.emit("__cc24_mod_lp:");
            self.emit("        cls     r0,r1");
            self.emit("        brt     __cc24_mod_dn");
            self.emit("        sub     r0,r1");
            self.emit("        bra     __cc24_mod_lp");
            self.emit("__cc24_mod_dn:");
            // r0 already holds remainder
            self.emit("        mov     sp,fp");
            self.emit("        pop     r1");
            self.emit("        pop     r2");
            self.emit("        pop     fp");
            self.emit("        jmp     (r1)");
        }
    }

    pub(crate) fn emit_data_section(&mut self, program: &Program) {
        let has_globals = !program.globals.is_empty();
        let has_strings = !self.string_literals.is_empty();
        if !has_globals && !has_strings {
            return;
        }
        self.emit("");
        self.emit("        .data");
        for g in &program.globals {
            self.emit(&format!("_{}:", g.name));
            let val = match &g.init {
                Some(Expr::IntLit(v)) => *v,
                _ => 0,
            };
            if g.ty == Type::Char {
                self.emit(&format!("        .byte   {val}"));
            } else {
                self.emit(&format!("        .word   {val}"));
            }
        }
        for (i, s) in self.string_literals.clone().iter().enumerate() {
            self.emit(&format!("_S{i}:"));
            let bytes: Vec<String> = s
                .bytes()
                .chain(std::iter::once(0))
                .map(|b| b.to_string())
                .collect();
            self.emit(&format!("        .byte   {}", bytes.join(",")));
        }
    }
}
