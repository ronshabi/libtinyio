; libtinyio

global _start

section .data
; for testing purposes
strTest: db "abcdefABCDEF123", 0

; constants
ASCII_NEW_LINE  equ 10
FILE_STDOUT     equ 0x1

; syscalls
SYS_WRITE   equ 0x1
SYS_EXIT    equ 0x3c


section .text

; ------ for testing ------
_start:
mov rdi, strTest
call string_length

;; print char
mov rdi, 0x41 ; 'A'
call print_char
call print_newline

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
    mov rax, SYS_WRITE      ; sys_write
    mov rsi, rsp            ; buf
    mov rdi, FILE_STDOUT    ; stdout
    mov rdx, 1              ; count
    syscall
    pop rdi                 ; restore prev state
    ret

print_newline:
    xor rdi, rdi
    mov rdi, ASCII_NEW_LINE
    call print_char
    ret

exit:
    ; Sends Exit (0x3c) syscall
    ; arguments: rdi - exit code
    mov rax, SYS_EXIT
    syscall