/* ----------------------------------------------------------------
 * Arquivo   : tx_serial_uc.v
 * Projeto   : Experiencia 2 - Transmissao Serial Assincrona
 * ----------------------------------------------------------------
 * Descricao : unidade de controle do circuito da experiencia 2 
 * => implementa superamostragem (tick)
 * => independente da configuracao de transmissao (7O1, 8N2, etc)
 * ----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     09/09/2021  1.0     Edson Midorikawa  versao inicial em VHDL
 *     27/08/2024  4.0     Edson Midorikawa  conversao para Verilog
 *     30/08/2025  4.1     Edson Midorikawa  revisao
 * ----------------------------------------------------------------
 */

module sensor_uc ( 
    input      clock          ,
    input      reset          ,
    input      mensurar       ,
    input      serial_pronto  ,
    input      sensor_pronto  ,
    output reg transmissao    ,
    output reg [1:0] sel      ,
    output reg medicao        ,
    output reg pronto         ,
    output reg incrementa     ,
    output reg [3:0] db_estado
);

    // Estados da UC
    parameter INICIAL      = 4'b0000; 
    parameter PREPARACAO   = 4'b0001; 
    parameter SERVOPOS     = 4'b0010;
    parameter INTERVALO    = 4'b0011;
    parameter MEDIR        = 4'b0100;
    parameter TRANSMITIR   = 4'b0101;
    parameter PROXIMAPOS   = 4'b0110;

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= INICIAL;
        else
            Eatual <= Eprox;
    end


    // Logica de proximo estado
    always @* begin
        case (Eatual)
            INICIAL     : Eprox = PREPARACAO;
            PREPARACAO  : Eprox = SERVOPOS;
            SERVOPOS    : Eprox = INTERVALO;
            INTERVALO   : Eprox = tick_2s ? MEDIR : INTERVALO; 
            MEDIR       : Eprox = medicao_fim ? TRANSMITIR : MEDIR;
            TRANSMITIR  : Eprox = ultimo_char ? PROXIMAPOS : TRANSMITIR;
            PROXIMAPOS  : Eprox = SERVOPOS;   
            default     : Eprox = INICIAL;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
            transmissao = (Eatual == TRANSMITE_0) ||
                  (Eatual == TRANSMITE_1) ||
                  (Eatual == TRANSMITE_2) ||
                  (Eatual == TRANSMITE_3);

        case (Eatual)
            TX_0        : sel = 2'b00;
            TRANSMITE_0 : sel = 2'b00;  
            TX_1       : sel = 2'b01; 
            TRANSMITE_1 : sel = 2'b01;
            TX_2       : sel = 2'b10; 
            TRANSMITE_2 : sel = 2'b10;
            TX_3       : sel = 2'b11; 
            TRANSMITE_3 : sel = 2'b11;  
            default     : sel = 2'b00;
        endcase

        medicao = (Eatual == MEDICAO);

        pronto     = (Eatual == FINAL);
        db_estado  = Eatual;
    end

endmodule
