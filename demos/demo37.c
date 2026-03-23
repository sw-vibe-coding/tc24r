// tc24r demo37 -- anonymous struct/union members
//
// New feature:
//   - struct { union { int a, b; }; int c; }
//     (unnamed inner union, members accessible directly)
//
// Expected: r0 = 42, UART output: "D37OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

int main() {
    int ok = 1;

    // Anonymous union inside struct: a and b share memory at offset 0
    struct { union { int a, b; }; int c; } s;
    s.a = 10;
    s.c = 20;
    if (s.a + s.c != 30) ok = 0;
    // a and b share same offset (union semantics)
    if (s.b != 10) ok = 0;

    if (ok) {
        puts("D37OK\n");
        return 42;
    }
    return 0;
}
