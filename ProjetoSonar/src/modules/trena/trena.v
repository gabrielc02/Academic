/* --------------------------------------------------------------------------
 *  Trena
 * --------------------------------------------------------------------------
 */
 
module trena (
    input clock,
    input reset,
    input transmissao,
    input medicao,
    input [11:0] mem_data,
    input echo,
    input [2:0] sel,
    output trigger,
    output saida_serial,
    output serial_pronto,
    output sensor_pronto
);

wire [11:0] sig_medida;
wire [6:0] sig_data;

    mux_nibble MUX_SIG (
        .sel       (sel),
        .nibble5   (mem_data[11:8]),
        .nibble4   (mem_data[7:4]),
        .nibble3   (mem_data[3:0]),
        .nibble2   (sig_medida[11:8]),
        .nibble1   (sig_medida[7:4]),
        .nibble0   (sig_medida[3:0]),
        .data_ascii(sig_data)
    );

    tx_serial_7E1 SERIAL (
        .clock          ( clock ),   
        .reset          ( reset ),
        .partida        ( transmissao ),
        .paridade       ( 1'b0 ),
        .dados_ascii    ( sig_data ),
        .saida_serial   ( saida_serial ),
        .pronto         ( serial_pronto )     
    );

    exp3_sensor SENSOR (
        .clock      ( clock ),
        .reset      ( reset ),
        .medir      ( medicao ),
        .echo       ( echo ),
        .trigger    ( trigger ),
        .medida     ( sig_medida ),
        .pronto     ( sensor_pronto )
    );


endmodule