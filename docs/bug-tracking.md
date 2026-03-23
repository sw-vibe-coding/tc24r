# Bug Tracking

## Fixed

### BUG-001: Nested function-like macro not expanded

**Filed by:** tml24c
**Fixed:** 2026-03-23
**Component:** `tc24r-preprocess` (substitute.rs)

When an object-like `#define` references a function-like macro, the
preprocessor did not expand the inner macro. The compiler treated it
as a function call instead.

```c
#define MAKE_SYMBOL(idx) (((idx) << 2) | 2)
#define NIL_VAL MAKE_SYMBOL(0)
int x = NIL_VAL;  // generated: jal _MAKE_SYMBOL (wrong)
```

**Root cause:** `expand_ident()` pushed simple `#define` replacements
verbatim without re-expansion. The function-macro path already called
`expand_line()` recursively, but the simple define path did not.

**Fix:** Added `expand_line()` re-expansion after simple define
substitution in `substitute.rs:expand_ident()`.

---

### BUG-002: Compiler panic on two-level #define constant expression

**Filed by:** tml24c
**Fixed:** 2026-03-23
**Component:** `tc24r-preprocess` (substitute.rs)

When one object-like macro references another in an expression, the
compiler panics with "no entry found for key" in `tc24r-emit-load-store`.

```c
#define TAG_SYMBOL 2
#define NIL_VAL ((0 << 2) | TAG_SYMBOL)
arr[0] = NIL_VAL;  // panic: TAG_SYMBOL treated as undefined variable
```

**Root cause:** Same as BUG-001 — simple `#define` replacement was not
recursively expanded, so `TAG_SYMBOL` inside `NIL_VAL` reached the
parser as an identifier instead of being expanded to `2`.

**Fix:** Same one-line fix as BUG-001.

---

### BUG-003: Nested array indexing fails to parse

**Filed by:** tml24c
**Fixed:** 2026-03-23
**Component:** `tc24r-parser` (expr.rs)

`&pool[offsets[i]]` caused "expected Semicolon, got LBracket". Even
simple `&pool[0]` failed.

```c
char pool[100];
int offsets[10];
char *get(int i) {
    return &pool[offsets[i]];  // parse error
}
```

**Root cause:** The `&` (address-of) parser only accepted a bare
identifier (`ts.expect_ident()`), not postfix expressions like
`name[index]`. After consuming the identifier, leftover `[...]`
tokens caused the parse error.

**Fix:** After parsing the identifier in `&name`, check for postfix
operators (`[`, `.`, `->`). If present, parse the full postfix chain.
Since `arr[i]` desugars to `*(arr + i)`, applying `&` to that yields
`&*(arr + i)` which simplifies to `arr + i` — the Deref wrapper is
stripped, leaving the address expression.

---

## Open

(none)
