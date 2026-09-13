#include "types.h"
#include "screen.h"

void __attribute__((section(".text.start"))) secstage(void) {
    vgaclear();
    print("Minit bootloader was here!");

    while (1) {
        __asm__ volatile("hlt");
    }
}
