//! Compound assignment desugaring for the cc24 parser.

mod compound;

pub use compound::{desugar_compound, eat_compound_assign, make_assign};
