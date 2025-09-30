/* sonar_uc - Moore*/

module sonar_uc (
    input  wire clock,
    input  wire reset,
    input  wire ligar,
    input  wire serial_pronto,
    input  wire sensor_pronto,
    output reg transmissao,
    output reg fim_posicao,
    output reg [2:0] sel_rom,
    output reg [2:0] sel_transmissao,
    output reg [2:0] sel_posicao,
    output reg [3:0] db_estado
);

    // -------------------------------
    // Estados
    // -------------------------------
    parameter INICIAL      = 4'd0;
    parameter PREPARACAO   = 4'd1;
    parameter POS0         = 4'd2;
    parameter POS1         = 4'd3;
    parameter POS2         = 4'd4;
    parameter POS3         = 4'd5;
    parameter POS4         = 4'd6;
    parameter POS5         = 4'd7;
    parameter POS6         = 4'd8;
    parameter POS7         = 4'd9;
    parameter MEDIR        = 4'd10;
    parameter TX0          = 4'd11;
    parameter TX1          = 4'd12;
    parameter TX2          = 4'd13;
    parameter TX3          = 4'd14;
    parameter TX4          = 4'd15;
    parameter TX5          = 4'd16;
    parameter TX6          = 4'd17;
    parameter TX7          = 4'd18;
    parameter PROX_POS     = 4'd19;

    reg [4:0] Eatual, Eprox; 

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
    // Próximo estado (Moore)
    // -------------------------------
    always @* begin
        case (Eatual)
            INICIAL     : Eprox = PREPARACAO;
            PREPARACAO  : Eprox = POS0;
            POS0        : Eprox = MEDIR;
            POS1        : Eprox = MEDIR;
            POS2        : Eprox = MEDIR;
            POS3        : Eprox = MEDIR;
            POS4        : Eprox = MEDIR;
            POS5        : Eprox = MEDIR;
            POS6        : Eprox = MEDIR;
            POS7        : Eprox = MEDIR;

            MEDIR       : Eprox = sensor_pronto ? TX0 : MEDIR;

            TX0         : Eprox = serial_pronto ? TX1 : TX0;
            TX1         : Eprox = serial_pronto ? TX2 : TX1;
            TX2         : Eprox = serial_pronto ? TX3 : TX2;
            TX3         : Eprox = serial_pronto ? TX4 : TX3;
            TX4         : Eprox = serial_pronto ? TX5 : TX4;
            TX5         : Eprox = serial_pronto ? TX6 : TX5;
            TX6         : Eprox = serial_pronto ? TX7 : TX6;
            TX7         : Eprox = serial_pronto ? PROX_POS : TX7;

            PROX_POS: begin
                // lógica vai evolta
                case (sel_posicao)
                    3'd0 : Eprox = POS1;
                    3'd1 : Eprox = POS2;
                    3'd2 : Eprox = POS3;
                    3'd3 : Eprox = POS4;
                    3'd4 : Eprox = POS5;
                    3'd5 : Eprox = POS6;
                    3'd6 : Eprox = POS7;
                    3'd7 : Eprox = POS6; // começa descida
                    default: Eprox = POS0;
                endcase
            end

            default     : Eprox = INICIAL;
        endcase
    end

    // -------------------------------
    // Saídas Moore: só dependem de Eatual
    // -------------------------------
    always @* begin
        // default
        transmissao     = 0;
        sel_posicao     = 0;
        sel_rom         = 0;
        sel_transmissao = 0;

        case (Eatual)
            POS0: sel_posicao = 0;
            POS1: sel_posicao = 1;
            POS2: sel_posicao = 2;
            POS3: sel_posicao = 3;
            POS4: sel_posicao = 4;
            POS5: sel_posicao = 5;
            POS6: sel_posicao = 6;
            POS7: sel_posicao = 7;
            PROX_POS: fim_posicao = 1;

            TX0: begin transmissao = 1; sel_transmissao = 0; end
            TX1: begin transmissao = 1; sel_transmissao = 1; end
            TX2: begin transmissao = 1; sel_transmissao = 2; end
            TX3: begin transmissao = 1; sel_transmissao = 3; end
            TX4: begin transmissao = 1; sel_transmissao = 4; end
            TX5: begin transmissao = 1; sel_transmissao = 5; end
            TX6: begin transmissao = 1; sel_transmissao = 6; end
            TX7: begin transmissao = 1; sel_transmissao = 7; end
        endcase

        // ROM acompanha o servo
        sel_rom = sel_posicao;
    end

    // -------------------------------
    // Debug
    // -------------------------------
    always @(posedge clock) db_estado <= Eatual;

endmodule
