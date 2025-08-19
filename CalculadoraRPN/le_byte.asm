; Simbolos exportados
> SUB_LE_BYTE       ; Subrotina de leitura de um unico byte do disco
> LE_BYTE_ARG       ; Endereco do argumento da subrotina
> LE_BYTE_RESULT    ; Endereco do resultado da subrotina

@ /300
SUB_LE_BYTE     K =0    ; Entrada da subrotina
                JP START
LE_BYTE_RESULT  K /0000 ; Resultado da subrotina
LE_BYTE_ARG     K /0000 ; Por padrao, le do disco zero

; ---------------------------------------------------------
; Constantes e variaveis auxiliares
OP_LEITURA      GD /300     ; Base GD disco 0
DOIS            K /0002
MULTIPLICADOR   K /0100     ; 256 decimal

; Variaveis internas
LE_BYTE_TEMP    K /0000     ; ultima leitura GD
TEMP_ESQ        k /0000     ; Salva apenas o MSB
FLAG_BYTE       K /0002     ; 2=Pegar esquerda | 1=Pegar direita

; ---------------------------------------------------------
START           LD FLAG_BYTE ; Decide qual Byte ler
                SB DOIS
                JZ LEITURA_ESQ ; FLAG_BYTE == 2 
                JP LEITURA_DIR ; FLAG_BYTE == 1        

; ---------------------------------------------------------
LEITURA_ESQ     LD OP_LEITURA
                AD LE_BYTE_ARG
                MM INSTRUCAO

INSTRUCAO       K /0000     ; Monta de qual disco esta vindo
                MM LE_BYTE_TEMP

                LD LE_BYTE_TEMP
                ; Verifica se ja deu FIM
                JZ FIM
                
                ; Devolve esquerda
                DV MULTIPLICADOR
                MM LE_BYTE_RESULT
                
                ; Salva MSB
                ML MULTIPLICADOR
                MM TEMP_ESQ
                
                ; Altera a Flag pra proxima leitura
                LV /0001
                MM FLAG_BYTE
                RS SUB_LE_BYTE

; ---------------------------------------------------------
LEITURA_DIR     LD LE_BYTE_TEMP
                
                ; Devolve direita
                SB TEMP_ESQ
                MM LE_BYTE_RESULT

                ; Altera a Flag pra proxima leitura
                LV /0002
                MM FLAG_BYTE
                RS SUB_LE_BYTE

; ---------------------------------------------------------
FIM             LV /0000
                MM LE_BYTE_RESULT
                RS SUB_LE_BYTE   
