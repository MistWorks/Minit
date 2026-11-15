#include "screen.h"
#include "config.h"
#include "disk.h"
#include "ELF.h"

extern __attribute__((noreturn)) void enter_long(u32 entry_address);

void __attribute__((section(".text.start"), noreturn)) secstage(void) {
    extern char __bss_start[], __bss_end[];
    for (char *p = __bss_start; p < __bss_end; ++p) *p = 0;

    clear();
    print_str("[MINIT]: First stage succesful\n");
    print_str("[MINIT]: Trying to get kernel\n");

    u8 boot_drive = *((volatile u8*)0x5010);
    Elf_e* kernel = (Elf_e*)0x10000;
    thunk_disk(boot_drive, KERNEL_SECTORS_COUNT, KERNEL_LBA, kernel);

    print_str("[MINIT]: Kernel copied to 0x"); print_num((usize)kernel, 16);
    print_str("\n[MINIT]: ELF parsing...\n");
    u32 entry = elf_parse(kernel);

    if (BOOT_BITS == 64) {
        enter_long(entry);
    } else if (BOOT_BITS == 32) {
        ((void (*)(void))entry)();
    } else {
        print_str("How tf u got there?");
        while (1) __asm__ volatile("hlt");
    }


    while (1) __asm__ volatile("hlt");
}
