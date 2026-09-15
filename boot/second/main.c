#include "types.h"
#include "screen.h"

void __attribute__((section(".text.start"))) secstage(void) {
    vgaclear();
    print("Hello from second stage!\n");
    print("Kernel in RAM\n");

    u64 *src = (u64 *)0x10000;
    u64 *dst = (u64 *)0x100000;
    for (u32 i = 0; i < (96*512)/8; i++) {
        dst[i] = src[i];
    }

    print("Kernel copied to 0x100000. Jumping\n");
    __asm__ volatile("jmp 0x100000");

    print("It looks like error ocurred :(");

    while (1) {
        __asm__ volatile("hlt");
    }
}
