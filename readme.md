# Registradores em Assembly x86-64

| Registrador  | Função tradicional (histórica)                                                      | Uso comum hoje                                 |
| ------------ | ----------------------------------------------------------------------------------- | ---------------------------------------------- |
| **RAX**      | "Acumulador" — usado para resultados de operações e chamadas de sistema (`syscall`) | Retorno de funções, cálculos                   |
| **RBX**      | "Base" para acessar dados                                                           | Variável geral                                 |
| **RCX**      | Contador de loops (`loop` instr.)                                                   | Contador, registrador temporário               |
| **RDX**      | Armazenar valores extras ou divisão/multiplicação                                   | Segundo operando em syscalls, cálculos         |
| **RSI**      | Fonte (source) em cópias de memória                                                 | Ponteiro para ler dados                        |
| **RDI**      | Destino (destination) em cópias de memória                                          | Ponteiro para escrever dados                   |
| **RSP**      | Stack pointer (pilha)                                                               | Controla o topo da pilha                       |
| **RBP**      | Base pointer (pilha)                                                                | Usado em funções para acessar variáveis locais |
| **R8 - R15** | Registradores extras                                                                | Uso geral                                      |

# Registradores x86-64 - Funções e Nomes por Tamanho

| Registrador | Nome 64 bits | Nome 32 bits | Nome 16 bits | Nome 8 bits (alto/baixo)              | Função tradicional (histórica)                | Uso comum hoje                         |
| ----------- | ------------ | ------------ | ------------ | ------------------------------------- | --------------------------------------------- | -------------------------------------- |
| RAX         | rax          | eax          | ax           | ah (alto), al (baixo)                 | Acumulador — usado para resultados e syscalls | Retorno de funções, cálculos           |
| RBX         | rbx          | ebx          | bx           | bh (alto), bl (baixo)                 | Base para acessar dados                       | Variável geral                         |
| RCX         | rcx          | ecx          | cx           | ch (alto), cl (baixo)                 | Contador de loops (`loop` instr.)             | Contador, registrador temporário       |
| RDX         | rdx          | edx          | dx           | dh (alto), dl (baixo)                 | Valores extras, divisão/multiplicação         | Segundo operando em syscalls, cálculos |
| RSI         | rsi          | esi          | si           | (não dividido em 8 bits altos/baixos) | Fonte em cópias de memória                    | Ponteiro para ler dados                |
| RDI         | rdi          | edi          | di           | (não dividido em 8 bits altos/baixos) | Destino em cópias de memória                  | Ponteiro para escrever dados           |
| RSP         | rsp          | esp          | sp           | (não dividido em 8 bits altos/baixos) | Stack Pointer (pilha)                         | Controla topo da pilha                 |
| RBP         | rbp          | ebp          | bp           | (não dividido em 8 bits altos/baixos) | Base Pointer (pilha)                          | Acesso a variáveis locais em funções   |
| R8          | r8           | r8d          | r8w          | r8b                                   | Registrador extra                             | Uso geral                              |
| R9          | r9           | r9d          | r9w          | r9b                                   | Registrador extra                             | Uso geral                              |
| R10         | r10          | r10d         | r10w         | r10b                                  | Registrador extra                             | Uso geral                              |
| R11         | r11          | r11d         | r11w         | r11b                                  | Registrador extra                             | Uso geral                              |
| R12         | r12          | r12d         | r12w         | r12b                                  | Registrador extra                             | Uso geral                              |
| R13         | r13          | r13d         | r13w         | r13b                                  | Registrador extra                             | Uso geral                              |
| R14         | r14          | r14d         | r14w         | r14b                                  | Registrador extra                             | Uso geral                              |
| R15         | r15          | r15d         | r15w         | r15b                                  | Registrador extra                             | Uso geral                              |

---

**Notas:**

- Os registradores de 8 bits são divididos em alto (high) e baixo (low) para os registradores tradicionais (como AH/AL).
- Para registradores estendidos (R8 a R15), o nome de 8 bits é simplesmente o mesmo com `b` no final (exemplo: `r8b`).
- Registradores como RSI, RDI, RSP e RBP não possuem versões altas de 8 bits.

---

# Syscalls Linux comuns (x86-64)

| Número | Nome       | Descrição                   | Registradores usados para parâmetros    |
| ------ | ---------- | --------------------------- | --------------------------------------- |
| 0      | read       | Ler de um arquivo/entrada   | rdi = fd, rsi = buffer, rdx = count     |
| 1      | write      | Escrever em arquivo/saída   | rdi = fd, rsi = buffer, rdx = count     |
| 2      | open       | Abrir arquivo               | rdi = pathname, rsi = flags, rdx = mode |
| 3      | close      | Fechar arquivo              | rdi = fd                                |
| 39     | getpid     | Obter PID do processo       | sem parâmetros                          |
| 57     | fork       | Criar processo filho        | sem parâmetros                          |
| 59     | execve     | Executar programa           | rdi = filename, rsi = argv, rdx = envp  |
| 60     | exit       | Terminar processo           | rdi = exit code                         |
| 231    | exit_group | Terminar grupo de processos | rdi = exit code                         |

---

### Como usar syscalls em assembly:

1. Coloque o número da syscall em `rax`.
2. Coloque os parâmetros nos registradores corretos (`rdi`, `rsi`, `rdx`, etc).
3. Execute a instrução `syscall`.

Exemplo:

```asm
mov rax, 1        ; syscall write
mov rdi, 1        ; fd = stdout
mov rsi, buffer   ; endereço do buffer
mov rdx, length   ; tamanho da string
syscall
```
