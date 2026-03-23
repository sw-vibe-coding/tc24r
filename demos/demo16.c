// tc24r demo16 -- character literals
//
// New feature:
//   - 'a', '\n', '\0', '\\', '\'' character literals
//   - Evaluate to integer values (ASCII code)
//
// Expected: r0 = 42, UART output: "D16OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

int main() {
    int ok = 1;

    if ('A' != 65) { ok = 0; }
    if ('0' != 48) { ok = 0; }
    if ('\n' != 10) { ok = 0; }
    if ('\0' != 0) { ok = 0; }
    if ('\\' != 92) { ok = 0; }
    if ('\'' != 39) { ok = 0; }

    // char literal in expression
    char c = 'Z';
    if (c != 90) { ok = 0; }

    // char literal comparison
    if ('a' > 'z') { ok = 0; }

    if (ok) {
        puts("D16OK\n");
        return 42;
    }
    return 0;
}
