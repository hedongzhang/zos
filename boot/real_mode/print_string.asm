;==========================
; print bx point char untill find 0
print_string:
  pusha         ; Push all register values to the stack

start:
  mov al, [bx]
  cmp al, 0
  je end

  mov ah, 0x0e  ; int=10/ah=0x0e -> BIOS tele-type output
  int 0x10

  add bx, 1
  jmp start

end:
  popa          ; Restore original register values
  ret
