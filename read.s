.intel_syntax noprefix

.section .data
    buffer: .space 20           # buffer para ler string do teclado
    result:   .quad 0           # número convertido
    size_result: .quad 0
    str_result: .space 20

.section .text
.globl _start
_start:
    call read_input        # lê string do teclado em buffer
    call str_to_int        # converte string para inteiro

    mov rax, [rip + result]  # carrega o valor de result em rax
    add rax, 10              # soma 10 em rax
    mov [rip + result], rax  # armazena rax de volta em result

    call int_to_str

    call strlen
    call print_result

    call exit

# --------------------------------------
# Função read_input
# lê até 19 bytes da entrada (stdin) para buffer
# --------------------------------------
read_input:
    mov rax, 0             # sys_read
    mov rdi, 0             # stdin
    lea rsi, [buffer]
    mov rdx, 19
    syscall
    mov byte ptr [rsi + rax], 0   # adiciona terminador nulo após os bytes lidos
    ret

# --------------------------------------
# Função str_to_int
# Converte a string buffer e o seu tamanho read_bytes para inteiro em result
# --------------------------------------
str_to_int:
    lea rsi, [buffer]      # endereço da string
    xor rax, rax           # acumulador resultado

# jmp
str_to_int_loop:
    mov bl, byte ptr [rsi]  # pega o caractere atual da string
    cmp bl, 0               # compara com terminador zero ('\0')
    je str_to_int_done

    cmp bl, '0'
    jb skip_char            # pula se menor que '0'
    cmp bl, '9'
    ja skip_char            # pula se maior que '9'

    sub bl, '0'             # converte ASCII para valor numérico
    imul rax, rax, 10       # acumulador *= 10 pula digito de rax para receber o próximo
    movzx rbx, bl           # converte bl para rbx com zero extendido
    add rax, rbx            # acumulador += dígito convertido

# jmp
skip_char:
    inc rsi                 # avança para próximo caractere
    jmp str_to_int_loop

# jmp
str_to_int_done:
    mov [rip + result], rax  # armazena o resultado convertido
    ret





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
# exit
# Finaliza a execução do programa com exit code 0
# --------------------------------------
exit:
    mov rdi, 0
    mov rax, 60
    syscall
