; Simbolos exportados
> SUB_RPN       ; Subrotina de calculo da expressao RPN
> RPN_RESULT    ; Endereco do resultado de RPN

; Simbolos importados
< SUB_PUSH
< SUB_POP
< SUB_LE_BYTE
< PUSH_ARG
< POP_RESULT
< LE_BYTE_ARG
< LE_BYTE_RESULT

@ /900
SUB_RPN     K =0
            JP START

RPN_RESULT  K /0000
ERRO        HM ERRO

; ----------------------------------------------------
;Constantes & Variaveis internas
ZERO        K /0000
DEZ         K /000A
DOIS        K /0002

ASCII_0     K /0030
ASCII_ESP   K /0020
ASCII_QUEB  K /000A
ACUM        K /0000
VAL_EMP     K /0000
DIG_TMP     K /0000
FEZ_PUSH    K /0000
OP_TMP      K /0000
VAL1        K /0000
VAL2        K /0000

PRINT       K /0000

; ----------------------------------------------------
START       LV ZERO

LOOP        SC SUB_LE_BYTE
            LD LE_BYTE_RESULT
            MM OP_TMP ; Salva o 1 Byte lido

            ; Verifica fim da expressao - 0x00 ou 0x0A
            LD OP_TMP
            JZ FIM
            SB ASCII_QUEB
            JZ FIM

            ; Verifica se eh numero
            LD OP_TMP
            SB ASCII_0

            JN VER_OP ; Se deu negativo = nao eh numero
            SB DEZ ; Tira 10 - Se negativo eh numero
            JN MONTAR_NUM ; Se deu negativo = eh numero 

; ----------------------------------------------------
; Monta numero
MONTAR_NUM  LD OP_TMP
            SB ASCII_0 ; faz a conversao
            MM DIG_TMP
            LD ACUM ; Multiplica numero parcial por 10
            ML DEZ
            AD DIG_TMP ; Soma novo digito
            MM ACUM
            MM VAL_EMP
            JP LOOP  ; Continua lendo o proximo byte

; ----------------------------------------------------
; Verifica se eh espaco ou operador
VER_OP      LD OP_TMP
            SB ASCII_ESP
            JZ PUSH_NUM ; Se for espaco = hora de empilhar NUM_ACUM

            ; Operadores
            LD OP_TMP
            SB /02B
            JZ SOMA
            LD OP_TMP
            SB /02D
            JZ SUB
            LD OP_TMP
            SB /02A
            JZ MULT
            LD OP_TMP
            SB /02F
            JZ DIV
            ;JP LOOP ; Se nao for nada ignora e segue lendo

; ----------------------------------------------------
; Push numero montado
PUSH_NUM    LV /0001
            MM FEZ_PUSH
            LD VAL_EMP
            MM PUSH_ARG
            SC SUB_PUSH
            LV /0000
            MM ACUM ; Zera numero montado pra proximo
            JP LOOP

; ----------------------------------------------------
; Soma
SOMA        SC SUB_POP
            LD POP_RESULT
            MM VAL2

            SC SUB_POP
            LD POP_RESULT
            MM VAL1
            MM PRINT

            LD VAL1
            AD VAL2
            JP PUSH_RES

; ----------------------------------------------------
; Subtracao
SUB         SC SUB_POP
            LD POP_RESULT
            MM VAL2

            SC SUB_POP
            LD POP_RESULT
            MM VAL1

            LD VAL1
            SB VAL2
            JP PUSH_RES

; ----------------------------------------------------
; Multiplicacao
MULT        SC SUB_POP
            LD POP_RESULT
            MM VAL2

            SC SUB_POP
            LD POP_RESULT
            MM VAL1

            LD VAL1
            ML VAL2
            JP PUSH_RES

; ----------------------------------------------------
; Divisao
DIV         SC SUB_POP
            LD POP_RESULT
            MM VAL2

            SC SUB_POP
            LD POP_RESULT
            MM VAL1

            LD VAL1
            DV VAL2
            JP PUSH_RES

; ----------------------------------------------------
; Push resultado da operacao
PUSH_RES    MM PUSH_ARG
            SC SUB_PUSH
            JP LOOP

; ----------------------------------------------------
; Fim da leitura - resultado final
FIM         LD FEZ_PUSH
            JZ SINGLE_PUSH
            
FIM_C       SC SUB_POP
            LD POP_RESULT
            ;LD PRINT
            MM RPN_RESULT
            RS SUB_RPN

SINGLE_PUSH LD ACUM ; Se montou numero e nao fez PUSH ainda
            MM PUSH_ARG
            SC SUB_PUSH
            LV ZERO
            MM ACUM
            JP FIM_C
