
[org 0x7e00]

push _success_string
call prints

jmp $

%include "io.asm"

_success_string: db 'Successfully loaded sectors.', 0

times 2048-($-$$) db 0
