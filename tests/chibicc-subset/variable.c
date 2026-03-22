// Subset of chibicc/test/variable.c
// Tests: locals, globals, arrays, assignment
#include "test.h"

int g1;

int main() {
  ASSERT(3, ({ int a; a=3; a; }));
  ASSERT(3, ({ int a=3; a; }));
  ASSERT(8, ({ int a=3; int z=5; a+z; }));

  // Multiple locals
  ASSERT(3, ({ int a=3; a; }));
  ASSERT(5, ({ int x=3; int y=2; x+y; }));

  // Global
  g1 = 42;
  ASSERT(42, g1);

  // Assignment as expression
  ASSERT(7, ({ int i; int j; i=j=7; i; }));

  return _test_fail;
}
