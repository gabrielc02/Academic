`timescale 1ns/1ns

module sonar_uc_tb;

    // -------------------------------
    // Sinais
    // -------------------------------
    reg clock_in = 0;
    reg reset_in = 0;
    reg ligar_in = 0;
    reg tick_2s_in = 0;
    reg serial_pronto_in = 0;
    reg sensor_pronto_in = 0;

    wire limpa_tick_2s_out;
    wire conta_tick_2s_out;
    wire transmissao_out;
    wire fim_posicao_out;
    wire medicao_out;
    wire [2:0] sel_rom_out;
    wire [2:0] sel_transmissao_out;
    wire [2:0] sel_posicao_out;
    wire [4:0] db_estado_out;

    // -------------------------------
    // DUT
    // -------------------------------
    sonar_uc dut (
        .clock(clock_in),
        .reset(reset_in),
        .ligar(ligar_in),
        .tick_2s(tick_2s_in),
        .serial_pronto(serial_pronto_in),
        .sensor_pronto(sensor_pronto_in),
        .limpa_tick_2s(limpa_tick_2s_out),
        .conta_tick_2s(conta_tick_2s_out),
        .transmissao(transmissao_out),
        .fim_posicao(fim_posicao_out),
        .medicao(medicao_out),
        .sel_rom(sel_rom_out),
        .sel_transmissao(sel_transmissao_out),
        .sel_posicao(sel_posicao_out),
        .estado(db_estado_out)
    );

    // -------------------------------
    // Clock
    // -------------------------------
    parameter clkPeriod = 20; // 50 MHz
    always #(clkPeriod/2) clock_in = ~clock_in;

    // -------------------------------
    // Testbench
    // -------------------------------
    initial begin
        $display("Início da simulação do sonar_uc...");

        // Reset inicial
        reset_in = 1; ligar_in = 0;
        #(2*clkPeriod);
        reset_in = 0; ligar_in = 1;

        // Inicializações
        tick_2s_in = 0;
        serial_pronto_in = 0;
        sensor_pronto_in = 0;

        #(50); // aguarda estabilidade

        // -------------------------------
        // Trigger do tick_2s para iniciar medição
        // -------------------------------
        tick_2s_in = 1;
        @(negedge clock_in);
        tick_2s_in = 0;

        // -------------------------------
        // Simulação de sensor_pronto e serial_pronto
        // -------------------------------
        // Durante TX, vamos gerar pulses de serial_pronto para percorrer todos os nibble
        fork
            begin
                // Aguarda estado MEDIR
                wait (dut.Eatual == dut.MEDIR);
                $display("Estado MEDIR ativo");
                sensor_pronto_in = 1;  // simula medida pronta
                @(negedge clock_in);
                sensor_pronto_in = 0;
            end

            begin
                // Aguarda estado TX
                wait (dut.Eatual == dut.TX);
                $display("Estado TX ativo, enviando 8 nibble...");
                repeat (8) begin
                    serial_pronto_in = 1;
                    @(negedge clock_in);
                    serial_pronto_in = 0;
                    @(negedge clock_in);
                    $display("TX count: %0d, sel_transmissao: %b", dut.tx_count, sel_transmissao_out);
                end
            end
        join

        // -------------------------------
        // Verificação final do PROX_POS
        // -------------------------------
        wait (dut.Eatual == dut.PROX_POS);
        $display("Estado PROX_POS ativo, sel_posicao: %b", sel_posicao_out);

        $display("Fim da simulação do sonar_uc.");
        $stop;
    end

endmodule
