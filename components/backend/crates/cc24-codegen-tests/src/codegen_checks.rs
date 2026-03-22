//! Structural checks on codegen output (non-golden-file tests).

use super::compile;

#[test]
fn codegen_emits_start() {
    let output = compile("int main() { return 0; }");
    assert!(output.contains("_start:"));
    assert!(output.contains("la      r0,_main"));
    assert!(output.contains("jal     r1,(r0)"));
    assert!(output.contains("_halt:"));
    assert!(output.contains("bra     _halt"));
}

#[test]
fn codegen_isr_prologue_epilogue() {
    let output = compile("__attribute__((interrupt)) void isr() {} int main() { return 0; }");
    // ISR prologue saves all regs + condition flag
    assert!(output.contains("push    r0"));
    assert!(output.contains("mov     r2,c"));
    // ISR epilogue restores and uses jmp (ir)
    assert!(output.contains("clu     z,r2"));
    assert!(output.contains("jmp     (ir)"));
    // Normal main still uses jmp (r1)
    assert!(output.contains("jmp     (r1)"));
}
