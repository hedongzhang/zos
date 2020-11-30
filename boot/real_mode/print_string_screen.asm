;==========================
; prints a null-terminated string pointed to by bx
print_string_screen:
  pusha
  mov ax, 0
  mov al, [MSG_LINE_COUNT]
  mov cl, 0xa0
  mul cl

  mov dx, 0xb800                ; Set es to the start of vid mem.
  mov es, dx
  mov si, ax

print_string_screen_loop:
  mov al, [bx]                  ; Store the char at EBX in AL
  mov ah, 0x0f                  ; Store the attributes in AH

  cmp al, 0                     ; if (al == 0), at end of string, so
  je print_string_screen_done       ; jump to done

  mov [es:si], ax               ; Store char and attributes at current
                                ; character cell.
  add bx, 1                     ; Increment EBX to the next char in string.
  add si, 2                     ; Move to next character cell in vid mem.
  jmp print_string_screen_loop  ; loop around to print the next char.

print_string_screen_done:
  mov cl, [MSG_LINE_COUNT]
  add cl, 1
  mov [MSG_LINE_COUNT], cl
  popa
  ret                           ; Return from the function

