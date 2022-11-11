; libtinyio

global _start

section .data
strTest: db "abcdefABCDEF123", 0
nlTest: db 10

section .text

_start:
jmp exit

exit:
    ; Sends Exit (60) syscall
    ; arguments: rdi - exit code
    mov rax, 60
    syscall