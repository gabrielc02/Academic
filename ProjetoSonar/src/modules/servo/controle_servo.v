/* controle servo */

 module controle_servo (
    input wire clock,
    input wire reset,
    input wire [2:0] posicao,
    output controle
);

// Servo Motor
circuito_pwm #(    
    .conf_periodo (1000000), 
    .largura_000   (35000),    
    .largura_001   (45700),  
    .largura_010   (56450),  
    .largura_011   (67150),
    .largura_100   (77850),
    .largura_101   (88550),
    .largura_110   (99300),
    .largura_111   (110000)

    ) Modulo_PWM (
    .clock      ( clock ),
    .reset      ( reset ),
    .largura    ( posicao ),
    .pwm        ( controle )
);

endmodule