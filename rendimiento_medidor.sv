module Rendimiento_Medidor(
    input logic clk,          // Reloj
    input logic rst_n,        // Reset activo en bajo
    input logic start_instr,  // Señal para el inicio de instrucción
    input logic end_instr,    // Señal para el fin de instrucción
    output logic [31:0] total_cycles,   // Total de ciclos contados
    output logic [31:0] instr_count,    // Número total de instrucciones ejecutadas
    output logic [31:0] cpi             // Ciclos por instrucción (CPI)
);
    logic [31:0] cycle_counter;
    logic [31:0] instruction_counter;
    
    // Contador de ciclos
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycle_counter <= 32'd0;
        end else begin
            cycle_counter <= cycle_counter + 1;
        end
    end

    // Contador de instrucciones
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            instruction_counter <= 32'd0;
        end else if (start_instr) begin
            instruction_counter <= instruction_counter + 1;
        end
    end

    // Cálculo del CPI (solo se actualiza al final de cada instrucción)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cpi <= 32'd0;
        end else if (end_instr) begin
            cpi <= cycle_counter / instruction_counter;
        end
    end

    // Salidas
    assign total_cycles = cycle_counter;
    assign instr_count = instruction_counter;
    
endmodule
