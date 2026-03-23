# tc24r chibicc Test Plan

## Overview

The chibicc repository at `~/github/softwarewrighter/chibicc/test/` contains
41 test files. These are used IN PLACE (not copied to tc24r repo) to gauge
tc24r completeness. At test time, files are copied to temp, compiled with
tc24r, assembled and run with cor24-run.

## Current Status: 2/41 Compile

Tested 2026-03-22 with adapted test.h (tc24r lacks macro args for `#y`).

## Empirical Classification

### Compiles (2)

- pragma-once
- stdhdr (empty after include resolution fails silently)

### Blocked by: Ternary Operator `? :` (8)

arith, bitfield, complit, control, line, literal, sizeof, unicode

Adding the ternary operator is the single highest-impact feature
for test coverage.

### Blocked by: Struct Member Access `.` (10)

alignof, builtin, constexpr, function, generic, initializer,
struct, typedef, union, usualconv

Requires struct support (the largest remaining feature).

### Blocked by: Statement Expressions `({ })` (6)

const, decl, enum, pointer, typeof, vla

GCC extension. Many tests use this heavily. Could be implemented
or tests could be mechanically adapted to avoid it.

### Blocked by: Missing Keywords (3)

- commonsym -- needs `static`
- compat -- needs `_Noreturn`
- extern -- needs `extern`

### Blocked by: Missing System Headers (6)

atomic, attribute, macro, offsetof, tls, varargs

Out of scope for freestanding compiler. These tests need
`<stdatomic.h>`, `<stdarg.h>`, `<stddef.h>`, etc.

### Blocked by: Integer Range (2)

cast, float -- use literals > 24-bit (8590066177, 2147483648)

Out of scope for 24-bit int target.

### Blocked by: Multi-Declaration (1)

variable -- uses `int x, y;` comma-separated declarations

### Blocked by: Other (3)

- alloca -- `alloca()` function
- asm -- GCC extended asm syntax
- string -- `\a` escape sequence

## Feature Priority by Test Unlock Count

| Feature | Tests Unlocked | Total After |
|---------|---------------|-------------|
| Ternary `? :` | 8 | 10 |
| Char literals `'a'` | 2 (literal, complit) | 12 |
| Multi-decl `int x, y;` | 1 (variable) | 13 |
| `static` keyword | 1 (commonsym) | 14 |
| Statement exprs `({ })` | 6 | 20 |
| Struct support | 10 | 30 |

Adding ternary + char literals + multi-decl would move from 2/41 to
potentially 13/41 (32%) assuming those tests have no other blockers.

## Adapted test.h

chibicc's test.h uses `#y` (stringification) which tc24r does not
support. The adapted version:

```c
#pragma once
#define ASSERT(x, y) assert(x, y, "")
int _test_fail = 0;
void assert(int expected, int actual, char *code) {
    if (expected != actual) { _test_fail = 1; }
}
```

Each test returns `_test_fail` in r0. r0=0 means all assertions passed.

## Running Tests

```bash
# Single test:
scripts/run-chibicc-test.sh arith

# All tests:
scripts/run-chibicc-tests.sh
```

(Scripts to be created in Phase 2 of this plan.)

## Completeness Metric

```
Passing chibicc tests: 2/41 (5%)
```

Updated each time features are added. Target: 50%+ for "usable" status.
