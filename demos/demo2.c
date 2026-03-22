// cc24 demo2 -- Phase 4 features: char, pointers, casts, MMIO
//
// New features since demo.c:
//   - C comments (// and /* */)
//   - char type
//   - pointer declarations (int *, char *)
//   - address-of (&x)
//   - pointer dereference (*p) read and write
//   - cast expressions ((char *)addr)
//   - MMIO: LED write, UART TX output
//
// Expected result after execution:
//   r0 = 42
//   LED = 0xAA (alternating pattern)
//   UART output: "OK"

/* MMIO addresses (COR24 memory map) */
int LED_ADDR = 16711680;   /* 0xFF0000 */
int UART_ADDR = 16711936;  /* 0xFF0100 */

void led_write(int val) {
    *(char *)16711680 = val;
}

void uart_putc(int c) {
    *(char *)16711936 = c;
}

int main() {
    int ok = 1;

    // --- char type ---
    char a = 65;
    char b = 66;
    if (a != 65) { ok = 0; }
    if (b != 66) { ok = 0; }

    // --- pointer to int: read via dereference ---
    int x = 123;
    int *px = &x;
    if (*px != 123) { ok = 0; }

    // --- pointer write: modify through pointer ---
    *px = 456;
    if (x != 456) { ok = 0; }

    // --- pointer to char ---
    char ch = 77;
    char *pc = &ch;
    if (*pc != 77) { ok = 0; }

    // --- cast: int used as address ---
    /* Write alternating bit pattern to LED register */
    led_write(170);  /* 0xAA = 10101010 */

    // --- UART output ---
    if (ok == 1) {
        uart_putc(79);   /* 'O' */
        uart_putc(75);   /* 'K' */
        uart_putc(10);   /* newline */
    }

    if (ok == 1) {
        return 42;
    }
    return 0;
}
