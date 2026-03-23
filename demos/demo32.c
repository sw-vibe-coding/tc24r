// tc24r demo32 -- multi-declarator typedef
//
// New features:
//   - typedef int A, B[4]; (multiple aliases in one typedef)
//   - typedef int; (bare typedef, accepted and ignored)
//
// Expected: r0 = 42, UART output: "D32OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

typedef int MyInt, MyArr[4];
typedef int;

int main() {
    int ok = 1;

    // MyInt is just int
    MyInt x = 5;
    if (x != 5) ok = 0;

    // MyArr is int[4]
    MyArr a;
    a[0] = 10;
    a[1] = 20;
    if (a[0] + a[1] != 30) ok = 0;

    // sizeof matches
    if (sizeof(MyArr) != 12) ok = 0;

    // pointer typedef
    typedef int *IntPtr;
    IntPtr p = &x;
    if (*p != 5) ok = 0;

    if (ok) {
        puts("D32OK\n");
        return 42;
    }
    return 0;
}
