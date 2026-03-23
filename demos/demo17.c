// tc24r demo17 -- multi-declaration (int x, y, z;)
//
// New feature:
//   - Comma-separated declarations: int x = 1, y = 2, z;
//   - Pointer stars per declarator: int *p, *q;
//
// Expected: r0 = 42, UART output: "D17OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

int main() {
    int ok = 1;

    // basic multi-decl with inits
    int a = 10, b = 20, c = 30;
    if (a + b + c != 60) { ok = 0; }

    // multi-decl without inits
    int x, y;
    x = 3;
    y = 4;
    if (x + y != 7) { ok = 0; }

    // pointer multi-decl
    int val = 99;
    int *p = &val, *q = &val;
    if (*p != 99 || *q != 99) { ok = 0; }

    if (ok) {
        puts("D17OK\n");
        return 42;
    }
    return 0;
}
