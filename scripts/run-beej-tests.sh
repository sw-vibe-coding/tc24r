#!/usr/bin/env bash
# Check which beej-c-guide examples compile with tc24r.
# These are hosted-C examples (use printf, etc.) so we only check compilation.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CC24="$ROOT_DIR/components/cli/target/release/tc24r"
BEEJ_DIR="${HOME}/github/softwarewrighter/beej-c-guide/src"

cargo build --manifest-path "$ROOT_DIR/components/cli/Cargo.toml" --release --quiet

if [ ! -d "$BEEJ_DIR" ]; then
    echo "SKIP: $BEEJ_DIR not found"
    exit 0
fi

pass=0
fail=0
total=0

for f in "$BEEJ_DIR"/*.c; do
    name=$(basename "$f" .c)
    total=$((total + 1))
    if "$CC24" "$f" -o /dev/null 2>/dev/null; then
        echo "  COMPILES: $name"
        pass=$((pass + 1))
    else
        err=$("$CC24" "$f" -o /dev/null 2>&1 | head -1 | sed 's/tc24r: //')
        echo "  FAIL: $name -- $err"
        fail=$((fail + 1))
    fi
done

echo ""
echo "=== beej-c-guide compilation results ==="
echo "  Compile: $pass / $total"
echo "  Fail:    $fail / $total"
