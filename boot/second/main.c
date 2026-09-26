#include "types.h"
#include "screen.h"
#include "ELF.h"

void __attribute__((section(".text.start"))) secstage(void) {
    vgaclear();
    print("Hello from second stage!\n");
    print("Kernel in RAM\n");

    Elf_e *kernel = (void *)0x10000;
    if (kernel->e_ident[0] != 0x7F || kernel->e_ident[1] != 0x45 || kernel->e_ident[2] != 0x4C || kernel->e_ident[3] != 0x46) {
        print("Oops, incorrect magic numbers. Try different ELF-file\n");
        while (1) __asm__ volatile("hlt");
    }
    if (kernel->e_type != 2) {
        print("Oops, incorrect ELF-file type. Try different ELF-file\n");
        while (1) __asm__ volatile("hlt");
    }
    if (kernel->e_machine != 0x3E) {
        print("Oops, it looks like your ELF-file isn't for x86_64 arch :(");
        while (1) __asm__ volatile("hlt");
    }
    u64 entry = kernel->e_entry;

    for (u16 i = 0; i < kernel->e_phnum; i++) {
        Elf_p *p = (void *)kernel + kernel->e_phoff + i * kernel->e_phentsize;
        if (p->p_type != 1) continue;
        u8 *src = (void *)kernel + p->p_offset;
        u8 *dst = (void *)p->p_vaddr;
        for (u64 n = 0; n < p->p_memsz; n++) {
            if (n >= p->p_filesz) {
                dst[n] = 0;
            } else {
                dst[n] = src[n];
            }
        }
    }

    ((void (*)(void))entry)();

    while (1) {
        __asm__ volatile("hlt");
    }
}
