bits 32
global enter_long

enter_long:
    mov  ebx, [esp+4]

    mov edi, 0x1000
    mov dword [edi], 0x2003
    mov dword [edi+4], 0

    mov edi, 0x2000
    mov dword [edi], 0x3003
    mov dword [edi+4], 0

    mov edi, 0x3000
    mov edx, 0x00000083
    mov ecx, 512
.pd_loop:
    mov dword [edi], edx
    mov dword [edi+4], 0
    add edx, 0x200000
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

    jmp 0x28:.longm

bits 64
.longm:
    cli
    mov  ax, 0x10
    mov  ds, ax
    mov  es, ax
    mov  ss, ax
    xor  ax, ax
    mov  fs, ax
    mov  gs, ax
    mov rsp, 0x200000

    jmp rbx
