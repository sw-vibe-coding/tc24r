// tc24r demo49 -- (ptr + offset)->member (parenthesized pointer arithmetic)
//
// BUG-012 fix: parenthesized expressions followed by postfix operators
// (->member, .member, [index]) now parse correctly. Previously failed
// with "expected Semicolon, got Arrow".
//
// Expected: r0 = 42, UART output: "D49OK"

#include <stdio.h>
#include <stdlib.h>

struct node { int tag; int val; };

int main() {
    int ok = 1;

    struct node *arr;
    arr = (struct node *)malloc(3 * sizeof(struct node));

    // Direct arrow
    arr->tag = 1;
    arr->val = 10;

    // Parenthesized pointer arithmetic + arrow
    (arr + 1)->tag = 2;
    (arr + 1)->val = 20;
    (arr + 2)->tag = 3;
    (arr + 2)->val = 30;

    // Read via (ptr + offset)->member
    int sum = arr->val + (arr + 1)->val + (arr + 2)->val;
    // sum = 10 + 20 + 30 = 60

    if (sum != 60) ok = 0;
    if ((arr + 1)->tag != 2) ok = 0;
    if ((arr + 2)->tag != 3) ok = 0;

    if (ok) {
        printf("D49OK\n");
        return 42;
    }
    return 0;
}
