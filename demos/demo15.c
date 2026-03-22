// cc24 demo15 -- ternary operator (? :)
//
// New feature:
//   - Conditional expression: cond ? then_expr : else_expr
//   - Right-associative, nestable
//   - Correct C precedence (between assignment and logical-or)
//
// Expected: r0 = 42, UART output: "D15OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

int abs(int x) {
    return x >= 0 ? x : -x;
}

int max(int a, int b) {
    return a > b ? a : b;
}

int main() {
    int ok = 1;

    // basic true/false
    if ((1 ? 42 : 0) != 42) { ok = 0; }
    if ((0 ? 42 : 99) != 99) { ok = 0; }

    // nested ternary
    int x = 3;
    int r = x > 5 ? 1 : x > 2 ? 2 : 3;
    if (r != 2) { ok = 0; }

    // in function
    if (abs(-7) != 7) { ok = 0; }
    if (abs(3) != 3) { ok = 0; }
    if (max(10, 20) != 20) { ok = 0; }

    if (ok) {
        puts("D15OK\n");
        return 42;
    }
    return 0;
}
