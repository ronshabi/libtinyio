; libtinyio

global _start

section .data
; for testing purposes
strTest: db "abcdefABCDEF123", 0

; constants
ASCII_NEW_LINE  equ 10
FD_STDOUT     equ 0x1

; syscalls
SYS_READ    equ 0x00
SYS_WRITE   equ 0x01
SYS_EXIT    equ 0x3c


section .text

; ------ for testing ------
_start:
mov rdi, strTest
call print_string

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
    mov rax, rcx
    ret
.increment:
    inc rcx
    jmp .check_null


print_char:
    ; Prints a character to stdout
    ; args: rdi - character code to print
    push rdi                ; push character code to stack
    xor rax, rax
    mov rax, SYS_WRITE 
    mov rsi, rsp            ; buf
    mov rdi, FD_STDOUT      
    mov rdx, 1              ; count
    syscall
    pop rdi                 ; restore prev state
    ret


print_newline:
    ; Prints a newline ('\n') character
    ; args: none
    xor rdi, rdi
    mov rdi, ASCII_NEW_LINE
    call print_char
    ret


print_string:
    ; Prints a null-terminated string
    ; args: rdi - memory location to a c-style string

    xor r10, r10
    mov r10, rdi
    xor r8, r8
.check_for_null:
    cmp byte[r8+r10], 0
    jnz .print
    ret
.print:
    mov rax, SYS_WRITE
    mov rdi, FD_STDOUT
    lea rsi, [r8+r10]
    mov rdx, 1 ; count
    syscall
    inc r8
    jmp .check_for_null


exit:
    ; Sends Exit (0x3c) syscall
    ; args: rdi - exit code
    mov rax, SYS_EXIT
    syscall