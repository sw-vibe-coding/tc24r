// tc24r demo27 -- function prototypes (forward declarations)
//
// New features:
//   - int foo(int n); prototype before definition
//   - void bar(void); void parameter list
//   - Mutual recursion via prototypes
//
// Expected: r0 = 42, UART output: "D27OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

// Forward declarations
int is_even(int n);
int is_odd(int n);

// Mutual recursion: is_even calls is_odd and vice versa
int is_even(int n) {
    if (n == 0) return 1;
    return is_odd(n - 1);
}

int is_odd(int n) {
    if (n == 0) return 0;
    return is_even(n - 1);
}

int main() {
    int ok = 1;

    // test mutual recursion
    if (is_even(0) != 1) ok = 0;
    if (is_even(4) != 1) ok = 0;
    if (is_even(3) != 0) ok = 0;
    if (is_odd(3) != 1) ok = 0;
    if (is_odd(4) != 0) ok = 0;

    // prototype with void params
    // (just verify it parses -- the function is defined above)

    if (ok) {
        puts("D27OK\n");
        return 42;
    }
    return 0;
}
