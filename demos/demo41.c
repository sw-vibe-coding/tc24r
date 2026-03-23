// tc24r demo41 -- getc, atoi, string.h functions
//
// New features:
//   - getchar()/getc() from UART RX
//   - atoi() string to integer
//   - strlen(), strcmp(), strcpy()
//
// Expected: r0 = 42, UART output: "D41OK"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    int ok = 1;

    // atoi
    if (atoi("42") != 42) ok = 0;
    if (atoi("-7") != -7) ok = 0;
    if (atoi("  100") != 100) ok = 0;

    // strlen
    if (strlen("hello") != 5) ok = 0;
    if (strlen("") != 0) ok = 0;

    // strcmp
    if (strcmp("abc", "abc") != 0) ok = 0;
    if (strcmp("abc", "abd") >= 0) ok = 0;
    if (strcmp("abd", "abc") <= 0) ok = 0;

    // strcpy
    char buf[8];
    strcpy(buf, "OK");
    if (strcmp(buf, "OK") != 0) ok = 0;

    if (ok) {
        printf("D41OK\n");
        return 42;
    }
    return 0;
}
