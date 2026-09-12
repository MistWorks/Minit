#include "types.h"
#include "screen.h"

extern char __bss_start[];
extern char __bss_end[];

static void clear_bss(void) {
    char *p = __bss_start;
    while (p < __bss_end) {
        *p = 0;
        p++;
    }
}

void __attribute__((section(".text.start"))) secstage(void) {
    clear_bss();
    vgaclear();
    print("Cock");
    while (1) {
        __asm__ volatile("hlt");
    }
}
