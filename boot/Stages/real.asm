bits 16
org 0x7C00

real:
    cli
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7000

    in al, 0x92
    or al, 2
    out 0x92, al

    sti
    mov si, dap
    mov ah, 0x42
    mov dl, 0x80
    int 0x13
    cli

    lgdt [gdt_ptr]

    mov eax, cr0
    or al, 1
    mov cr0, eax

    jmp 0x08:protected

dap:
    db 0x10
    db 0
    dw 127
    dw 0x0000
    dw 0x1000
    dq 1

gdt_start:
    dq 0

gdt_code32:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

gdt_data32:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_code64:
    dw 0x0000
    dw 0x0000
    db 0x00
    db 10011010b
    db 00100000b
    db 0x00
gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start - 1
    dd gdt_start

times 510 - ($ - $$) db 0
dw 0xAA55
