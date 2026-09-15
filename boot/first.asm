bits 16
org 0x7C00

start:
    cli
   
    mov [drive], dl
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7000

    mov ax, 0xB800
    mov es, ax
    mov cx, 2000
    mov di, 0
.clear_screen:
    mov word [es:di], 0x0700
    sub cx, 2
    add di, 2
    jnz .clear_screen

    in al, 0x92
    or al, 2
    out 0x92, al

    mov ah, 0x00
    mov dl, [drive]
    int 0x13
    jc err

    mov si, dap_second
    mov ah, 0x42
    mov dl, [drive]
    int 0x13
    jc err

    mov cx, 6
    mov bx, 0x1000
.chunk:
    push cx
    push bx
    mov si, dap_kernel
    mov [si+6], bx
    mov ah, 0x42
    mov dl, [drive]
    int 0x13
    pop bx
    pop cx
    jc err
    add bx, 0x0200
    add dword [dap_kernel+8], 16
    loop .chunk

    lgdt [gdt_ptr]

    mov eax, cr0
    or al, 1
    mov cr0, eax

    jmp 0x08:protected

err:
    cli    
.hang:
    hlt
    jmp .hang

bits 32
protected:
    cli
    mov ax, 0x10
    mov es, ax
    mov ds, ax
    mov ss, ax
    mov esp, 0x70000

    mov edi, 0x1000
    mov dword [edi], 0x2003
    mov dword [edi+4], 0

    mov edi, 0x2000
    mov dword [edi], 0x3003
    mov dword [edi+4], 0

    mov edi, 0x3000
    mov ebx, 0x00000083
    mov ecx, 512
.pd_loop:
    mov dword [edi], ebx
    mov dword [edi+4], 0
    add ebx, 0x200000
    add edi, 8
    loop .pd_loop

    mov eax, 0x1000
    mov cr3, eax

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    jmp 0x18:longm

bits 64
longm:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov rsp, 0x200000

    mov rax, 0x8000
    jmp rax

.hlt:
    hlt
    jmp .hlt

drive: db 0

dap_second:
    db 0x10
    db 0
    dw 4
    dw 0x0000
    dw 0x0800
    dq 1

dap_kernel:
    db 0x10
    db 0
    dw 16
    dw 0x0000
    dw 0x1000
    dq 4

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

times 0x1BE - ($ - $$) db 0
db 0x80
db 0x00, 0x01, 0x01
db 0x0C
db 0xFF, 0xFF, 0xFF
dd 1
dd 0xFFFFFFFF
times 0x1FE - ($ - $$) db 0
dw 0xAA55
