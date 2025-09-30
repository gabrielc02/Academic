/*
 * rom_angulos_8x12.v
 * ROM de ângulos em BCD (3 dígitos = 12 bits)
 */
 
module rom_angulos_8x12 (
    input      [2:0]  endereco, 
    output reg [11:0] saida
);

  // conteúdo da ROM em um array
  reg [11:0] tabela_angulos [0:7]; 

  initial begin
    // inicializa array com valores dos ângulos (BCD)
    tabela_angulos[0] = 12'h020; // 0 = 020
    tabela_angulos[1] = 12'h040; // 1 = 040
    tabela_angulos[2] = 12'h060; // 2 = 060
    tabela_angulos[3] = 12'h080; // 3 = 080
    tabela_angulos[4] = 12'h100; // 4 = 100
    tabela_angulos[5] = 12'h120; // 5 = 120
    tabela_angulos[6] = 12'h140; // 6 = 140
    tabela_angulos[7] = 12'h160; // 7 = 160
  end

  // saída da memória em função do endereço
  always @(*) begin 
    saida = tabela_angulos[endereco]; 
  end

endmodule
