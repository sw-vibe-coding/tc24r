// tc24r demo29 -- sizeof with array types
//
// New feature:
//   - sizeof(type[N]) and sizeof(type[N][M])
//
// Expected: r0 = 42, UART output: "D29OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

int main() {
    int ok = 1;

    // sizeof(int) = 3 (24-bit)
    if (sizeof(int) != 3) ok = 0;

    // sizeof(char) = 1
    if (sizeof(char) != 1) ok = 0;

    // sizeof(int[4]) = 12 (4 * 3)
    if (sizeof(int[4]) != 12) ok = 0;

    // sizeof(char[8]) = 8 (8 * 1)
    if (sizeof(char[8]) != 8) ok = 0;

    // sizeof(int[3][4]) = 36 (3 * 4 * 3)
    if (sizeof(int[3][4]) != 36) ok = 0;

    // sizeof(int *) = 3 (pointer is word-sized)
    if (sizeof(int *) != 3) ok = 0;

    if (ok) {
        puts("D29OK\n");
        return 42;
    }
    return 0;
}
