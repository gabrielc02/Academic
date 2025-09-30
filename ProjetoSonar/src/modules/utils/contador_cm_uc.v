module contador_cm_uc (
    input wire clock,
    input wire reset,
    input wire pulso,
    input wire tick,              // vem de MEIO do contador_m
    output reg zera_tick,
    output reg conta_tick,
    output reg zera_bcd,
    output reg conta_bcd,
    output reg pronto,
    output reg [2:0] db_estado
);

    // Estados
    reg [2:0] Eatual, Eprox;

    parameter inicial     = 3'b000;
    parameter preparacao  = 3'b001;
    parameter contando    = 3'b010;
    parameter final       = 3'b011;

    // Memória de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Próximo estado
    always @(*) begin
        case (Eatual)
            inicial     : Eprox = pulso ? preparacao : inicial;
            preparacao  : Eprox = contando;  
            contando    : Eprox = pulso ? contando : final;
            final       : Eprox = inicial;
            default     : Eprox = inicial;
        endcase
    end

    // Saídas (Moore)
    always @(*) begin
        zera_tick  = (Eatual == preparacao);
        zera_bcd   = (Eatual == preparacao); 
        conta_tick = (Eatual == contando); 
        conta_bcd  = (Eatual == contando && tick);
        pronto     = (Eatual == final);

        // Debug
        case (Eatual)
            inicial   : db_estado = 3'b000;
            preparacao: db_estado = 3'b001;
            contando  : db_estado = 3'b010;
            final     : db_estado = 3'b011;
            default   : db_estado = 3'b111;
        endcase
    end

endmodule
