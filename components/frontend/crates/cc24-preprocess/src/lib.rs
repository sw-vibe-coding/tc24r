//! Simple C preprocessor for cc24.
//!
//! Supports `#define NAME value` constant substitution.
//! Runs as a text pass before lexing.

mod substitute;

use std::collections::HashMap;

/// Preprocess source text, expanding `#define` directives.
pub fn preprocess(source: &str) -> String {
    let mut defines: HashMap<String, String> = HashMap::new();
    let mut output = String::new();

    for line in source.lines() {
        let trimmed = line.trim_start();
        if let Some(rest) = trimmed.strip_prefix("#define ") {
            if let Some((name, value)) = parse_define(rest) {
                defines.insert(name, value);
            }
        } else {
            let expanded = substitute::expand_line(line, &defines);
            output.push_str(&expanded);
            output.push('\n');
        }
    }

    output
}

fn parse_define(rest: &str) -> Option<(String, String)> {
    let mut parts = rest.splitn(2, |c: char| c.is_ascii_whitespace());
    let name = parts.next()?.to_string();
    let value = parts.next().unwrap_or("").trim().to_string();
    Some((name, value))
}
