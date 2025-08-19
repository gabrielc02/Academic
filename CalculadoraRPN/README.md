# PCS3616 - 2025 - Calculadora RPN

## Objetivo

Neste projeto, será implementado uma calculadora em
**Notação Polonesa Reversa (Reverse Polish Notation - RPN)**.
A partir de um programa para a MVN que implementa que lê 
expressões aritméticas em RPN do Disco 0 e armazena seu 
resultado em um endereço específico da memória. Tudo através
das seguintes funções:

### 1. `le_byte.asm` – Lê um byte do disco e retorna o valor.
### 2. `pilha.asm` – Implementa a pilha usada para avaliação RPN.
### 3. `rpn.asm` – Avalia expressões aritméticas usando a pilha.