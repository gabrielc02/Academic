; Simbolos exportados
> SUB_PUSH      ; Subrotina de PUSH na pilha
> SUB_POP       ; Subrotina de POP da pilha
> PUSH_ARG      ; Endereco do argumento de PUSH
> POP_RESULT    ; Endereco do resultado de POP


@ /500
SUB_PUSH    K =0    ; Entrada da subrotina
            JP START1

PUSH_ARG    K /0000 ; Valor pra empilhar
ERRO1       HM ERRO1 ; Overflow

; ---------------------------------------------------------
; Constantes e variaveis auxiliares
DOIS        K /0002
MIN_PILHA   K /0F00 ; Limite inferior da pilha
SAVE_VALUE  MM /000
TEMP_SP     K /0000

; ---------------------------------------------------------
START1      LD STACK_POINTER ; Carrega SP atual
            SB DOIS
            MM TEMP_SP

            ; Verifica overflow
            LD TEMP_SP
            SB MIN_PILHA
            JN ERRO1

            ; Grava valor no topo
            LD TEMP_SP
            AD SAVE_VALUE
            MM VALUE
            LD PUSH_ARG
VALUE       K /0000

            ; Atualiza SP
            LD TEMP_SP
            MM STACK_POINTER

            RS SUB_PUSH


; ---------------------------------------------------------
@ /700
SUB_POP     K =0    ; Entrada da subrotina
            JP START2

POP_RESULT  K /0000
ERRO2       HM ERRO2
MAX_PILHA   K /0FFE ; Posicao inicial da pilha - vazia
SAVE        LD /000

; ---------------------------------------------------------
START2      LD STACK_POINTER  ; Verifica se pilha esta vazia
            SB MAX_PILHA
            JZ ERRO2     ; Se STACK_POINTER == 0x0FFE - Underflow

            ; Carrega valor do topo
            LD STACK_POINTER
            AD SAVE
            MM VAL
 VAL        K /0000
            MM POP_RESULT

            ; Atualiza STACK_POINTER - sobe 2
            LD STACK_POINTER
            AD DOIS
            MM STACK_POINTER

            RS SUB_POP

; ---------------------------------------------------------
; Endereco de memoria onde armazenamos o endereco do topo da pilha.
; Inicialmente, STACK_POINTER aponta para si mesmo (i.e., pilha vazia).
@ /FFE
STACK_POINTER   K STACK_POINTER
