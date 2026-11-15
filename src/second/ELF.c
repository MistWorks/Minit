#include "ELF.h"

static const u8 elf_magic[4] = { 0x7F, 'E', 'L', 'F' };

u32 elf_parse(Elf_e *kernel) {
    print_str("[MINIT]: checking ELF headers...\n");

    if (!iseq((const char *)kernel->e_ident, (const char *)elf_magic, 4)) {
        print_str("[FAIL] Incorrect magic numbers\n");
        print_str("[LOG] Expected: ");
        for (int i = 0; i < 4; i++) {
            print_str("0x");
            print_num(elf_magic[i], 16);
            print_str(" ");
        }
        print_str("\n");

        print_str("[LOG] Got:      ");
        for (int i = 0; i < 4; i++) {
            print_str("0x");
            print_num(kernel->e_ident[i], 16);
            print_str(" ");
        }
        print_str("\n");
        while (1) __asm__ volatile("hlt");
    } else {
        print_str("[ OK ] Correct magic numbers\n");
    }

    if (kernel->e_type != 2) {
        print_str("[FAIL] Incorrect ELF-file type\n");
        print_str("[LOG] Expected: 2\n");
        print_str("[LOG] Got:      "); print_num(kernel->e_type, 10);
        while (1) __asm__ volatile("hlt");
    } else {
        print_str("[ OK ] Correct ELF-file type\n");
    }

    if ((BOOT_BITS == 64 && kernel->e_machine != 0x3E) || (BOOT_BITS == 32 && kernel->e_machine != 0x03)) {
        print_str("[FAIL] Incorrect ELF-file target architecture\n");
        print_str("[LOG] Expected: ");
        switch (BOOT_BITS) {
            case 64: print_str("x86_64\n"); break;
            case 32: print_str("i386\n"); break;
            default: print_str("How tf u got there\n"); break;
        }
        print_str("[LOG] Got:      ");
        switch (kernel->e_machine) {
            case 0x3E: print_str("x86_64"); break;
            case 0x28: print_str("ARM"); break;
            case 0x03: print_str("i386"); break;
            default: print_str("undefined"); break;
        }
        while (1) __asm__ volatile("hlt");
    } else if (BOOT_BITS != 64 && BOOT_BITS != 32) {
        print_str("[WARN] Config corrupted. Invalid BOOT_BITS\n");
        print_str("[LOG] BOOT_BITS = "); print_num(BOOT_BITS, 10);
        while (1) __asm__ volatile("hlt");
    } else {
        print_str("[ OK ] Correct ELF-file target architecture\n");
    }

    print_str("[MINIT]: ELF headers OK\n");
    print_str("[MINIT]: Moving kernel to needed address...\n");

    u32 entry = kernel->e_entry;

    for (u16 i = 0; i < kernel->e_phnum; i++) {
        Elf_p *p = (Elf_p *)((u8 *)kernel + kernel->e_phoff + i * kernel->e_phentsize);

        if (p->p_type != 1) continue;

        u8 *src = (u8 *)kernel + p->p_offset;
        u8 *dst = (u8 *)p->p_paddr;

        copy(dst, src, p->p_filesz);

        if (p->p_memsz > p->p_filesz) {
            fill(dst + p->p_filesz, 0, p->p_memsz - p->p_filesz);
        }
    }

    print_str("[MINIT]: Copied succesfuly");
    return entry;
}
