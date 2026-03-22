//! Integration tests for cc24-codegen.

#[cfg(test)]
mod codegen_checks;
#[cfg(test)]
mod golden;

/// Compile C source to COR24 assembly.
#[cfg(test)]
pub(crate) fn compile(source: &str) -> String {
    let tokens = cc24_lexer::Lexer::new(source)
        .tokenize()
        .expect("lexer failed");
    let program = cc24_parser::parse(tokens).expect("parser failed");
    cc24_codegen::Codegen::new().generate(&program)
}

/// Run a golden file test comparing compiler output to expected assembly.
#[cfg(test)]
pub(crate) fn golden_test(name: &str) {
    let c_source =
        std::fs::read_to_string(format!("fixtures/{name}.c")).expect("missing .c fixture");
    let expected = std::fs::read_to_string(format!("fixtures/{name}.expected.s"))
        .expect("missing .expected.s fixture");
    let actual = compile(&c_source);
    assert_eq!(actual, expected, "golden test failed for {name}");
}
