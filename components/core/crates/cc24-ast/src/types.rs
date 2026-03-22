//! C type representations.

/// A C type.
#[derive(Debug, Clone, PartialEq)]
pub enum Type {
    Char,
    Int,
    Void,
    Ptr(Box<Type>),
    /// Fixed-size array: element type and count.
    Array(Box<Type>, usize),
}

impl Type {
    /// Size in bytes for this type.
    pub fn size(&self) -> i32 {
        match self {
            Type::Char => 1,
            Type::Int | Type::Void | Type::Ptr(_) => 3,
            Type::Array(elem, count) => elem.size() * (*count as i32),
        }
    }

    /// Element type for arrays and pointers.
    pub fn element_type(&self) -> Option<&Type> {
        match self {
            Type::Ptr(inner) | Type::Array(inner, _) => Some(inner),
            _ => None,
        }
    }
}
