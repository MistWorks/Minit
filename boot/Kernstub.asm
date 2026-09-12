bits 64
org 0x100000

start:
    mov [0xB8000], 'K'
    mov [0xB8002], 'e'
    mov [0xB8004], 'r'
    mov [0xB8006], 'n'
    mov [0xB8008], 'e'
    mov [0xB800A], 'l'
    mov [0xB800C], 0
    mov [0xB800E], 'l'
    mov [0xB8010], 'o'
    mov [0xB8012], 'a'
    mov [0xB8014], 'd'
    mov [0xB8016], 'e'
    mov [0xB8018], 'd'
.halt:
    cli
    hlt
    jmp .halt

times 512 - ($ - $$) db 0
