/*circuito_pwm*/
 
module circuito_pwm #(    // valores default
    parameter conf_periodo = 1000000, 
    parameter largura_000   = 35000,    
    parameter largura_001   = 45700,   
    parameter largura_010   = 56450,  
    parameter largura_011   = 67150,  
    parameter largura_100   = 77850,
    parameter largura_101   = 88550,
    parameter largura_110   = 99300,
    parameter largura_111   = 110000
) (
    input        clock,
    input        reset,
    input  [2:0] largura, // 000 -> 111
    output reg   pwm
);

reg [31:0] contagem; // Contador interno (32 bits) para acomodar conf_periodo
reg [31:0] largura_pwm;


reg s_pwm;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        contagem <= 0;
        s_pwm <= 0;
        largura_pwm <= largura_000; // Valor inicial da largura do pulso
    end else begin
        // Saída PWM
        s_pwm <= (contagem < largura_pwm);
        pwm    <= s_pwm;

        // Atualização do contador e da largura do pulso
        if (contagem == conf_periodo - 1) begin
            contagem <= 0;
            case (largura)
                3'b000: largura_pwm <= largura_000;
                3'b001: largura_pwm <= largura_001;
                3'b010: largura_pwm <= largura_010;
                3'b011: largura_pwm <= largura_011;
                3'b100: largura_pwm <= largura_100;
                3'b101: largura_pwm <= largura_101;
                3'b110: largura_pwm <= largura_110;
                3'b111: largura_pwm <= largura_111;
                default: largura_pwm <= largura_000; // Valor padrão
            endcase
        end else begin
            contagem <= contagem + 1;
        end
    end
end
// A saida pwm precisa ser declarado dentro do bloco always, garantindo estabilidade, integridade e sincronizacao
endmodule
