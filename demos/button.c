// Read button S2 state (bit 0: 0=pressed, 1=released)
int button_pressed() {
    return *(char *)0xFF0000 & 1;
}

int main() {
    return button_pressed();
}
