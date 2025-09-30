/* --------------------------------------------------------------------------
 * Arquivo   : mux_nibble.v
 * Descrição : MUX para enviar os nibbles de medida + caractere '#'
 * -------------------------------------------------------------------------- */
module mux_nibble (
    input  wire [1:0] sel,          // contador de seleção
    input  wire [3:0] nibble2,      // MSB
    input  wire [3:0] nibble1,      // middle
    input  wire [3:0] nibble0,      // LSB
    output reg  [6:0] data_ascii    // saída serial ASCII
);

    always @* begin
        case (sel)
            2'b00: data_ascii = {3'b011, nibble2};   // MSB
            2'b01: data_ascii = {3'b011, nibble1};   // middle
            2'b10: data_ascii = {3'b011, nibble0};   // LSB
            2'b11: data_ascii = 7'b0100011;          // '#'
            default: data_ascii = 7'b0100011;
        endcase
    end

endmodule
