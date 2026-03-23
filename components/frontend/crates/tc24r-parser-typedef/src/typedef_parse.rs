//! Typedef declaration parsing.

use tc24r_ast::{Expr, Stmt, Type};
use tc24r_error::CompileError;
use tc24r_parse_stream::TokenStream;
use tc24r_token::TokenKind;

/// Parse a typedef after the `typedef` keyword has been consumed.
/// Stores the alias in `ts.type_aliases` and returns a no-op statement.
pub fn parse_typedef_decl(ts: &mut TokenStream) -> Result<Stmt, CompileError> {
    let base_ty = tc24r_parser_types::parse_type(ts)?;
    // Bare typedef (e.g. `typedef int;`) — accept and ignore
    if ts.check(&TokenKind::Semicolon) {
        ts.advance();
        return Ok(Stmt::Expr(Expr::IntLit(0)));
    }
    // Parse first declarator
    let ty = parse_pointer_and_array(ts, base_ty.clone())?;
    let alias = ts.expect_ident()?;
    let ty = parse_array_suffix(ts, ty)?;
    ts.type_aliases.insert(alias, ty);
    // Parse additional comma-separated declarators: typedef int A, B[4];
    while ts.eat(TokenKind::Comma) {
        let ty = parse_pointer_and_array(ts, base_ty.clone())?;
        let alias = ts.expect_ident()?;
        let ty = parse_array_suffix(ts, ty)?;
        ts.type_aliases.insert(alias, ty);
    }
    ts.expect(TokenKind::Semicolon)?;
    Ok(Stmt::Expr(Expr::IntLit(0)))
}

/// Consume pointer stars after the base type.
fn parse_pointer_and_array(ts: &mut TokenStream, base: Type) -> Result<Type, CompileError> {
    let mut ty = base;
    while ts.eat(TokenKind::Star) {
        ty = Type::Ptr(Box::new(ty));
    }
    Ok(ty)
}

/// Consume optional `[N]` array suffix.
fn parse_array_suffix(ts: &mut TokenStream, ty: Type) -> Result<Type, CompileError> {
    if !ts.eat(TokenKind::LBracket) {
        return Ok(ty);
    }
    let TokenKind::IntLit(size) = ts.peek().kind else {
        return Err(CompileError::new(
            "expected array size in typedef",
            Some(ts.current_span()),
        ));
    };
    ts.advance();
    ts.expect(TokenKind::RBracket)?;
    Ok(Type::Array(Box::new(ty), size as usize))
}
