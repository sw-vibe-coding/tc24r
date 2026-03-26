// tc24r demo47 -- ptr[i].member (struct pointer array indexing)
//
// BUG-010 fix: array subscript on struct pointer followed by
// member access (e.g. arr[i].key) now resolves the correct
// struct type instead of defaulting to Int.
//
// Expected: r0 = 160, UART output: "D47OK"

#include <stdio.h>
#include <stdlib.h>

struct pair { int key; int val; };

int main() {
    struct pair *arr;
    arr = (struct pair *)malloc(3 * sizeof(struct pair));

    // Store via ptr[i].member
    arr[0].key = 10;
    arr[0].val = 20;
    arr[1].key = 30;
    arr[1].val = 40;
    arr[2].key = 50;
    arr[2].val = 60;

    // Load via ptr[i].member
    int sum = arr[0].key + arr[1].val + arr[2].key;
    // sum = 10 + 40 + 50 = 100

    // Index via variable
    int i = 2;
    int v = arr[i].val;
    // v = 60

    if (sum + v == 160) {
        printf("D47OK\n");
    }
    return sum + v;
    // return 100 + 60 = 160
}
