; libtinyio

global _start

section .data
strTest: db "abcdefABCDEF123", 0
nlTest: db 10

section .text

_start:
mov rdi, strTest
call string_length
mov rdi, rax
jmp exit

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

exit:
    ; Sends Exit (60) syscall
    ; arguments: rdi - exit code
    mov rax, 60
    syscall