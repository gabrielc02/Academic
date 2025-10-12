`timescale 1ns/1ns

module sonar_fd_tb;

    // -------------------------------
    // Declaração de sinais
    // -------------------------------
    reg         clock_in = 0;
    reg         reset_in = 0;
    reg         medicao_in = 0;
    reg         echo_in = 0;
    reg         transmissao_in = 0;
    reg         limpa_tick_2s = 0;
    reg         conta_tick_2s = 0;
    reg [2:0]   sel_rom = 3'b000;
    reg [2:0]   sel_transmissao = 3'b000;
    reg [2:0]   sel_posicao = 3'b000;

    wire        tick_2s_out;
    wire        trigger_out;
    wire        pwm_out;
    wire        saida_serial_out;
    wire        serial_pronto_out;
    wire        sensor_pronto_out;
    wire [3:0]  contador_out;

    // -------------------------------
    // Instancia DUT
    // -------------------------------
    sonar_fd dut (
        .clock          (clock_in),
        .reset          (reset_in),
        .echo           (echo_in),
        .medicao        (medicao_in),
        .transmissao    (transmissao_in),
        .limpa_tick_2s  (limpa_tick_2s),
        .conta_tick_2s  (conta_tick_2s),
        .sel_rom        (sel_rom),
        .sel_transmissao(sel_transmissao),
        .sel_posicao    (sel_posicao),
        .tick_2s        (tick_2s_out),
        .trigger        (trigger_out),
        .pwm            (pwm_out),
        .saida_serial   (saida_serial_out),
        .serial_pronto  (serial_pronto_out),
        .sensor_pronto  (sensor_pronto_out),
        .contador       (contador_out)
    );

    // -------------------------------
    // Clock generator
    // -------------------------------
    parameter clockPeriod = 20; // 50 MHz
    always #(clockPeriod/2) clock_in = ~clock_in;

    // -------------------------------
    // Testbench principal
    // -------------------------------
    initial begin
        $display("Início das simulações do sonar_fd...");

        // Reset
        reset_in = 1;
        #(2*clockPeriod);
        reset_in = 0;
        @(negedge clock_in);

        // Inicializações
        medicao_in = 0;
        echo_in = 0;
        transmissao_in = 0;
        limpa_tick_2s = 0;
        conta_tick_2s = 0;
        sel_rom = 3'b000;
        sel_transmissao = 3'b000;
        sel_posicao = 3'b000;

        #(100_000); // espera inicial

        // -------------------------------
        // Teste 1: disparo de medição e eco curto
        // -------------------------------
        sel_rom = 3'b001;          // seleciona valor na ROM
        sel_transmissao = 3'b000;  // envia nibble0 da medida
        sel_posicao = 3'b010;      // controla PWM do servo

        medicao_in = 1;
        #(10_000);
        medicao_in = 0;

        #(50_000);
        echo_in = 1;               // pulso curto = distância pequena
        #(5_000);
        echo_in = 0;

        wait(sensor_pronto_out == 1);
        $display("Sensor pronto. Trigger: %b", trigger_out);

        // Transmissão serial
        transmissao_in = 1;
        #(10_000);
        transmissao_in = 0;
        wait(serial_pronto_out == 1);
        $display("Serial enviou nibble: %h", saida_serial_out);

        // -------------------------------
        // Teste 2: disparo de medição e eco longo
        // -------------------------------
        sel_rom = 3'b010;
        sel_transmissao = 3'b001;  // nibble1
        sel_posicao = 3'b100;

        medicao_in = 1;
        #(10_000);
        medicao_in = 0;

        #(50_000);
        echo_in = 1;               // pulso maior = distância maior
        #(20_000);
        echo_in = 0;

        wait(sensor_pronto_out == 1);
        $display("Sensor pronto. Trigger: %b", trigger_out);

        transmissao_in = 1;
        #(10_000);
        transmissao_in = 0;
        wait(serial_pronto_out == 1);
        $display("Serial enviou nibble: %h", saida_serial_out);

        // -------------------------------
        // Teste contador 2s
        // -------------------------------
        conta_tick_2s = 1;
        #(200_000_000); // simula 2s (ajuste de acordo com parametrização real)
        conta_tick_2s = 0;
        $display("Tick 2s: %b, Contador: %h", tick_2s_out, contador_out);

        // -------------------------------
        // Fim da simulação
        // -------------------------------
        $display("Fim das simulações do sonar_fd.");
        $stop;
    end

endmodule
