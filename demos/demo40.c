// tc24r demo40 -- malloc/free (stdlib.h)
//
// New features:
//   - #include <stdlib.h> with bump allocator
//   - malloc(size), free(ptr), calloc(n, size)
//
// Expected: r0 = 42, UART output: "D40OK"

#include <stdio.h>
#include <stdlib.h>

int main() {
    int ok = 1;

    // malloc and use
    int *p = (int *)malloc(3);
    *p = 10;
    if (*p != 10) ok = 0;
    free(p);

    // malloc array
    int *arr = (int *)malloc(12);
    arr[0] = 1;
    arr[1] = 2;
    arr[2] = 3;
    arr[3] = 4;
    if (arr[0] + arr[3] != 5) ok = 0;
    free(arr);

    // calloc (zero-initialized)
    char *buf = (char *)calloc(4, 1);
    if (buf[0] != 0) ok = 0;
    if (buf[3] != 0) ok = 0;
    free(buf);

    if (ok) {
        printf("D40OK\n");
        return 42;
    }
    return 0;
}
