void putc(int c) {
    *(char *)16711936 = c;
}

int main() {
    putc(72);
    putc(105);
    putc(33);
    putc(10);
    return 0;
}
