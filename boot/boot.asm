; A boot sector that enters 32-bit protected mode. 
[org 0x7c00]
KERNEL_OFFSET equ 0x9000
KERNEL_SECTORS equ 0x10

mov bp, 0xf000         ; Set the stack.
mov sp, bp

mov bx, MSG_WELCOME
call print_string

mov bx, MSG_LOAD_KERNEL
call print_string
call load_kernel

mov ebx , MSG_PROT_MODE
call print_string
call switch_to_pm

jmp $

%include "./real_mode/print_string.asm" 
%include "./real_mode/load_disk.asm" 
%include "./protected_mode/print_string_screen_pm.asm" 
%include "./protected_mode/switch_to_pm.asm"

; Global variables
MSG_LINE_COUNT   db 0
MSG_WELCOME      db "Welcome HDZhang's BootLoader in 16-bit Real Mode ---> ", 0
MSG_LOAD_KERNEL  db "Load OS Kernel from Disk ---> ", 0
MSG_PROT_MODE    db "Start Landed 32-bit Protected Mode", 0
MSG_KERNEL_START db "Start Kernel", 0
MSG_KERNEL_EXIT  db "Exit Kernel", 0


[bits 16]
load_kernel:
  pusha

  mov dh, 0x1
  mov cx, KERNEL_SECTORS
  mov bx, KERNEL_OFFSET 
  call load_disk

  popa
  ret


[bits 32]
; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:

mov ebx , MSG_KERNEL_START
call print_string_screen_pm

call KERNEL_OFFSET

mov ebx , MSG_KERNEL_EXIT
call print_string_screen_pm

jmp $                     ; Hang.


; Bootsector padding 
times 510-($-$$) db 0 
dw 0xaa55
