//! Shared cor24-run assembly helpers for cc24 test crates.

mod cor24;

pub use cor24::{assemble_with_cor24_run, assert_assembles_cor24, cor24_run_path};
