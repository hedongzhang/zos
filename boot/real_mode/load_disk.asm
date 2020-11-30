;==========================
; load CX sectors to ES:BX from drive DL sector DH
load_disk:
  mov [disk_lba], dh
  mov [disk_cnt], cx
  mov [disk_addr], bx
  mov [disk_addr+2], es

  mov si, DISK_DAPS  ; address of "disk address packet"
  mov ah, 0x42
  int 0x13
  jc disk_error
  ret

disk_error:
  mov bx, DISK_ERROR_MSG
  call print_string
  jmp $

; variables
DISK_DAPS:           ; Disk Address Packet Structure
  db 0x10
  db 0
disk_cnt:
  dw 0x1             ; read one sector   
disk_addr:
  dw 0x7c00          ; memory buffer destination address (0:7c00)
  dw 0x0             ; in memory page zero
disk_lba:            ; Logical Block Addressing
  dd 0x0             ; put the lba to read in this spot
  dd 0x0             ; more storage bytes only for big lba's ( > 4 bytes )

DISK_ERROR_MSG:
  db "Disk read error!", 0

