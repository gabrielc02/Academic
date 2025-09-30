/* --------------------------------------------------------------------------
 *  Arquivo   : exp3_sensor.v
 * --------------------------------------------------------------------------
 *  Descricao : circuito de teste do componente interface_hcsr04.v
 *              inclui componentes para dispositivos externos
 *              detector de borda e codificadores de displays de 7 segmentos
 *
 *              usar para sintetizar projeto no Intel Quartus Prime
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 *      09/09/2024  1.1     Edson Midorikawa  revisao
 * --------------------------------------------------------------------------
 */
 
module exp3_sensor (
    input wire        clock,
    input wire        reset,
    input wire        medir,
    input wire        echo,
    output wire       trigger,
    output wire [11:0] medida,
    output wire       pronto
);

    // Sinais internos
    wire        s_trigger;
    wire [11:0] s_medida ;

    // Circuito de interface com sensor
    interface_hcsr04 INT (
        .clock    (clock    ),
        .reset    (reset    ),
        .medir    (medir  ),
        .echo     (echo     ),
        .trigger  (s_trigger),
        .medida   (s_medida ),
        .pronto   (pronto   )
    );

    // Trata entrada medir (considerando borda de subida)

    // Sinais de saída
    assign trigger = s_trigger;
    assign medida = s_medida;


endmodule