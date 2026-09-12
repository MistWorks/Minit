#include "types.h"
#define vga ((volatile u16*)0xB8000)

u16 cursor_x = 0;
u16 cursor_y = 0;

void vgaclear(void) {
    for (u32 i = 0; i < 2000; i++) {
        vga[i] = 0x0720;
    }
}

void vgaput(char c) {
    if (c == '\n') {
        cursor_y++;
        cursor_x = 0;
    } else {
        vga[cursor_y * 80 + cursor_x] = (u16)((u8)c | (0x0F << 8));
        cursor_x++;
        if (cursor_x >= 80) {
            cursor_x = 0;
            cursor_y++;
        }
    }
}

void print(const char* c) {
    while (*c) {
        vgaput(*c);
        c++;
    }
}
