// tc24r demo35 -- struct array members
//
// New feature:
//   - struct { char a[3]; int b; } (array members in structs)
//   - sizeof(struct tag) correctly accounts for array member sizes
//
// Expected: r0 = 42, UART output: "D35OK"

#define UART_DATA 0xFF0100
#define UART_STATUS 0xFF0101
void putc(int c) { while (*(char *)UART_STATUS & 0x80) {} *(char *)UART_DATA = c; }
void puts(char *s) { while (*s) { putc(*s); s = s + 1; } }

struct record {
    char tag[4];
    int value;
};

struct pair {
    char a[3];
    char b[5];
};

int main() {
    int ok = 1;

    // sizeof with array member: char[4] + int = 4 + 3 = 7
    if (sizeof(struct record) != 7) ok = 0;

    // sizeof with multiple array members: char[3] + char[5] = 8
    if (sizeof(struct pair) != 8) ok = 0;

    // struct with array member - access scalar after array
    struct record r;
    r.value = 42;
    if (r.value != 42) ok = 0;

    if (ok) {
        puts("D35OK\n");
        return 42;
    }
    return 0;
}
