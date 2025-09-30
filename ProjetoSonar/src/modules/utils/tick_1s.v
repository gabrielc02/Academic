/* --------------------------------------------------------------------------
 *  Arquivo   : tick_1s.v   --- Para o desafio da semana 4
 * --------------------------------------------------------------------------
 */
 
module tick_1s (
  input  wire clock,
  input  wire reset,     // ativo alto
  output wire tick_1s    // pulso de 1 ciclo a cada 1 s
);
  // 50_000_000 ciclos @ 50 MHz
  localparam integer M = 50_000_000;
  localparam integer N = 26; // ceil(log2(M)) = 26

  wire fim;
  wire [N-1:0] Q;

  contador_m #(.M(M), .N(N)) u_cnt (
    .clock    (clock),
    .zera_as  (1'b0),
    .zera_s   (fim | reset),  // reinicia ao completar 1s ou em reset
    .conta    (1'b1),
    .Q        (Q),
    .fim      (fim),
    .meio     ()
  );

  assign tick_1s = fim; // pulso de 1 ciclo
endmodule
