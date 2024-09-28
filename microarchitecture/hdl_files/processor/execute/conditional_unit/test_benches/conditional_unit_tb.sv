/*
Test bench for conditional_unit module.
Date: 23/09/24
Approved
*/
module conditional_unit_tb;

    // Entradas
    logic PCSrcE;
    logic RegWriteE;
    logic MemWriteE;

    logic BranchE;

    logic [1:0] InstrSelE;
    logic [3:0] ALUFlags;

    // Salidas
    logic BranchTakenE;
    logic PCSrcECU;
    logic RegWriteECU;
    logic MemWriteECU;

    // Instancia del módulo conditional_unit
    conditional_unit uut (
        .PCSrcE(PCSrcE),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),

        .BranchE(BranchE),

        .InstrSelE(InstrSelE),
        .ALUFlags(ALUFlags),

        .BranchTakenE(BranchTakenE),
        .PCSrcECU(PCSrcECU),
        .RegWriteECU(RegWriteECU),
        .MemWriteECU(MemWriteECU)
    );

    // Test sequence
    initial begin
        $display("\nComenzando pruebas del modulo conditional_unit...");

        // Caso 1: No es una instrucción de branch, CondEx debe ser 1.
        $display("\nTest 1: No branch");
        PCSrcE = 1;
        RegWriteE = 1;
        MemWriteE = 1;
        BranchE = 0;             // No branch
        InstrSelE = 2'b00;       // Cualquier valor, no es relevante
        ALUFlags = 4'b0000;      // Cualquier valor, no es relevante
        #10;
        $display("PCSrcE: %b, RegWriteE: %b, MemWriteE: %b,", PCSrcE, RegWriteE, MemWriteE);
        $display("ALUFlags: %b, ALUFlags: [N=%b, Z=%b, C=%b, V=%b]", ALUFlags, ALUFlags[3], ALUFlags[2], ALUFlags[1], ALUFlags[0]);
        $display("BranchTakenE: %b, PCSrcECU: %b, RegWriteECU: %b, MemWriteECU: %b", BranchTakenE, PCSrcECU, RegWriteECU, MemWriteECU);
        assert(BranchTakenE == 0 && PCSrcECU == 1 && RegWriteECU == 1 && MemWriteECU == 1)
        else $fatal("Test 1 fallo");

        // Caso 2: Branch condicional con ALUFlags = EQ (Equal)
        $display("\nTest 2: Branch EQ (Equal), ALUFlags = 4'b0100 (Z=1)");
        BranchE = 1;
        InstrSelE = 2'b00;       // EQ (Equal)
        ALUFlags = 4'b0100;      // Z_flag = 1, el resto no importa
        #10;
        $display("PCSrcE: %b, RegWriteE: %b, MemWriteE: %b,", PCSrcE, RegWriteE, MemWriteE);
        $display("ALUFlags: %b, ALUFlags: [N=%b, Z=%b, C=%b, V=%b]", ALUFlags, ALUFlags[3], ALUFlags[2], ALUFlags[1], ALUFlags[0]);
        $display("BranchTakenE: %b, PCSrcECU: %b, RegWriteECU: %b, MemWriteECU: %b", BranchTakenE, PCSrcECU, RegWriteECU, MemWriteECU);
        assert(BranchTakenE == 1 && PCSrcECU == 1 && RegWriteECU == 1 && MemWriteECU == 1)
        else $fatal("Test 2 fallo");

        // Caso 3: Branch EQ con Z_flag = 0, no debe tomar el branch
        $display("\nTest 3: Branch EQ (Equal), ALUFlags = 4'b0000 (Z=0)");
        ALUFlags = 4'b0000;      // Z_flag = 0
        #10;
        $display("PCSrcE: %b, RegWriteE: %b, MemWriteE: %b,", PCSrcE, RegWriteE, MemWriteE);
        $display("ALUFlags: %b, ALUFlags: [N=%b, Z=%b, C=%b, V=%b]", ALUFlags, ALUFlags[3], ALUFlags[2], ALUFlags[1], ALUFlags[0]);
        $display("BranchTakenE: %b, PCSrcECU: %b, RegWriteECU: %b, MemWriteECU: %b", BranchTakenE, PCSrcECU, RegWriteECU, MemWriteECU);
        assert(BranchTakenE == 0 && PCSrcECU == 0 && RegWriteECU == 0 && MemWriteECU == 0)
        else $fatal("Test 3 fallo");

        // Caso 4: Branch GT (Signed greater than) con N_flag=0, V_flag=0, Z_flag=0 (positivo y mayor)
        $display("\nTest 4: Branch GT (Greater than), ALUFlags = 4'b0000");
        InstrSelE = 2'b10;       // GT (Greater than)
        ALUFlags = 4'b0000;      // Z=0, N=0, V=0 (positivo y mayor)
        #10;
        $display("PCSrcE: %b, RegWriteE: %b, MemWriteE: %b,", PCSrcE, RegWriteE, MemWriteE);
        $display("ALUFlags: %b, ALUFlags: [N=%b, Z=%b, C=%b, V=%b]", ALUFlags, ALUFlags[3], ALUFlags[2], ALUFlags[1], ALUFlags[0]);
        $display("BranchTakenE: %b, PCSrcECU: %b, RegWriteECU: %b, MemWriteECU: %b", BranchTakenE, PCSrcECU, RegWriteECU, MemWriteECU);
        assert(BranchTakenE == 1 && PCSrcECU == 1 && RegWriteECU == 1 && MemWriteECU == 1)
        else $fatal("Test 4 fallo");

        // Caso 5: Branch GT con N_flag=1, V_flag=0, Z_flag=0 (negativo, no mayor)
        $display("\nTest 5: Branch GT (Greater than), ALUFlags = 4'b1000");
        ALUFlags = 4'b1000;      // Z=0, N=1, V=0 (negativo, no mayor)
        #10;
        $display("PCSrcE: %b, RegWriteE: %b, MemWriteE: %b,", PCSrcE, RegWriteE, MemWriteE);
        $display("ALUFlags: %b, ALUFlags: [N=%b, Z=%b, C=%b, V=%b]", ALUFlags, ALUFlags[3], ALUFlags[2], ALUFlags[1], ALUFlags[0]);
        $display("BranchTakenE: %b, PCSrcECU: %b, RegWriteECU: %b, MemWriteECU: %b", BranchTakenE, PCSrcECU, RegWriteECU, MemWriteECU);
        assert(BranchTakenE == 0 && PCSrcECU == 0 && RegWriteECU == 0 && MemWriteECU == 0)
        else $fatal("Test 5 fallo");

        // Caso 6: Branch incondicional (ALUFlags = b)
        $display("\nTest 6: Branch incondicional, ALUFlags = 2'b11");
        InstrSelE = 2'b11;       // Incondicional
        ALUFlags = 4'b0000;      // Los ALUFlags no importan
        #10;
        $display("PCSrcE: %b, RegWriteE: %b, MemWriteE: %b,", PCSrcE, RegWriteE, MemWriteE);
        $display("ALUFlags: %b, ALUFlags: [N=%b, Z=%b, C=%b, V=%b]", ALUFlags, ALUFlags[3], ALUFlags[2], ALUFlags[1], ALUFlags[0]);
        $display("BranchTakenE: %b, PCSrcECU: %b, RegWriteECU: %b, MemWriteECU: %b", BranchTakenE, PCSrcECU, RegWriteECU, MemWriteECU);
        assert(BranchTakenE == 1 && PCSrcECU == 1 && RegWriteECU == 1 && MemWriteECU == 1)
        else $fatal("Test 6 fallo");

        // Finalización
        $display("\nTodas las pruebas completadas con exito.\n");
        #100;
        $finish;
    end

endmodule
