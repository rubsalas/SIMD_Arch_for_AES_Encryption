module testbench;
    logic clk;
    logic rst_n;

    // Señales del procesador y del módulo de medición de rendimiento
    logic start_instr;
    logic end_instr;
    logic [31:0] total_cycles;
    logic [31:0] instr_count;
    logic [31:0] cpi;

    // Instancia del procesador
    My_Processor uut (
        .clk(clk),
        .rst_n(rst_n),
        .start_instr(start_instr),
        .end_instr(end_instr),
        .total_cycles(total_cycles),
        .instr_count(instr_count),
        .cpi(cpi)
    );

    // Generación de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Periodo de 10 unidades de tiempo
    end

    // Señal de reset
    initial begin
        rst_n = 0;
        #20 rst_n = 1;  // Quitamos el reset después de 20 unidades de tiempo
    end

    // Proceso de fin de simulación
    initial begin
        // Esperamos un tiempo suficiente para que la simulación termine
        #10000;

        // Mostramos los resultados al final de la simulación
        $display("===== Resultados de Rendimiento =====");
        $display("Total de Ciclos: %0d", total_cycles);
        $display("Instrucciones Ejecutadas: %0d", instr_count);
        $display("Ciclos por Instrucción (CPI): %0d", cpi);
        $stop;  // Terminamos la simulación
    end
endmodule
