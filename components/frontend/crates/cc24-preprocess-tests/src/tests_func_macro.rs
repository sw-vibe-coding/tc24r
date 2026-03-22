//! Tests for function-like macro expansion.

use cc24_preprocess::preprocess;

#[test]
fn func_macro_add() {
    let input = "#define ADD(a,b) ((a)+(b))\nint main() { return ADD(3, 4); }\n";
    let output = preprocess(input, None, &[]);
    assert_eq!(output, "int main() { return ((3)+(4)); }\n");
}

#[test]
fn func_macro_assert() {
    let input = "#define ASSERT(x, y) assert(x, y, \"\")\nASSERT(42, 42);\n";
    let output = preprocess(input, None, &[]);
    assert_eq!(output, "assert(42, 42, \"\");\n");
}

#[test]
fn func_macro_nested_parens() {
    let input = "#define M(x) (x)\nM((3+2));\n";
    let output = preprocess(input, None, &[]);
    assert_eq!(output, "((3+2));\n");
}

#[test]
fn func_macro_nested_call_in_arg() {
    let input = "#define M(x) (x)\nM(func(a,b));\n";
    let output = preprocess(input, None, &[]);
    assert_eq!(output, "(func(a,b));\n");
}

#[test]
fn func_macro_no_params() {
    let input = "#define NOP() 0\nint x = NOP();\n";
    let output = preprocess(input, None, &[]);
    assert_eq!(output, "int x = 0;\n");
}

#[test]
fn func_macro_no_substitution_in_strings() {
    let input = "#define F(x) \"hello\" x\nF(world);\n";
    let output = preprocess(input, None, &[]);
    assert_eq!(output, "\"hello\" world;\n");
}

#[test]
fn func_macro_combined_with_simple_define() {
    let input = "#define VAL 42\n#define F(x) x + VAL\nint y = F(1);\n";
    let output = preprocess(input, None, &[]);
    assert_eq!(output, "int y = 1 + 42;\n");
}

#[test]
fn func_macro_not_invoked_without_parens() {
    let input = "#define F(x) (x)\nint F = 1;\n";
    let output = preprocess(input, None, &[]);
    assert_eq!(output, "int F = 1;\n");
}
