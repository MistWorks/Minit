bits 16
org 0x7C00

%define LBA_COUNT 8

%define DEBUG_VGA 1
%define ENABLE_A20 1

%if DEBUG_VGA
%macro REAL_VGA_MARK 1
    push ax
    push es
    mov  ax, 0xB800
    mov  es, ax
    mov  word [es:0], 0x0F00 + %1
    pop  es
    pop  ax
%endmacro
%else
%macro REAL_VGA_MARK 1
%endmacro
%endif

start:
    cli

    REAL_VGA_MARK '0'

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7000
    cld

    REAL_VGA_MARK '1'

    mov byte [0x5010], dl

    REAL_VGA_MARK '2'

%if ENABLE_A20
    xor ax, ax
    mov es, ax
    mov ax, 0x2401
    int 0x15
    cli
    jc .fastA20try

    call .checkA20
    cmp ax, 1
    je .fastA20try
    jmp .continue

.fastA20try:
    in al, 0x92
    or al, 2
    and al, 0xFE
    out 0x92, al
    
    call .checkA20
    cmp ax, 1
    je err
    jmp .continue

.checkA20:
    push ds
    push es

    xor ax, ax
    mov ds, ax
    mov ax, 0xFFFF
    mov es, ax
    mov si, 0x0500
    mov di, 0x0510

    mov al, [ds:si]
    push ax
    mov al, [es:di]
    push ax

    mov byte [ds:si], 0x00
    mov byte [es:di], 0xFF

    mov al, [ds:si]
    cmp al, 0xFF

    pop ax
    mov [es:di], al
    pop ax
    mov [ds:si], al
    je .off

    pop es
    pop ds
    xor ax, ax
    ret

.off:
    pop es
    pop ds
    mov ax, 1
    ret
%endif

.continue:
    REAL_VGA_MARK '3'
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, dap
    mov ah, 0x42
    mov dl, [0x5010]
    int 0x13
    jc err
    cli

    xor ax, ax
    mov ds, ax
    REAL_VGA_MARK '4'

    lgdt [gdt_ptr]
    cli

    REAL_VGA_MARK '5'

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:protected

err:
    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0x0C58
    hlt

bits 32
protected:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x70000

    jmp 0x8000

.hlt:
    hlt
    jmp .hlt

align 8
dap:
    db 0x10
    db 0
    dw LBA_COUNT
    dw 0x0000
    dw 0x0800
    dq 1

gdt_start:
    dq 0                       ; 0x00 null
    dq 0x00CF9A000000FFFF      ; 0x08 code32
    dq 0x00CF92000000FFFF      ; 0x10 data32
    dq 0x000F9A000000FFFF      ; 0x18 code16
    dq 0x000F92000000FFFF      ; 0x20 data16
    dq 0x00209A0000000000      ; 0x28 code64
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
