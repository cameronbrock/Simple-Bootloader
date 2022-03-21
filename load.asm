
[org 0x7c00]

mov [BOOT_DISK], dl

mov bp, 0x7c00
mov sp, bp

call read_disk

jmp PROGRAM_SPACE

%include "io.asm"
%include "diskread.asm"

times 510-($-$$) db 0
dw 0xaa55 ; How system knows this is a bootloader



