bits 32
global thunk_call

%define DAP        0x5000
%define DRIVE      0x5010
%define SAVED_ESP  0x5200
%define SVC        0x5204
%define GDTR_SAVE  0x5300

thunk_call:
    push ebp
    mov  ebp, esp
    push ebx
    push esi
    push edi

    movzx eax, byte [ebp+8]
    mov  [SVC], eax
    mov  [SAVED_ESP], esp

    jmp  0x18:.to16

bits 16
.to16:
    cli
    mov  ax, 0x20
    mov  ds, ax
    mov  es, ax
    mov  ss, ax
    mov  sp, 0x7000

    mov  eax, cr0
    and  al, 0xFE
    mov  cr0, eax
    jmp  0:.real

bits 16
.real:
    cli
    xor  ax, ax
    mov  ds, ax
    mov  es, ax
    mov  ss, ax
    mov  sp, 0x7000
    cld

    cmp  byte [SVC], 1
    je   .disk
    jmp  .err

.disk:
    mov  si, DAP
    mov  ah, 0x42
    mov  dl, [DRIVE]
    sti
    int  0x13
    cli
    cld
    jc   .err

    mov  eax, cr0
    or   al, 1
    mov  cr0, eax
    jmp  0x08:.up32

.err:
    mov  ax, 0xB800
    mov  es, ax
    mov  word [es:0], 0x0C54
    cli
    hlt
    jmp  .err

bits 32
.up32:
    mov  ax, 0x10
    mov  ds, ax
    mov  es, ax
    mov  ss, ax
    mov  esp, [SAVED_ESP]
    pop  edi
    pop  esi
    pop  ebx
    pop  ebp
    ret
