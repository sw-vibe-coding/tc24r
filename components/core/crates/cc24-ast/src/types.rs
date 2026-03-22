//! C type representations.

/// A C type.
#[derive(Debug, Clone, PartialEq)]
pub enum Type {
    Char,
    Int,
    Void,
    Ptr(Box<Type>),
}

impl Type {
    /// Size in bytes for this type.
    pub fn size(&self) -> i32 {
        match self {
            Type::Char => 1,
            Type::Int | Type::Void | Type::Ptr(_) => 3,
        }
    }
}
