.intel_syntax noprefix

.section .data
msg:
    .ascii "Hello from function!\n"
len = . - msg

.section .text
.globl _start
_start:
    # Chama função write_msg
    mov rdi, 1          # fd = stdout
    call write_msg

    # Chama função exit com código 0
    mov rdi, 0          # exit code
    call exit

# Função write_msg: escreve a mensagem msg no stdout
write_msg:
    mov rax, 1          # syscall write
    lea rsi, [rip + msg]
    mov rdx, len
    syscall
    ret

# Função exit: termina o programa com código em rdi
exit:
    mov rax, 60         # syscall exit
    syscall

# como funciona o rip + msg
# 4096 pos atual do programa
# 4103 proxima posicao
# 4080 posicao da msg
# rip calcula a posicao da var na memoria
# offset = 4080 - 4103
# resultado rip + offset = 4103 + -23
# [] é ponteiro
# lea joga o endereco do ponteiro em rsi
