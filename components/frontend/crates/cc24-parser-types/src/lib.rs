//! Type parsing utilities for the cc24 parser.

mod type_parse;

pub use type_parse::{is_base_type, is_storage_class, is_type_keyword, parse_type};
