// Subset of chibicc/test/arith.c
// Tests: arithmetic, comparison, logical, ternary, compound assignment
#include "test.h"

int main() {
  // Constants
  ASSERT(0, 0);
  ASSERT(42, 42);

  // Basic arithmetic
  ASSERT(21, 5+20-4);
  ASSERT(41, 12 + 34 - 5);
  ASSERT(47, 5+6*7);
  ASSERT(15, 5*(9-6));
  ASSERT(4, (3+5)/2);

  // Unary minus and plus
  ASSERT(10, -10+20);
  ASSERT(10, - -10);
  ASSERT(10, - - +10);

  // Comparison
  ASSERT(0, 0==1);
  ASSERT(1, 42==42);
  ASSERT(1, 0!=1);
  ASSERT(0, 42!=42);
  ASSERT(1, 0<1);
  ASSERT(0, 1<1);
  ASSERT(1, 1>0);
  ASSERT(0, 1>1);
  ASSERT(1, 0<=1);
  ASSERT(1, 1<=1);
  ASSERT(1, 1>=0);
  ASSERT(1, 1>=1);

  // Compound assignment
  ASSERT(7, ({ int i=2; i+=5; i; }));
  ASSERT(7, ({ int i=2; i+=5; }));
  ASSERT(3, ({ int i=5; i-=2; i; }));
  ASSERT(6, ({ int i=3; i*=2; i; }));

  // Logical
  ASSERT(1, 1&&1);
  ASSERT(0, 1&&0);
  ASSERT(0, 0&&1);
  ASSERT(0, 0&&0);
  ASSERT(1, 1||0);
  ASSERT(0, 0||0);

  // Not
  ASSERT(0, !1);
  ASSERT(0, !2);
  ASSERT(1, !0);

  // Ternary
  ASSERT(2, 1?2:3);
  ASSERT(3, 0?2:3);

  // Bitwise
  ASSERT(0, 0&1);
  ASSERT(3, 7&3);
  ASSERT(3, 2|1);

  return _test_fail;
}
