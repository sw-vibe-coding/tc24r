// tc24r demo30 -- line continuation
//
// New feature:
//   - backslash-newline joins lines in preprocessor
//
// Expected: r0 = 42, UART output: "D30OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

// Multi-line macro definition
#define LONG_MACRO(x) \
    ((x) + 10)

int main() {
    int ok = 1;

    // line continuation in expression
    int val = 10 \
        + 20 \
        + 12;
    if (val != 42) ok = 0;

    // line continuation in macro
    if (LONG_MACRO(5) != 15) ok = 0;

    if (ok) {
        puts("D30OK\n");
        return 42;
    }
    return 0;
}
