/* sonar*/
 
module sonar (
  input clock,
  input reset,
  input ligar,
  input echo,
  output trigger,
  output pwm,
  output tick,
  output saida_serial,
  output fim_posicao,
  output conta,
  output limpa,
  output [6:0] db_estado,
  output [6:0] contador
);

// INTERANL WIRES
wire sig_transmissao;
wire sig_tick_2s;
wire sig_conta_tick_2s;
wire sig_limpa_tick_2s;
wire sig_serial_pronto;
wire sig_sensor_pronto;
wire [3:0] sig_contador;
wire [3:0] sig_estado;
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
  .limpa_tick_2s    ( sig_limpa_tick_2s ),
  .conta_tick_2s    ( sig_conta_tick_2s ),
  .contador			    ( sig_contador ),
  .sel_rom          ( sig_sel_rom ),
  .sel_transmissao  ( sig_sel_transmissao ),
  .sel_posicao      ( sig_sel_posicao ),
  .trigger          ( trigger ),
  .pwm              ( pwm ),
  .tick_2s          ( sig_tick_2s ),
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
    .limpa_tick_2s    ( sig_limpa_tick_2s ),
    .conta_tick_2s    ( sig_conta_tick_2s ),
    .transmissao      ( sig_transmissao ),
    .sel_rom          ( sig_sel_rom ),
    .tick_2s          ( sig_tick_2s ),
    .sel_transmissao  ( sig_sel_transmissao ),
    .sel_posicao      ( sig_sel_posicao ),
    .fim_posicao      ( fim_posicao ),
    .db_estado        ( sig_estado )
); 

hexa7seg U_DISPLAYESTADO (
    .hexa     ( sig_estado ),
    .display  ( db_estado )
);

hexa7seg U_DISPLAYCONTADOR (
    .hexa     ( sig_contador ),
    .display  ( contador )
);

assign conta = sig_conta_tick_2s;
assign tick = sig_tick_2s;
assign limpa = sig_limpa_tick_2s;

endmodule