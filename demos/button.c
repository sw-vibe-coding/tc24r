int button_pressed() {
    char *gpio = (char *)16711680;
    return *gpio & 1;
}

int main() {
    return button_pressed();
}
