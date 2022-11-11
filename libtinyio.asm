; libtinyio

global _start

section .data
; for testing purposes
strTest: db "abcdefABCDEF123", 0
nlTest: db 10

section .text

; ------ for testing ------
_start:
mov rdi, strTest
call string_length

;; print char
mov rdi, 0x41 ; 'A'
call print_char

mov rdi, 1
jmp exit
; --------/_start----------

string_length:
    ; Returns null-terminated string length
    ; arguments: rdi - string ptr
    mov rax, rdi
    xor rcx, rcx

.check_null:    
    cmp byte[rax+rcx], 0
    jnz .increment
    jmp .return_str_len
.increment:
    inc rcx
    jmp .check_null
.return_str_len:
    mov rax, rcx
    ret

print_char:
    ; Prints a character to stdout
    ; args: rdi - character code to print
    push rdi     ; push character code to stack
    xor rax, rax
    mov rax, 1   ; sys_write
    mov rsi, rsp ; buf
    mov rdi, 1   ; stdout
    mov rdx, 1   ; count
    syscall
    pop rdi      ; restore prev state
    ret

exit:
    ; Sends Exit (60) syscall
    ; arguments: rdi - exit code
    mov rax, 60
    syscall