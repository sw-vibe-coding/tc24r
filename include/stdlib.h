#pragma once

// tc24r freestanding stdlib.h
// Simple bump allocator for malloc. free is a no-op.
// Heap grows upward from _heap_start in SRAM.

#define NULL 0
#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

// Heap: starts after code/data, grows upward in SRAM.
// COR24 has 1MB SRAM (0x000000-0x0FFFFF).
// Code/data typically uses the low region; heap starts at 0x080000.
int _heap_ptr = 0x080000;

void *malloc(int size) {
    // Word-align allocation (3-byte aligned for COR24)
    if (size < 3) { size = 3; }
    int rem = size % 3;
    if (rem != 0) { size = size + 3 - rem; }

    int ptr = _heap_ptr;
    _heap_ptr = _heap_ptr + size;
    return (void *)ptr;
}

void free(void *ptr) {
    // No-op bump allocator — memory is not reclaimed
}

void *calloc(int count, int size) {
    int total = count * size;
    char *ptr = (char *)malloc(total);
    int i = 0;
    while (i < total) {
        ptr[i] = 0;
        i++;
    }
    return (void *)ptr;
}

void *realloc(void *ptr, int size) {
    // Simple implementation: allocate new block, no copy
    // (correct behavior requires knowing old size)
    return malloc(size);
}

void exit(int status) {
    // On COR24, halt via self-branch
    asm("_exit_halt:");
    asm("bra _exit_halt");
}

int abs(int n) {
    if (n < 0) return 0 - n;
    return n;
}

int atoi(char *s) {
    int n = 0;
    int neg = 0;
    while (*s == 32) { s = s + 1; }
    if (*s == 45) { neg = 1; s = s + 1; }
    else if (*s == 43) { s = s + 1; }
    while (*s >= 48 && *s <= 57) {
        n = n * 10 + (*s - 48);
        s = s + 1;
    }
    if (neg) return 0 - n;
    return n;
}
