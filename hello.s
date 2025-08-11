.intel_syntax noprefix

.section .data
msg:
    .ascii "Hello, World!\n"
len = . - msg

.section .text
.globl _start
_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rip + msg]
    mov rdx, len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

# xor rdi, rdi joga zero em rdi pq xor quando iguais resulta em zero