.intel_syntax noprefix

.section .data
val1:   .quad 123          # primeiro número
val2:   .quad 321          # segundo número
result: .quad 0            # espaço para o resultado
size_result: .quad 0       # tamanho da string de resultado
str_result: .space 5       # espaço para a string do resultado (até 4 bytes)

.section .text
.globl _start
_start:
    call sum_values
    call int_to_str
    call strlen
    call print_result
    call exit

# --------------------------------------
# print_result
# Imprime a string armazenada em str_result de tamanho em size_result
# --------------------------------------
print_result:
    mov rax, 1                    # syscall write
    mov rdi, 1                    # fd = stdout
    lea rsi, [rip + str_result]   # aponta para o buffer com a string
    mov rdx, [rip + size_result]  # tamanho da string
    syscall
    ret

# --------------------------------------
# strlen
# Calcula o tamanho da string str_result e guarda o resultado em size_result
# --------------------------------------
strlen:
    lea rsi, [rip + str_result] # rsi = ponteiro para início da string
    xor rcx, rcx                # contador = 0

# jmp
strlen_loop:
    cmp byte ptr [rsi + rcx], 0  # verifica byte nulo
    je strlen_done
    inc rcx
    jmp strlen_loop

# jmp
strlen_done:
    mov [rip + size_result], rcx  # armazena o tamanho da string
    ret


# --------------------------------------
# int_to_str
# Converte o inteiro de result para string em str_result
# --------------------------------------
int_to_str:
    mov rax, [rip + result]  # carrega o número a ser convertido
    mov rbx, 10              # divisor decimal
    mov rcx, 0               # contador dígitos

    cmp rax, 0               # Verifica se o número é zero
    jne int_to_str_loop      # Se não for zero, entra no loop

    # Caso especial se número for zero
    mov byte ptr [str_result], '0'
    mov byte ptr [str_result+1], 0x0A
    mov byte ptr [str_result+2], 0
    ret

# jmp
int_to_str_loop:
    xor rdx, rdx         # limpar rdx para div
    div rbx              # divide rax por 10; quociente em rax, resto em rdx

    add dl, '0'          # converte resto para caractere ASCII
    push rdx             # salva caractere na pilha

    inc rcx              # incrementa contador de dígitos

    cmp rax, 0
    jne int_to_str_loop

    lea rsi, [str_result] # carrega endereço da string de resultado

# jmp
int_to_str_pop:
    cmp rcx, 0             # enquanto rcx > 0
    je int_to_str_pop_done

    pop rax
    mov [rsi], al
    inc rsi
    dec rcx
    jmp int_to_str_pop

# jmp
int_to_str_pop_done:
    mov byte ptr [rsi], 0x0A   # adiciona '\n'
    mov byte ptr [rsi+1], 0    # termina string com zero
    ret

# --------------------------------------
# sum_values
# Soma os valores val1 e val2 e armazena em result
# --------------------------------------
sum_values:
    mov rax, [rip + val1]
    add rax, [rip + val2]       # rax = val1 + val2
    mov [rip + result], rax     # armazena o resultado
    ret

# --------------------------------------
# exit
# Finaliza a execução do programa com exit code 0
# --------------------------------------
exit:
    mov rdi, 0
    mov rax, 60
    syscall
