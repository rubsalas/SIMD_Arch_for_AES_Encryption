/*
Instruction memory module v3
Little endian byte order
Date: 29/08/24
Test bench ran: 29/08/24 
*/
module instruction_memory # (parameter N = 32) (
        input  logic [13:0] address,
        output logic [N-1:0] instruction
    );

    // Declaración de memoria
    logic [7:0] memoria [1024:0];

    // Tarea para cargar la memoria desde un archivo .mif
    task cargar_memoria();
        // $readmemb("../../memory/instruction_memory/32bits_instructions.txt", memoria);
        $readmemb("../../hdl_files/memory/instruction_memory/32bits_instructions.txt", memoria);
    endtask

    // Llama a la tarea para cargar la memoria al inicio
    initial begin
        cargar_memoria();
    end

    // Acceso a la memoria
    assign instruction[7:0] = memoria[address];
    assign instruction[15:8] = memoria[address+1];
    assign instruction[23:16] = memoria[address+2];
    assign instruction[31:24] = memoria[address+3];

endmodule
