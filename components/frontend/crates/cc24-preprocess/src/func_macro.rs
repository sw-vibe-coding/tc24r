//! Function-like macro support: storage, argument parsing, and expansion.

use std::collections::HashMap;

/// A function-like macro: `#define NAME(params) body`.
#[derive(Clone, Debug)]
pub struct FuncMacro {
    pub params: Vec<String>,
    pub body: String,
}

/// Parse parameter names from `"a, b)"` (after the opening paren).
/// Returns param list and the remaining body text after `) `.
pub fn parse_params_and_body(after_paren: &str) -> Option<(Vec<String>, String)> {
    let close = find_close_paren(after_paren)?;
    let param_str = &after_paren[..close];
    let params = parse_param_names(param_str);
    let body = after_paren[close + 1..].trim().to_string();
    Some((params, body))
}

fn find_close_paren(s: &str) -> Option<usize> {
    s.find(')')
}

fn parse_param_names(s: &str) -> Vec<String> {
    if s.trim().is_empty() {
        return Vec::new();
    }
    s.split(',').map(|p| p.trim().to_string()).collect()
}

/// Parse arguments from an invocation like `(42, 1+2)` starting at the `(`.
/// Returns the list of argument strings and the byte index past the closing `)`.
pub fn parse_invocation_args(text: &str) -> Option<(Vec<String>, usize)> {
    let bytes = text.as_bytes();
    if bytes.is_empty() || bytes[0] != b'(' {
        return None;
    }
    let mut args = Vec::new();
    let mut depth: u32 = 1;
    let mut current = String::new();
    let mut i = 1;

    while i < bytes.len() && depth > 0 {
        let ch = bytes[i];
        match ch {
            b'(' => {
                depth += 1;
                current.push('(');
            }
            b')' => {
                depth -= 1;
                if depth == 0 {
                    args.push(current.trim().to_string());
                } else {
                    current.push(')');
                }
            }
            b',' if depth == 1 => {
                args.push(current.trim().to_string());
                current = String::new();
            }
            b'"' => {
                current.push('"');
                i += 1;
                i = copy_string_into(&mut current, bytes, i);
                continue;
            }
            _ => current.push(ch as char),
        }
        i += 1;
    }

    if depth != 0 {
        return None;
    }
    Some((args, i))
}

/// Copy a string literal (after opening `"`) into `out`, return index after closing `"`.
fn copy_string_into(out: &mut String, bytes: &[u8], start: usize) -> usize {
    let mut i = start;
    while i < bytes.len() {
        let ch = bytes[i];
        out.push(ch as char);
        i += 1;
        if ch == b'"' {
            return i;
        }
        if ch == b'\\' && i < bytes.len() {
            out.push(bytes[i] as char);
            i += 1;
        }
    }
    i
}

/// Substitute parameter names in the macro body with argument values.
pub fn substitute_params(body: &str, params: &[String], args: &[String]) -> String {
    let map: HashMap<&str, &str> = params
        .iter()
        .zip(args.iter())
        .map(|(p, a)| (p.as_str(), a.as_str()))
        .collect();
    token_substitute(body, &map)
}

/// Token-aware substitution: replace identifiers matching keys in `map`.
fn token_substitute(body: &str, map: &HashMap<&str, &str>) -> String {
    let bytes = body.as_bytes();
    let mut result = String::with_capacity(body.len());
    let mut i = 0;

    while i < bytes.len() {
        if bytes[i] == b'"' {
            result.push('"');
            i += 1;
            i = copy_string_into(&mut result, bytes, i);
        } else if is_ident_start(bytes[i]) {
            let start = i;
            while i < bytes.len() && is_ident_char(bytes[i]) {
                i += 1;
            }
            let word = &body[start..i];
            if let Some(replacement) = map.get(word) {
                result.push_str(replacement);
            } else {
                result.push_str(word);
            }
        } else {
            result.push(bytes[i] as char);
            i += 1;
        }
    }
    result
}

fn is_ident_start(b: u8) -> bool {
    b.is_ascii_alphabetic() || b == b'_'
}

fn is_ident_char(b: u8) -> bool {
    b.is_ascii_alphanumeric() || b == b'_'
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_simple_params() {
        let (params, body) = parse_params_and_body("a, b) ((a)+(b))").unwrap();
        assert_eq!(params, vec!["a", "b"]);
        assert_eq!(body, "((a)+(b))");
    }

    #[test]
    fn parse_no_params() {
        let (params, body) = parse_params_and_body(") 1").unwrap();
        assert!(params.is_empty());
        assert_eq!(body, "1");
    }

    #[test]
    fn invocation_simple() {
        let (args, end) = parse_invocation_args("(3, 4)").unwrap();
        assert_eq!(args, vec!["3", "4"]);
        assert_eq!(end, 6);
    }

    #[test]
    fn invocation_nested_parens() {
        let (args, _) = parse_invocation_args("(5, (3+2))").unwrap();
        assert_eq!(args, vec!["5", "(3+2)"]);
    }

    #[test]
    fn invocation_nested_func_call() {
        let (args, _) = parse_invocation_args("(5, func(a,b))").unwrap();
        assert_eq!(args, vec!["5", "func(a,b)"]);
    }

    #[test]
    fn invocation_string_with_comma() {
        let (args, _) = parse_invocation_args("(\"a,b\", 2)").unwrap();
        assert_eq!(args, vec!["\"a,b\"", "2"]);
    }

    #[test]
    fn substitute_simple() {
        let result = substitute_params(
            "((a)+(b))",
            &["a".into(), "b".into()],
            &["3".into(), "4".into()],
        );
        assert_eq!(result, "((3)+(4))");
    }

    #[test]
    fn substitute_skips_strings() {
        let result = substitute_params(
            "assert(x,y,\"x\")",
            &["x".into(), "y".into()],
            &["42".into(), "42".into()],
        );
        assert_eq!(result, "assert(42,42,\"x\")");
    }
}
