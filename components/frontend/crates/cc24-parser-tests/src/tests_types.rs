//! Parser tests for type-related features: pointers, chars, for-loops.

use cc24_ast::{Expr, Stmt, Type};

use crate::parse_source;

#[test]
fn parse_for_loop() {
    let program = parse_source(
        "int main() { int s = 0; for (int i = 0; i < 10; i = i + 1) { s = s + i; } }",
    );
    assert!(matches!(
        &program.functions[0].body.stmts[1],
        Stmt::For { .. }
    ));
}

#[test]
fn parse_pointer_decl() {
    let program = parse_source("int main() { int *p; return 0; }");
    let stmts = &program.functions[0].body.stmts;
    assert!(matches!(
        &stmts[0],
        Stmt::LocalDecl {
            ty: Type::Ptr(_),
            ..
        }
    ));
}

#[test]
fn parse_addr_of_and_deref() {
    let program = parse_source("int main() { int x = 42; int *p = &x; return *p; }");
    let stmts = &program.functions[0].body.stmts;
    assert_eq!(stmts.len(), 3);
    // p = &x
    assert!(matches!(
        &stmts[1],
        Stmt::LocalDecl {
            ty: Type::Ptr(_),
            init: Some(Expr::AddrOf(_)),
            ..
        }
    ));
    // return *p
    assert!(matches!(&stmts[2], Stmt::Return(Expr::Deref(_))));
}

#[test]
fn parse_char_local() {
    let program = parse_source("int main() { char c = 65; return c; }");
    let stmts = &program.functions[0].body.stmts;
    assert!(matches!(&stmts[0], Stmt::LocalDecl { ty: Type::Char, .. }));
}
