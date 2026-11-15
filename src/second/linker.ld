OUTPUT_FORMAT("elf32-i386")
ENTRY(secstage)

SECTIONS {
    . = 0x8000;

    .text : {
        *(.text.start)
        *(.text .text.*)
    }

    .rodata : { *(.rodata) *(.rodata.*) } :text
    .data   : { *(.data)   *(.data.*)   } :text

    .bss : {
        __bss_start = .;
        *(.bss) *(.bss.*) *(COMMON)
        __bss_end = .;
    }

    /DISCARD/ : { *(.comment) *(.note) *(.note.*) *(.eh_frame) }
}
