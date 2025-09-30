/* --------------------------------------------------------------------------
 * Arquivo   : mux_nibble.v
 * -------------------------------------------------------------------------- */
module mux_nibble (
    input  wire [2:0] sel,          // contador de seleção
    input  wire [3:0] nibble5,      // MSB ANGULO
    input  wire [3:0] nibble4,      // MIDDLE ANGULO
    input  wire [3:0] nibble3,      // LSB ANGULO
    input  wire [3:0] nibble2,      // MSB MEDIDA
    input  wire [3:0] nibble1,      // MIDDLE MEDIDA
    input  wire [3:0] nibble0,      // LSB MEDIDA
    output reg  [6:0] data_ascii    // saída serial ASCII
);

    always @* begin
        case (sel)
            3'b000: data_ascii = {3'b011, nibble5};   // MSB ANGULO
            3'b001: data_ascii = {3'b011, nibble4};   // MIDDLE ANGULO
            3'b010: data_ascii = {3'b011, nibble3};   // LSB ANGULO
            3'b011: data_ascii = 7'b0101100;          // ','
            3'b100: data_ascii = {3'b011, nibble2};   // MSB MEDIDA
            3'b101: data_ascii = {3'b011, nibble1};   // MIDDLE MEDIDA
            3'b110: data_ascii = {3'b011, nibble0};   // LSB MEDIDA
            3'b111: data_ascii = 7'b0100011;          // '#'

            default: data_ascii = 7'b0100001;
        endcase
    end

endmodule
