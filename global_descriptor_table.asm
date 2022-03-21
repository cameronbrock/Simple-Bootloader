;
;
;	--------------- GLOBAL DESCRIPTOR TABLE ---------------
;
; This allows us to specify the properties for the code and data
; segments
;
; Define a descriptor for each segment of memory (i.e. code, data,
; and stack).
;
; For our memory model we will use flat memory, feel free to edit this
; code in order to change memory models.
;
; The following will describe each descriptor table. First, the code
; segment...
;
;
; Code Segment:
;	- Base (Location of code segment)
;		- 0
;	- Limit (Size of code segment)
;		- Maximum 20-bit value (0xfffff)
;	- Present (1 if segment is used)
;		- 1
;	- Privilege (two-bit val that defines memory protection)
;		- 00
;	- Type (Set to one if segment is Code OR Data segment (So 1)
;		- 1
; 	Flags:
;	- Type flags:
;		- Does this segment contain code?
;			- 1
;		- Conforming? (Can this code be executed by lower-privileged segments?)
;			- 0
;		- Readable? (Can this segment be read? i.e. is it only executable?)
;			- 1
;		- Accessed (Set to 1 when CPU uses the segment)
;			- 0
;		- Granularity (When set to 1, limit is multiplied by 0x1000 and we can use 4gb of memory)
;			- 1
;		- Will this segment use 32-bit memory?
;			- 1
;		- Set the last two bits to zero
;			- 00
;
;
; Now for the data segment descriptor table...
; Data Segment:
;
;	- Present
;		- 1
;	- Privilege
;		- 00
;	- Type
;		- 1
;	Flags:
;	- Type flags:
;		- Does this segment contain code?
;			- 0
;		- Direction (segment grows upwards [0] or downwards [1])
;			- 0
;		- Writeable? (Can this segment be written to?)
;			- 1
;		- Accessed
;			- 0
;
;		- Granularity
;			- 1
;		- Will this segment use 32-bit memory?
;			- 1
;		- Set the last two bits to zero
;			- 00
;
;

; Define the code segment

;
; REMINDER:
;	db -- Define byte (8-bits)
;	dw -- Define word (16-bits)
;	dd -- Define double-word (32-bits)
;	dq -- Define quadword (64-bits)
;	dt -- Define ten byte (80-bits)
;

gdt_start:

; GDT empty descriptor:
dd 0
dd 0

gdt_code_descriptor:
; First 16-bits of limit:
dw 0xffff
; First 24-bits of base:
dw 0 ;16-bits 0
db 0 ;8-bits 0
db 10011010

; Present, privilege, type flags:
db 11001111

; Other flags and last 4-bits of limit
db 0

gdt_data_descriptor:
; First 16-bits of limit:
dw 0xffff
; First 24-bits of base:
dw 0
db 0
db 10010010

; Present, privilege, type flags:
db 11001111
db 0


gdt_end:


; Now, implement the GDT descriptor:

gdt_descriptor:
; First, define the size of the GDT as a 16-bit value:
dw gdt_end - gdt_start - 1
; Next, a pointer to the start of the GDT as a 32-bit value:
dd gdt_start

CODE_SEGMENT_OFFSET equ gdt_code_descriptor - gdt_start
DATA_SEGMENT_OFFSET equ gdt_data_descriptor - gdt_start

; Now, switch to 32-bit protected mode. We can
; do this as follows:

; First, load the gdt_descriptor.
cli
lgdt [gdt_descriptor]

; Change the last bit of cr0 to 1
mov eax, cr0
or cr0, 1
mov cr0, eax


