#include "screen.h"

u8 x = 0;
u8 y = 0;

void putchar(u8 c) {
    if (c == '\n') {
        x = 0;
        ++y;
    } else {
        vga[y * 80 + x] = (u16)c | ((u16)0x0F << 8);
        ++x;
        if (x >= 80) {
            x = 0;
            ++y;
        }
    }
}

void clear(void) {
    x = 0; y = 0;
    for (u16 i = 0; i < 2000; i++) putchar((u8)0);
    x = 0; y = 0;
}

void print_str(const char* s) {
    while (*s) {
        putchar(*s);
        s++;
    }
}

void print_num(usize num, u8 base) {
    print_str(format(num, base));
}
