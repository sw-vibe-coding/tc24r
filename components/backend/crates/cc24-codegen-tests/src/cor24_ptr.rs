//! cor24-run validation tests for pointer and char programs.

use super::assert_assembles_cor24;

#[test]
fn cor24_pointer_deref() {
    assert_assembles_cor24(
        "pointer_deref",
        "int main() { int x = 42; int *p = &x; return *p; }",
    );
}

#[test]
fn cor24_pointer_write() {
    assert_assembles_cor24(
        "pointer_write",
        "int main() { int x = 0; int *p = &x; *p = 99; return x; }",
    );
}

#[test]
fn cor24_char_local() {
    assert_assembles_cor24("char_local", "int main() { char c = 65; return c; }");
}
