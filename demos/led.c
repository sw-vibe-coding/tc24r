void led_set(int val) {
    *(char *)16711680 = val;
}

int main() {
    led_set(0);
    return 0;
}
