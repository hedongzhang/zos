;====================================================
; GDT
;====================================================
gdt_start:

gdt_null:     ; the mandatory null descriptor
dd 0x0        ; ’dd’ means define double word (i.e. 4 bytes)
dd 0x0

gdt_code:     ; the code segment descriptor
  ; base=0x0, limit=0xfffff,
  ; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 1001b
  ; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
  ; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b

  dw 0xffff   ; Limit (bits 0-15)
  dw 0x0      ; Base (bits 0-15)
  db 0x0      ; Base (bits 16-23)
  db 10011010b; 1st flags, type flags
  db 11001111b; 2nd flags, Limit (bits 16-19)
  db 0x0      ; Base (bits 24-31)

gdt_data:     ; the data segment descriptor
  ; Same as code segment except for the type flags:
  ; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b

  dw 0xffff   ; Limit (bits 0-15)
  dw 0x0      ; Base (bits 0-15)
  db 0x0      ; Base (bits 16-23)
  db 10010010b; 1st flags, type flags
  db 11001111b; 2nd flags, Limit (bits 16-19)
  db 0x0      ; Base (bits 24-31)

gdt_end:      ; The reason for putting a label at the end of the
              ; GDT is so we can have the assembler calculate
              ; the size of the GDT for the GDT decriptor (below)

; GDT descriptior
gdt_descriptor:
  dw gdt_end - gdt_start - 1  ; Size of our GDT, always less one
                              ; of the true size
  dd gdt_start                ; Start address of our GDT

; Define some handy constants for the GDT segment descriptor offsets, which
; are what segment registers must contain when in protected mode. For example,
; when we set DS = 0x10 in PM, the CPU knows that we mean it to use the
; segment described at offset 0x10 (i.e. 16 bytes) in our GDT, which in our
; case is the DATA segment (0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA)

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start


;====================================================
; Switch to protected mode
;====================================================
[bits 16]
switch_to_pm:

cli           ; We must switch of interrupts until we have 
              ; set-up the protected mode interrupt vector
              ; otherwise interrupts will run riot.

lgdt [gdt_descriptor]   ; Load our global descriptor table, which defines
                        ; the protected mode segments (e.g. for code and data)

mov eax , cr0         ; To make the switch to protected mode, we set
or eax, 0x1           ; the first bit of CR0, a control register
mov cr0 , eax

jmp CODE_SEG:init_pm  ; Make a far jump (i.e. to a new segment) to our  32-bit
                      ; code. This also forces the CPU to flush its cache of
                      ; pre-fetched and real-mode decoded instructions, which can 
                      ; cause problems.

[bits 32]
; Initialise registers and the stack once in PM.
init_pm:

  mov ax, DATA_SEG    ; Now in PM , our old segments are meaningless ,
  mov ds, ax          ; so we point our segment registers to the
  mov ss, ax          ; data selector we defined in our GDT
  mov es, ax 
  mov fs, ax 
  mov gs, ax

  mov ebp, 0x90000    ; Update our stack position so it is right 
                      ; at the top of the free space.
  mov esp , ebp

  call BEGIN_PM       ; Finally, call some well-known label

