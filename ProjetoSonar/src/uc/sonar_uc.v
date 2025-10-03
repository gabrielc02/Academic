/* sonar_uc - Moore (ida e volta) */

module sonar_uc (
    input  wire clock,
    input  wire reset,
    input  wire ligar,
    input  wire tick_2s,
    input  wire serial_pronto,
    input  wire sensor_pronto,
    output reg limpa_tick_2s,
    output reg conta_tick_2s,
    output reg transmissao,
    output reg fim_posicao,
    output reg [2:0] sel_rom,
    output reg [2:0] sel_transmissao,
    output reg [2:0] sel_posicao,
    output reg [4:0] db_estado
);

    // -------------------------------
    // Estados
    // -------------------------------
    parameter INICIAL   = 5'd0;
    parameter ESPERA    = 5'd1;
    parameter PROX_POS  = 5'd2;

    reg [4:0] Eatual, Eprox; 
    reg direcao; // 0 = subindo, 1 = descendo

    // -------------------------------
    // Memória de estado
    // -------------------------------
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= INICIAL;
        else if (!ligar)
            Eatual <= INICIAL;
        else
            Eatual <= Eprox;
    end

    // -------------------------------
    // Próximo estado
    // -------------------------------
    always @* begin
        case (Eatual)
            INICIAL   : Eprox = ESPERA;
            ESPERA    : Eprox = tick_2s ? PROX_POS : ESPERA;
            PROX_POS  : Eprox = ESPERA;
            default   : Eprox = INICIAL;
        endcase
    end

    // -------------------------------
    // Saídas (Moore)
    // -------------------------------
    always @* begin
        conta_tick_2s = (Eatual == ESPERA);
        limpa_tick_2s = (Eatual == PROX_POS);
    end

    // -------------------------------
    // Controle de posição do servo (ida e volta)
    // -------------------------------
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            sel_posicao <= 0;
            direcao <= 0; // inicia subindo
        end else if (Eatual == PROX_POS) begin
            if (!direcao) begin
                // subindo
                if (sel_posicao == 3'd7)
                    direcao <= 1; // muda direção
                else
                    sel_posicao <= sel_posicao + 1;
            end else begin
                // descendo
                if (sel_posicao == 3'd0)
                    direcao <= 0; // muda direção para subir
                else
                    sel_posicao <= sel_posicao - 1;
            end
        end
    end

    // -------------------------------
    // Debug
    // -------------------------------
    always @(posedge clock) db_estado <= Eatual;

endmodule
