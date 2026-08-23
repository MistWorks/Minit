bits 16
org 0x7C00

%include "boot/Stages/real.asm"
%include "boot/Stages/protected.asm"
%include "boot/Stages/long.asm"
