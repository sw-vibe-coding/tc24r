# Known Issues

## reg-rs Cross-Platform Output Differences

**Status:** Resolved (2026-03-22)

The demo run scripts previously used `sed` with GNU extensions (`\s`) that
behaved differently on macOS (BSD sed) vs Linux (GNU sed). This caused reg-rs
`.out` baselines captured on one platform to fail on the other.

### Fix Applied

All `sed` usage in `demos/run-demo*.sh` has been replaced with portable
`awk` alternatives:

- R0 extraction: `awk -F'[()]' '{print $2}' | tr -d ' '`
- Halted status: `awk '{print $2}'`
- LED state: `awk '{print $3}'`
- UART output: `awk -F'UART TX log:' '{print $2}' | tr -d ' "'`
- IntEn value: `awk '{print $3}'`

### Remaining Consideration

The `.out` baselines contain absolute paths (e.g., include directories).
When switching between machines, `reg-rs rebase` must be run to update
baselines with the local paths. reg-rs supports a `preprocess` field in
`.rgt` files that could be used to normalize paths before comparison.
