//! Shared compile helper for cc24 test crates.

/// Compile C source to COR24 assembly.
pub fn compile(source: &str) -> String {
    let tokens = cc24_lexer::Lexer::new(source)
        .tokenize()
        .expect("lexer failed");
    let program = cc24_parser::parse(tokens).expect("parser failed");
    cc24_codegen::Codegen::new().generate(&program)
}
