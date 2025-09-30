/* sonar*/
 
module sonar (
  input clock,
  input reset,
  input ligar,
  input echo,
  output trigger,
  output pwm,
  output saida_serial,
  output fim_posicao
);

// INTERANL WIRES
wire sig_transmissao;
wire sig_serial_pronto;
wire sig_sensor_pronto;
wire [2:0] sig_sel_rom;
wire [2:0] sig_sel_posicao;
wire [2:0] sig_sel_transmissao;

// FD
sonar_fd U_FD (
  .clock            ( clock ),
  .reset            ( reset ),
  .echo             ( echo ),
  .medicao          ( ligar ),
  .transmissao      ( sig_transmissao ),
  .sel_rom          ( sig_sel_rom ),
  .sel_transmissao  ( sig_sel_transmissao ),
  .sel_posicao      ( sig_sel_posicao ),
  .trigger          ( trigger ),
  .pwm              ( pwm ),
  .saida_serial     ( saida_serial ),
  .serial_pronto    ( sig_serial_pronto ),
  .sensor_pronto    ( sig_sensor_pronto )
);

// UC
sonar_uc U_UC (
    .clock            ( clock ),
    .reset            ( reset ),
    .ligar            ( ligar ),
    .serial_pronto    ( sig_serial_pronto ),
    .sensor_pronto    ( sig_sensor_pronto ),
    .transmissao      ( sig_transmissao ),
    .sel_rom          ( sig_sel_rom ),
    .sel_transmissao  ( sig_sel_transmissao ),
    .sel_posicao      ( sig_sel_posicao ),
    .fim_posicao      ( fim_posicao )
); 

endmodule