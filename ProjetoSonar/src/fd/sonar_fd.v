/* sonar FD */

module sonar_fd (
  input clock,
  input reset,
  input echo,
  input medicao,
  input transmissao,
  input [2:0] sel_rom,
  input [2:0] sel_transmissao,
  input [2:0] sel_posicao,
  output trigger,
  output pwm,
  output saida_serial,
  output serial_pronto,
  output sensor_pronto
);

// INTERNAL WIRES
wire [11:0] sig_mem_data;

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

endmodule