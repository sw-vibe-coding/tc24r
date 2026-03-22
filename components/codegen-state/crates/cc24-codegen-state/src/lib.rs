//! Code generator state for the COR24 compiler.
//!
//! This crate owns the `CodegenState` struct that holds all mutable state
//! used during code generation. Handler crates depend on this crate (and
//! `cc24-traits`) so they can manipulate codegen state without depending
//! on the full `cc24-codegen` crate.

mod state;

pub use state::CodegenState;
