`timescale 1ns/1ns

module sonar_tb;

    // -------------------------------
    // Sinais de entrada
    // -------------------------------
    reg clock_in = 0;
    reg reset_in = 0;
    reg ligar_in = 0;
    reg echo_in = 0;

    // -------------------------------
    // Sinais de saída
    // -------------------------------
    wire trigger_out;
    wire pwm_out;
    wire tick_out;
    wire saida_serial_out;
    wire fim_posicao_out;
    wire conta_out;
    wire limpa_out;
    wire db_transmissao_out;
    wire db_saida_serial_out;
    wire [6:0] db_estado_out;
    wire [6:0] contador_out;

    // -------------------------------
    // Instancia DUT
    // -------------------------------
    sonar dut (
        .clock(clock_in),
        .reset(reset_in),
        .ligar(ligar_in),
        .echo(echo_in),
        .trigger(trigger_out),
        .pwm(pwm_out),
        .tick(tick_out),
        .saida_serial(saida_serial_out),
        .fim_posicao(fim_posicao_out),
        .conta(conta_out),
        .limpa(limpa_out),
        .db_transmissao(db_transmissao_out),
        .db_saida_serial(db_saida_serial_out),
        .db_estado(db_estado_out),
        .contador(contador_out)
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
        $display("Início da simulação do sonar...");

        // Reset
        reset_in = 1; ligar_in = 0;
        #(2*clkPeriod);
        reset_in = 0; ligar_in = 1;

        // Inicializações
        echo_in = 0;

        #(50); // espera estabilidade

        // -------------------------------
        // Ciclo de medição completo
        // -------------------------------
        repeat (3) begin
            $display("Iniciando novo ciclo de medição...");

            // Espera o tick iniciar medição
            wait (tick_out == 1);
            $display("Tick_2s detectado, iniciando medição.");

            // Simula pulso do sensor
            #(100); 
            echo_in = 1;
            #(50);
            echo_in = 0;

            // Espera a transmissão ser finalizada
            wait (fim_posicao_out == 1);
            $display("Ciclo concluído: sel_posicao = %b, db_estado = %b", dut.U_UC.sel_posicao, db_estado_out);

            // Pequena pausa antes do próximo ciclo
            #(200);
        end

        $display("Fim da simulação do sonar.");
        $stop;
    end

endmodule
