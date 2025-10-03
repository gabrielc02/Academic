/* sonar FD */

module sonar_fd (
  input clock,
  input reset,
  input echo,
  input medicao,
  input transmissao,
  input limpa_tick_2s,
  input conta_tick_2s,
  input [2:0] sel_rom,
  input [2:0] sel_transmissao,
  input [2:0] sel_posicao,
  output tick_2s,
  output trigger,
  output pwm,
  output saida_serial,
  output serial_pronto,
  output sensor_pronto,
  output [3:0] contador
);

// INTERNAL WIRES
wire [11:0] sig_mem_data;
wire [26:0] sig_contador;

// TRENA
trena TRENA (
    .clock          ( clock ),
    .reset          ( reset ),
    .transmissao    ( transmissao ),
    .medicao        ( medicao ),
    .mem_data       ( sig_mem_data ),
    .echo           ( echo ),
    .sel            ( sel_transmissao ),
    .trigger        ( trigger ),
    .saida_serial   ( saida_serial ),
    .serial_pronto  ( serial_pronto ),
    .sensor_pronto  ( sensor_pronto )
);

// CONTROLE
controle_servo SERVO (
    .clock          ( clock ),
    .reset          ( reset ),
    .posicao        ( sel_posicao ),
    .controle       ( pwm )
);

// ROM
rom_angulos_8x12 ROM (
    .endereco       ( sel_rom ),
    .saida          ( sig_mem_data )
);

// TICK 2 SEG
contador_m #(.M(100000000), .N(27)) TICK2S (
    .clock      ( clock ),
    .zera_as    ( limpa_tick_2s ),
    .zera_s     ( 1'b0 ),
    .conta      ( conta_tick_2s ),
    .Q          ( sig_contador ),
    .fim        ( tick_2s ),
    .meio       ( )
);

assign contador = sig_contador[26:23];
//assign tick_2s = 1b'1;

endmodule