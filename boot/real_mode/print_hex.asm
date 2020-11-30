;==========================
; print hex string that dx point position
print_hex:
  pusha         ; Push all register values to the stack

  mov al, [hex_lable] ; Print 0x
  call print
  mov al, [hex_lable+1]
  call print

  mov bx, dx
  mov ax, [bx]  ; Print firsh byte hex
  and ax, 0xf000
  shr ax, 12
  add ax, hex_sym
  mov bx, ax
  mov al, [bx]
  call print

  mov bx, dx
  mov ax, [bx]  ; Print firsh byte hex
  and ax, 0x0f00
  shr ax, 8
  add ax, hex_sym
  mov bx, ax
  mov al, [bx]
  call print

  mov bx, dx
  mov ax, [bx]  ; Print second byte hex
  and ax, 0x00f0
  shr ax, 4
  add ax, hex_sym
  mov bx, ax
  mov al, [bx]
  call print

  mov bx, dx
  mov ax, [bx]  ; Print second byte hex
  and ax, 0x000f
  add ax, hex_sym
  mov bx, ax
  mov al, [bx]
  call print

  popa          ; Restore original register values
  ret

hex_lable:
  db '0x'
hex_sym:
  db '0123456789abcdef'


;==========================
;print al 
print:
  pusha         ; Push all register values to the stack
  
  mov ah, 0x0e  ; int=10/ah=0x0e -> BIOS tele-type output
  int 0x10

  popa          ; Restore original register values
  ret
