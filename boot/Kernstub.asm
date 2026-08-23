bits 64
org 0x100000

start:
    mov word [0xB8000], 0x0F4F   ; 'O' белый
    mov word [0xB8002], 0x0F4B   ; 'K' белый

.halt:
    cli
    hlt
    jmp .halt

times 512 - ($ - $$) db 0        ; padding
