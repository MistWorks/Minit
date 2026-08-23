bits 32
protected:
    mov ax, 0x10
    mov es, ax
    mov ds, ax
    mov ss, ax
    mov esp, 0x90000

    mov eax, 0x100000
    mov ebx, 0x10000
    mov ecx, 32768
    .kernel_load:
        mov edi, [ebx]
        mov [eax], edi
        add eax, 4
        add ebx, 4
        loop .kernel_load

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

    jmp 0x18:long_mode
