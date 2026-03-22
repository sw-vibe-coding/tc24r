// cc24 demo20 -- statement expressions (GCC extension)
//
// New feature:
//   - ({ stmt; stmt; expr; }) evaluates to last expression
//   - Local variables scoped to the block
//   - Enables chibicc ASSERT pattern
//
// Expected: r0 = 42, UART output: "D20OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

int main() {
    int ok = 1;

    // basic statement expression
    int a = ({ 42; });
    if (a != 42) { ok = 0; }

    // with local variable
    int b = ({ int x = 10; x + 5; });
    if (b != 15) { ok = 0; }

    // nested
    int c = ({ int x = ({ 3; }); x * 2; });
    if (c != 6) { ok = 0; }

    // in condition
    if (({ 1; })) {
        // ok
    } else {
        ok = 0;
    }

    if (ok) {
        puts("D20OK\n");
        return 42;
    }
    return 0;
}
