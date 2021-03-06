
; Prints the string pointed to by the address stored in
; the head of the stack
; This assumes each address is 2 bytes (i.e. 16-bit
; addressing in real-mode). For protected-mode, we use
; 32-bit addressing, so modify it to use 4 bytes for each
; address.
prints:

	; Store the address of the string
	; in bx (by bypassing the return
	; address at the head of the stack)	
	mov bx, [esp+2]
	
	_prints_loop:
	
		; Check if we have reached the null
		; character
		cmp [bx], byte 0
		je _exit_prints
		
		; If not...
		mov ah, 0x0e ; Signify to BIOS that we are in a scrolling teletype routine
		mov al, [bx]
		int 0x10 ; Perform BIOS system call
		
		; Increment character pointer in string
		inc bx
		jmp _prints_loop
	
	_exit_prints:
	
		; Pop out the return address and push it
		; to where the string address is		
		mov cx, [esp]
		add sp, 4
		mov [esp], cx
		ret


; printi(n = 6543):
;	5 numDigits = log10(n)+1 // numDigits=log10(6543)+1=3+1=4
;	10 x = n % 10 // x = 6543 % 10 = 3
;	20 push(x)
;	30 n = n / 10 // 6543 = 6543 / 10 = 654
;	40 if (n == 0) { goto exit}
;	50 else goto 10
;	60 for (i=0; i<numDigits; i++):
;	70	pop ax
;	80	print(ax)
;	90 return
;	

;printi:

	

; Results in storing the ASCII character given by the user
; in al, and the scancode in ah
get_input_char:
	mov ah, 0
	int 0x16
	ret


