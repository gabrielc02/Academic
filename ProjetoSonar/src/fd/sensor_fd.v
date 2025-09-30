
/* sonar FD */

module sonar_fd (
  input clock,
  input reset,
  input ligar,
  input echo,
  output trigger,
  output pwm,
  output saida_serial,
);

// TRENA
exp4_trena TRENA (
    .clock          ( clock ),
    .reset          ( reset ),
    .mensurar       ( 1b'1 ),
    .echo           ( echo ),
    .trigger        ( trigger ),
    .saida_serial   ( saida serial ),
    .pronto         (),
	.db_estado      ()
);

// CONTROLE
controle_servo SERVO (
    .clock          ( clock ),
    .reset          ( reset ),
    .posicao        ( ),
    .controle       ( pwm ),
    .db_controle    ( )
);

// ROM
rom_angulos_8x24 ROM (
    .endereco       (),
    .saida          (),
);

endmodule