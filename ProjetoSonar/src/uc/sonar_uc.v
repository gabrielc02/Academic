/* sonar_uc - (ida e volta, transmissão sincronizada com serial_pronto) */

module sonar_uc (
    input  wire clock,
    input  wire reset,
    input  wire ligar,
    input  wire tick_2s,
    input  wire serial_pronto,
    input  wire sensor_pronto,
    output reg  limpa_tick_2s,
    output reg  conta_tick_2s,
    output reg  transmissao,
    output reg  fim_posicao,
    output reg  medicao,
    output reg  [2:0] sel_rom,
    output reg  [2:0] sel_transmissao,
    output reg  [2:0] sel_posicao,
    output reg  [3:0] estado
);

    // -------------------------------
    // Estados
    // -------------------------------
    parameter INICIAL   = 4'd0;
    parameter ESPERA    = 4'd1;
    parameter MEDIR     = 4'd2;
    parameter TX        = 4'd3;
    parameter PROX_POS  = 4'd4;

    reg [3:0] Eatual, Eprox;
    reg direcao;         // 0 = subindo, 1 = descendo
    reg [2:0] tx_count;  // Contador de bytes transmitidos (0–7)

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
            ESPERA    : Eprox = MEDIR;
            MEDIR     : Eprox = sensor_pronto ? TX : MEDIR;
            TX        : Eprox = (tx_count == 3'd7 && serial_pronto) ? PROX_POS : TX;
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
        medicao       = (Eatual == MEDIR);
        transmissao   = (Eatual == TX);
        fim_posicao   = (Eatual == PROX_POS);
    end

    // -------------------------------
    // Controle de posição (ida e volta)
    // -------------------------------
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            sel_posicao <= 3'd0;
            direcao     <= 1'b0;
        end else if (Eatual == PROX_POS) begin
            if (!direcao) begin
                // Subindo
                if (sel_posicao == 3'd7)
                    direcao <= 1'b1;
                else
                    sel_posicao <= sel_posicao + 1;
            end else begin
                // Descendo
                if (sel_posicao == 3'd0)
                    direcao <= 1'b0;
                else
                    sel_posicao <= sel_posicao - 1;
            end
        end
    end

    // -------------------------------
    // Controle de transmissão (sincronizado com serial_pronto)
    // -------------------------------
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            tx_count        <= 3'd0;
            sel_transmissao <= 3'd0;
        end else if (Eatual == TX) begin
            if (serial_pronto) begin
                if (tx_count < 3'd7) begin
                    tx_count        <= tx_count + 1;
                    sel_transmissao <= tx_count + 1;
                end else begin
                    // Último byte transmitido
                    tx_count        <= 3'd0;
                    sel_transmissao <= 3'd0;
                end
            end
        end else begin
            tx_count        <= 3'd0;
            sel_transmissao <= 3'd0;
        end
    end

    // -------------------------------
    // Debug (estado atual)
    // -------------------------------
    always @(posedge clock) estado <= Eatual;

endmodule
