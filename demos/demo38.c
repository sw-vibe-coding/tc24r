// tc24r demo38 -- struct brace initializer
//
// New feature:
//   - struct point p = {3, 4}; (brace initializer)
//   - Desugars to declaration + member assignments
//
// Expected: r0 = 42, UART output: "D38OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

struct point { int x; int y; };

int main() {
    int ok = 1;

    // basic brace initializer
    struct point p = {3, 4};
    if (p.x != 3) ok = 0;
    if (p.y != 4) ok = 0;

    // trailing comma allowed
    struct point q = {10, 20,};
    if (q.x + q.y != 30) ok = 0;

    // partial initializer (fewer values than members)
    struct { int a; int b; int c; } s = {1, 2};
    if (s.a != 1) ok = 0;
    if (s.b != 2) ok = 0;

    if (ok) {
        puts("D38OK\n");
        return 42;
    }
    return 0;
}
