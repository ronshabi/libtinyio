; libtinyio

global _start

section .data
; for testing purposes
strTest: db "abcdefABCDEF123", 0
strNone: db 0
charTest: db "a"

; constants
ASCII_NEW_LINE      equ 0x0a
FD_STDIN            equ 0x00
FD_STDOUT           equ 0x01

; syscalls
SYS_READ            equ 0x00
SYS_WRITE           equ 0x01
SYS_EXIT            equ 0x3c

section .bss
buf: resb 1

section .text

; ------ for testing ------
_start:
;mov rdi, strTest
;call print_string
call read_char
mov rdi, rax
call print_char
call print_newline
mov rdi, 0
jmp exit
; --------/_start----------

string_length:
    ; Returns null-terminated string length
    ; arguments: rdi - string ptr
    push rcx
    mov rax, rdi
    xor rcx, rcx
.check_null:    
    cmp byte[rax+rcx], 0
    jnz .increment
    mov rax, rcx
    pop rcx
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
    call string_length
    mov rdx, rax ; count
    mov rsi, rdi
    mov rax, SYS_WRITE
    mov rdi, FD_STDOUT
    syscall
    ret

read_char:
    ; Reads one char from stdout into
    xor rax, rax
    mov rax, SYS_READ
    mov rdi, FD_STDIN
    mov rsi, buf
    mov rdx, 1
    syscall
    ; on EOI -> return 0
    cmp rax, -1
    jz .return_zero
    mov rax, [buf]
    ret
.return_zero:
    mov rax, 0
    ret

exit:
    ; Sends Exit (0x3c) syscall
    ; args: rdi - exit code
    mov rax, SYS_EXIT
    syscall