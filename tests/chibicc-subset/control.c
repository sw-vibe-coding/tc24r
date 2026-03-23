// Subset of chibicc/test/control.c
// Tests: if/else, while, do-while, for, break, continue
// Note: tc24r requires braces on if/else/while/for bodies
#include "test.h"

int main() {
  // if/else
  ASSERT(3, ({ int x; if (0) { x=2; } else { x=3; } x; }));
  ASSERT(2, ({ int x; if (1) { x=2; } else { x=3; } x; }));

  // while
  ASSERT(10, ({ int i=0; while(i<10) { i=i+1; } i; }));

  // for with ++
  ASSERT(55, ({ int j=0; for (int i=0; i<=10; i++) { j=j+i; } j; }));

  // for with break
  ASSERT(3, ({ int i=0; for (;i<10;i++) { if (i==3) { break; } } i; }));

  // for with continue
  ASSERT(25, ({ int i=0; int j=0; for (i=0; i<10; i++) { if (i%2==0) { continue; } j+=i; } j; }));

  // do-while
  ASSERT(7, ({ int i=0; int j=0; do { j++; } while (i++ < 6); j; }));

  return _test_fail;
}
