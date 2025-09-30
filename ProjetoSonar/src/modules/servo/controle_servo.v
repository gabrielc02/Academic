/* --------------------------------------------------------------------
 * Arquivo   : controle_servo
 * Projeto   : EXP01 - CONTROLE DE UM SERVOMOTOR
 * --------------------------------------------------------------------
 * Descricao : circuito logico desenvolvido para experiencia 01
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao       Autor             Descricao
 *     03/09/2025   1.0          B8      versao atualizada
 * --------------------------------------------------------------------
 */

 module controle_servo (

    input wire clock,
    input wire reset,
    input wire [1:0] posicao,
    output controle,
    output db_controle

);

// Servo Motor
circuito_pwm #(    
    .conf_periodo (1000000), // Período do sinal PWM [1000000 => f=50MHz (20ms)]
    .largura_00   (0),    // Largura do pulso p/ 00 [0 => 0]
    .largura_01   (50000),   // Largura do pulso p/ 01 [50 => 1us]
    .largura_10   (75000),  // Largura do pulso p/ 10 [500 => 10us]
    .largura_11   (100000)   // Largura do pulso p/ 11 [1000 => 20us]
    )Modulo_PWM(
    .clock      ( clock ),
    .reset      ( reset ),
    .largura    ( posicao ),
    .pwm        ( controle ),
    .db_pwm     ( db_controle )
);


endmodule