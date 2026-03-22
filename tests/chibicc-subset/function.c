// Subset of chibicc/test/function.c
// Tests: function calls, arguments, recursion
#include "test.h"

int ret3() {
  return 3;
}

int add(int x, int y) {
  return x+y;
}

int fib(int x) {
  if (x<=1) { return 1; }
  return fib(x-1) + fib(x-2);
}

int main() {
  ASSERT(3, ret3());
  ASSERT(8, add(3, 5));
  ASSERT(1, fib(0));
  ASSERT(1, fib(1));
  ASSERT(2, fib(2));
  ASSERT(3, fib(3));
  ASSERT(5, fib(4));
  ASSERT(8, fib(5));

  return _test_fail;
}
