#!/usr/bin/env bash
# Run a single chibicc test through tc24r -> cor24-run pipeline.
#
# Usage: scripts/run-chibicc-test.sh <test-name>
#   e.g.: scripts/run-chibicc-test.sh arith
#
# Reads test from ~/github/softwarewrighter/chibicc/test/<name>.c
# Copies to temp, compiles with tc24r, runs with cor24-run.
# Exit 0 if r0=0 (all assertions pass), exit 1 otherwise.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CC24="$ROOT_DIR/components/cli/target/release/tc24r"
INCLUDE_DIR="$ROOT_DIR/include"
CHIBICC_TEST="${HOME}/github/softwarewrighter/chibicc/test"

if [ $# -lt 1 ]; then
    echo "usage: $0 <test-name>"
    exit 1
fi

NAME="$1"
SRC="$CHIBICC_TEST/$NAME.c"

if [ ! -f "$SRC" ]; then
    echo "SKIP: $SRC not found"
    exit 2
fi

# Always rebuild to avoid stale binary issues (cargo is incremental)
cargo build --manifest-path "$ROOT_DIR/components/cli/Cargo.toml" --release --quiet

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# Adapt the test file for tc24r freestanding:
# - Our include/test.h provides ASSERT as a function-like macro
# - Strip printf/exit/hosted-C helper declarations
# - Strip the common file's helper function implementations
# Note: sed usage here is not portable to macOS BSD sed.
# TODO: Replace with a Rust tc24r-adapt tool (see docs/known-issues.md)
sed \
    -e '/printf/d' \
    -e '/sprintf/d' \
    -e '/exit(/d' \
    -e '/^void assert/d' \
    -e '/^int ext/d' \
    -e '/^int \*ext/d' \
    -e '/^int common_/d' \
    -e '/^static int common_/d' \
    -e '/^int false_fn/d' \
    -e '/^int true_fn/d' \
    -e '/^int char_fn/d' \
    -e '/^int short_fn/d' \
    -e '/^int uchar_fn/d' \
    -e '/^int ushort_fn/d' \
    -e '/^static int static_fn/d' \
    -e '/^int ext_fn/d' \
    -e '/float/d' \
    -e '/double/d' \
    -e '/0b[01]/d' \
    -e '/0[0-7][0-7]/d' \
    -e '/assert.*size/d' \
    "$SRC" > "$TMPDIR/$NAME.c"

# Compile
if ! "$CC24" "$TMPDIR/$NAME.c" -o "$TMPDIR/$NAME.s" -I "$INCLUDE_DIR" -I "$CHIBICC_TEST" 2>"$TMPDIR/tc24r.err"; then
    echo "COMPILE_FAIL: $NAME -- $(head -1 "$TMPDIR/tc24r.err")"
    exit 1
fi

# Assemble and run
OUTPUT=$(cor24-run --run "$TMPDIR/$NAME.s" --dump --speed 0 --time 10 2>&1)
R0=$(echo "$OUTPUT" | grep "r0:" | head -1 | awk -F'[()]' '{print $2}' | tr -d ' ')
HALTED=$(echo "$OUTPUT" | grep "Halted:" | head -1 | awk '{print $2}')

if [ "$HALTED" != "true" ]; then
    echo "TIMEOUT: $NAME (did not halt)"
    exit 1
fi

if [ "$R0" = "0" ]; then
    echo "PASS: $NAME (r0=0)"
    exit 0
else
    echo "FAIL: $NAME (r0=$R0)"
    exit 1
fi
