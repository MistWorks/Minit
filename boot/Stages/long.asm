bits 64
long_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov rsp, 0x200000

    

    mov rax, 0x100000
    call rax

    cli
.halt:
    hlt
    jmp .halt
