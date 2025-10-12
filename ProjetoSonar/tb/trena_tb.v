`timescale 1ns/1ns

module trena_tb;

    // -------------------------------
    // Declaração de sinais
    // -------------------------------
    reg        clock_in = 0;
    reg        reset_in = 0;
    reg        transmissao_in = 0;
    reg        medicao_in = 0;
    reg        echo_in = 0;
    reg [11:0] mem_data_in = 12'hABC;
    reg [2:0]  sel_in = 3'b000;      

    wire       trigger_out;
    wire       saida_serial_out;
    wire       serial_pronto_out;
    wire       sensor_pronto_out;
    wire [11:0] sig_medida;            // medida do sensor
    wire [6:0] sig_data;               // dado pronto para serial

    // -------------------------------
    // Instancia DUT
    // -------------------------------
    trena dut (
        .clock          (clock_in),
        .reset          (reset_in),
        .transmissao    (transmissao_in),
        .medicao        (medicao_in),
        .echo           (echo_in),
        .mem_data       (mem_data_in),
        .sel            (sel_in),
        .trigger        (trigger_out),
        .saida_serial   (saida_serial_out),
        .serial_pronto  (serial_pronto_out),
        .sensor_pronto  (sensor_pronto_out)
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
        $display("Início das simulações da trena...");

        // Reset
        reset_in = 1;
        #(2*clockPeriod);
        reset_in = 0;
        @(negedge clock_in);

        // Aguarda o DUT estabilizar
        #(100_000);

        // -------------------------------
        // Teste 1: medir distância curta
        // -------------------------------
        sel_in = 3'b000;      // seleciona nibble 0
        mem_data_in = 12'h123; 

        // Dispara medição
        medicao_in = 1;
        #(10_000);
        medicao_in = 0;

        // Simula eco: pulso de 5 us (distância curta)
        #(50_000);           // espera antes do eco
        echo_in = 1;
        #(5_000);
        echo_in = 0;

        // Espera sensor pronto
        wait(sensor_pronto_out == 1'b1);
        $display("Medida recebida: %0d", sig_medida);

        // Transmissão serial
        transmissao_in = 1;
        #(10_000);
        transmissao_in = 0;

        wait(serial_pronto_out == 1'b1);
        $display("Dado enviado pela serial: %h", sig_data);

        // -------------------------------
        // Teste 2: medir distância maior
        // -------------------------------
        sel_in = 3'b001;      // seleciona nibble 1
        mem_data_in = 12'hABC;

        medicao_in = 1;
        #(10_000);
        medicao_in = 0;

        #(50_000);           // espera antes do eco
        echo_in = 1;
        #(20_000);           // pulso maior → medida maior
        echo_in = 0;

        wait(sensor_pronto_out == 1'b1);
        $display("Medida recebida: %0d", sig_medida);

        transmissao_in = 1;
        #(10_000);
        transmissao_in = 0;

        wait(serial_pronto_out == 1'b1);
        $display("Dado enviado pela serial: %h", sig_data);

        // -------------------------------
        // Fim da simulação
        // -------------------------------
        $display("Fim das simulações da trena.");
        $stop;
    end

endmodule
