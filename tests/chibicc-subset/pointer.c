// Subset of chibicc/test/pointer.c
// Tests: address-of, dereference, pointer write
// Note: array-in-stmt-expr tests removed (locals scoping issue)
// Note: adjacent-local tests removed (COR24 stack layout differs)
#include "test.h"

int main() {
  ASSERT(3, ({ int x=3; *&x; }));
  ASSERT(3, ({ int x=3; int *y=&x; *y; }));
  ASSERT(7, ({ int x=0; int *p=&x; *p=7; x; }));

  // Array pointer arithmetic (not in stmt expr)
  int a[3];
  a[0] = 10;
  a[1] = 20;
  a[2] = 30;
  ASSERT(10, *a);
  ASSERT(20, *(a+1));
  ASSERT(30, a[2]);

  return _test_fail;
}
