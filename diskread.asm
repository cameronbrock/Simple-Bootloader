
PROGRAM_SPACE equ 0x7e00

read_disk:
	
	mov ah, 0x02
	mov bx, PROGRAM_SPACE
	mov al, 4 ; Number of sectors to load
	mov dl, [BOOT_DISK]
	mov ch, 0x00 ; Cylinder 0
	mov dh, 0x00 ; Register 0
	mov cl, 0x02 ; Sector 2
	
	int 0x13 ; Get BIOS to read
	
	jc disk_read_failed
	
	ret

BOOT_DISK: db 0

disk_read_err_string:
	db 'Disk read has failed.', 0
	
disk_read_failed:
	push disk_read_err_string
	call prints
	
	jmp $
