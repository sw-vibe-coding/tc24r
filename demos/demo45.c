// tc24r demo45 -- Lisp eval: (+ 40 2) => 42
//
// Implements: reader + eval + builtins
//   - read_val: parse S-expressions from a string
//   - eval: numbers self-evaluate, (+ a b), (- a b), (* a b),
//           (quote x), (if c t e), (cons a b), (car x), (cdr x)
//   - Environment as association list
//
// Expected: r0 = 42, UART output: "D45OK"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// --- Value types ---

enum { T_NUM, T_SYM, T_CONS, T_NIL };

struct val {
    int tag;
    int num;
    char *sym;
    struct val *car;
    struct val *cdr;
};

// --- Constructors ---

struct val *make_nil(void);
struct val *make_num(int n);
struct val *make_sym(char *s);
struct val *cons(struct val *a, struct val *d);
struct val *eval(struct val *x, struct val *env);

struct val *NIL;

struct val *make_nil(void) {
    struct val *v = (struct val *)malloc(15);
    v->tag = T_NIL;
    return v;
}

struct val *make_num(int n) {
    struct val *v = (struct val *)malloc(15);
    v->tag = T_NUM;
    v->num = n;
    return v;
}

struct val *make_sym(char *s) {
    struct val *v = (struct val *)malloc(15);
    v->tag = T_SYM;
    v->sym = s;
    return v;
}

struct val *cons(struct val *a, struct val *d) {
    struct val *v = (struct val *)malloc(15);
    v->tag = T_CONS;
    v->car = a;
    v->cdr = d;
    return v;
}

struct val *car(struct val *x) { return x->car; }
struct val *cdr(struct val *x) { return x->cdr; }

int atom(struct val *x) { return x->tag != T_CONS; }
int null(struct val *x) { return x->tag == T_NIL; }

// --- Printer ---

void print_val(struct val *x) {
    if (x->tag == T_NUM) {
        printf("%d", x->num);
    } else if (x->tag == T_SYM) {
        printf("%s", x->sym);
    } else if (x->tag == T_NIL) {
        printf("nil");
    } else if (x->tag == T_CONS) {
        printf("(");
        print_val(x->car);
        struct val *rest = x->cdr;
        while (rest->tag == T_CONS) {
            printf(" ");
            print_val(rest->car);
            rest = rest->cdr;
        }
        if (rest->tag != T_NIL) {
            printf(" . ");
            print_val(rest);
        }
        printf(")");
    }
}

// --- Reader (from string) ---

char *_input;
int _pos;

char peek(void) { return _input[_pos]; }
char next(void) { char c = _input[_pos]; _pos++; return c; }

void skip_ws(void) {
    while (peek() == 32 || peek() == 10 || peek() == 9) {
        next();
    }
}

struct val *read_val(void);

struct val *read_list(void) {
    skip_ws();
    if (peek() == ')') {
        next();
        return NIL;
    }
    struct val *first = read_val();
    struct val *rest = read_list();
    return cons(first, rest);
}

struct val *read_val(void) {
    skip_ws();
    char c = peek();

    // Number
    if ((c >= '0' && c <= '9') || (c == '-' && _input[_pos + 1] >= '0' && _input[_pos + 1] <= '9')) {
        int sign = 1;
        if (c == '-') { sign = -1; next(); }
        int n = 0;
        while (peek() >= '0' && peek() <= '9') {
            n = n * 10 + (next() - '0');
        }
        return make_num(n * sign);
    }

    // List
    if (c == '(') {
        next();
        return read_list();
    }

    // Symbol
    char buf[16];
    int i = 0;
    while (peek() != 0 && peek() != ' ' && peek() != ')' && peek() != '(' && peek() != 10 && i < 15) {
        buf[i] = next();
        i++;
    }
    buf[i] = 0;

    // Copy symbol name to heap
    char *name = (char *)malloc(i + 1);
    strcpy(name, buf);
    return make_sym(name);
}

struct val *read_str(char *s) {
    _input = s;
    _pos = 0;
    return read_val();
}

// --- Environment (association list) ---

struct val *env_lookup(struct val *sym, struct val *env) {
    while (env->tag == T_CONS) {
        struct val *pair = env->car;
        if (strcmp(pair->car->sym, sym->sym) == 0) {
            return pair->cdr;
        }
        env = env->cdr;
    }
    return NIL;
}

struct val *env_bind(struct val *sym, struct val *val, struct val *env) {
    return cons(cons(sym, val), env);
}

// --- Eval ---

struct val *evlis(struct val *args, struct val *env) {
    if (null(args)) return NIL;
    return cons(eval(car(args), env), evlis(cdr(args), env));
}

struct val *eval(struct val *x, struct val *env) {
    // Numbers are self-evaluating
    if (x->tag == T_NUM) return x;
    if (x->tag == T_NIL) return x;

    // Symbol lookup
    if (x->tag == T_SYM) {
        return env_lookup(x, env);
    }

    // List: (fn args...)
    struct val *fn = car(x);
    struct val *args = cdr(x);

    // Special forms
    if (fn->tag == T_SYM) {
        // (quote x)
        if (strcmp(fn->sym, "quote") == 0) {
            return car(args);
        }
        // (if cond then else)
        if (strcmp(fn->sym, "if") == 0) {
            struct val *cond = eval(car(args), env);
            if (!null(cond) && !(cond->tag == T_NUM && cond->num == 0)) {
                return eval(car(cdr(args)), env);
            } else {
                return eval(car(cdr(cdr(args))), env);
            }
        }
    }

    // Evaluate arguments for builtins
    struct val *eargs = evlis(args, env);
    struct val *a = car(eargs);
    struct val *b = car(cdr(eargs));

    if (fn->tag == T_SYM) {
        if (strcmp(fn->sym, "+") == 0) return make_num(a->num + b->num);
        if (strcmp(fn->sym, "-") == 0) return make_num(a->num - b->num);
        if (strcmp(fn->sym, "*") == 0) return make_num(a->num * b->num);
        if (strcmp(fn->sym, "/") == 0) return make_num(a->num / b->num);
        if (strcmp(fn->sym, "cons") == 0) return cons(a, b);
        if (strcmp(fn->sym, "car") == 0) return car(a);
        if (strcmp(fn->sym, "cdr") == 0) return cdr(a);
        if (strcmp(fn->sym, "eq") == 0) {
            if (a->tag == T_NUM && b->tag == T_NUM) {
                return make_num(a->num == b->num);
            }
            return NIL;
        }
        if (strcmp(fn->sym, "atom") == 0) return make_num(atom(a));
    }

    return NIL;
}

// --- Tests ---

int main() {
    int ok = 1;
    NIL = make_nil();

    // (+ 40 2) => 42
    struct val *r1 = eval(read_str("(+ 40 2)"), NIL);
    print_val(r1);
    printf("\n");
    if (r1->num != 42) ok = 0;

    // (- 50 8) => 42
    struct val *r2 = eval(read_str("(- 50 8)"), NIL);
    if (r2->num != 42) ok = 0;

    // (* 6 7) => 42
    struct val *r3 = eval(read_str("(* 6 7)"), NIL);
    if (r3->num != 42) ok = 0;

    // (+ (* 5 8) 2) => 42
    struct val *r4 = eval(read_str("(+ (* 5 8) 2)"), NIL);
    if (r4->num != 42) ok = 0;

    // (quote hello) => hello
    struct val *r5 = eval(read_str("(quote hello)"), NIL);
    print_val(r5);
    printf("\n");
    if (strcmp(r5->sym, "hello") != 0) ok = 0;

    // (if 1 42 0) => 42
    struct val *r6 = eval(read_str("(if 1 42 0)"), NIL);
    if (r6->num != 42) ok = 0;

    // (if 0 99 42) => 42
    struct val *r7 = eval(read_str("(if 0 99 42)"), NIL);
    if (r7->num != 42) ok = 0;

    // (car (cons 42 99)) => 42
    struct val *r8 = eval(read_str("(car (cons 42 99))"), NIL);
    if (r8->num != 42) ok = 0;

    // (+ (+ 10 20) (+ 5 7)) => 42
    struct val *r9 = eval(read_str("(+ (+ 10 20) (+ 5 7))"), NIL);
    print_val(r9);
    printf("\n");
    if (r9->num != 42) ok = 0;

    if (ok) {
        printf("D45OK\n");
        return 42;
    }
    printf("FAIL\n");
    return 0;
}
