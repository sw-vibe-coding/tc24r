#pragma once

// Adapted chibicc test header for tc24r freestanding compiler.
//
// chibicc tests use ASSERT(expected, actual) which calls printf/exit.
// This version uses a global flag checked via return code:
//   r0 = 0 means all assertions passed
//   r0 != 0 means at least one assertion failed

int _test_fail = 0;
int _test_count = 0;

void assert(int expected, int actual, char *code) {
    _test_count++;
    if (expected != actual) {
        _test_fail = 1;
    }
}

#define ASSERT(x, y) assert(x, y, "")
