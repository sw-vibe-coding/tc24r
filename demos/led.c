// Turn on LED D2 (active-low: write 0 to bit 0)
void led_on() {
    *(char *)0xFF0000 = 0;
}

int main() {
    led_on();
    return 0;
}
