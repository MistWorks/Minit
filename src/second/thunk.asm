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
    mov  ax, 0x20            ; data16
    mov  ds, ax
    mov  es, ax
    mov  ss, ax
    mov  sp, 0x7000

    mov  eax, cr0
    and  al, 0xFE            ; PE = 0
    mov  cr0, eax
    jmp  0:.real             ; теперь far jmp честно 16-битный, 5 байт

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
    mov  word [es:0], 0x0C54    ; 'T'
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

; --- GDT: локально, в .text, статический указатель, ноль рантайм-записей ---
align 8
gdt_start:
    dq 0
    dq 0x00CF9A000000FFFF       ; 0x08 code32
    dq 0x00CF92000000FFFF       ; 0x10 data32
    dq 0x000F9A000000FFFF       ; 0x18 code16
    dq 0x000F92000000FFFF       ; 0x20 data16
    dq 0x00209A0000000000       ; 0x28 code64
gdt_end:
gdt_ptr:
    dw gdt_end - gdt_start - 1
    dd gdt_start
