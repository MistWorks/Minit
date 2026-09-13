OUTPUT_FORMAT("elf64-x86-64")
ENTRY(secstage)

SECTIONS {
    . = 0x8000;
    
    .text : {
        *(.text.start)
        *(.text)
    }
    .rodata : { *(.rodata) *(.rodata.*) }
    .data : { *(.data) *(.data.*) }
    
    __bss_start = .;
    .bss : { *(.bss) *(.bss.*) *(COMMON) }
    __bss_end = .;
    
    /DISCARD/ : { *(.comment) *(.note) *(.eh_frame) }
}
