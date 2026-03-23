// tc24r demo24 -- typedef
//
// New features:
//   - typedef int MyInt; -- type alias
//   - typedef int *IntPtr; -- pointer alias
//   - Resolved at parse time, no codegen changes
//
// Expected: r0 = 42, UART output: "D24OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

typedef int MyInt;
typedef int *IntPtr;
typedef char Byte;

int main() {
    int ok = 1;

    MyInt x = 42;
    if (x != 42) ok = 0;

    IntPtr p = &x;
    if (*p != 42) ok = 0;

    Byte b = 65;
    if (b != 65) ok = 0;

    // typedef in function scope
    typedef int Counter;
    Counter i = 0;
    for (; i < 5; i++) {}
    if (i != 5) ok = 0;

    if (ok) {
        puts("D24OK\n");
        return 42;
    }
    return 0;
}
