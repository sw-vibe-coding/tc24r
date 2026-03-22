//! Shared golden file test helper for cc24 test crates.

/// Run a golden file test comparing compiler output to expected assembly.
pub fn golden_test(name: &str) {
    let c_source =
        std::fs::read_to_string(format!("fixtures/{name}.c")).expect("missing .c fixture");
    let expected = std::fs::read_to_string(format!("fixtures/{name}.expected.s"))
        .expect("missing .expected.s fixture");
    let actual = cc24_test_compile::compile(&c_source);
    assert_eq!(actual, expected, "golden test failed for {name}");
}
