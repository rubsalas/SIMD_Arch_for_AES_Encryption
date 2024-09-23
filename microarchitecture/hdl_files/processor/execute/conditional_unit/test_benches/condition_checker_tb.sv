/*
Test bench for conditino_checker module.
Date: 23/09/24
Approved
*/
module condition_checker_tb;

    // Entradas
    logic Branch;
    logic [1:0] InstrSel;
    logic [3:0] Flags;

    // Salida
    logic CondEx;

    // Instancia del módulo condition_checker
    condition_checker uut (
        .Branch(Branch),
        .InstrSel(InstrSel),
        .Flags(Flags),
        .CondEx(CondEx)
    );

    // Variables para simular comparaciones
    logic signed [31:0] RD1, RD2;

    // Test sequence
    initial begin
        $display("Comenzando las pruebas del modulo condition_checker con simulacion de registros...");

        // Caso 1: No es una instrucción de branch, CondEx debe ser 1
        $display("\nTest 1: No branch");
        Branch = 0;               // No es una instrucción de branch
        InstrSel = 2'b00;         // Cualquier valor
        Flags = 4'b0000;          // Cualquier valor
        #10;
        $display("Branch: %b, InstrSel: %b, Flags: [N=%b, Z=%b, C=%b, V=%b]", Branch, InstrSel, Flags[3], Flags[2], Flags[1], Flags[0]);
        $display("=> CondEx: %b", CondEx);
        assert(CondEx == 1) else $fatal("Test 1 fallo");

        // Caso 2: Branch EQ con Z_flag = 1 (Comparacion: RD1 = 5, RD2 = 5)
        $display("\nTest 2: Branch EQ (Equal), Comparacion: RD1 = 5, RD2 = 5");
        RD1 = 5;
        RD2 = 5;
        // Para EQ, si RD1 == RD2, Z_flag = 1
        Flags = 4'b0100;          // Z_flag = 1
        Branch = 1;
        InstrSel = 2'b00;         // EQ (Equal)
        $display("Comparando: RD1 = %0d, RD2 = %0d", RD1, RD2);
        #10;
        $display("Branch: %b, InstrSel: %b, Flags: [N=%b, Z=%b, C=%b, V=%b]", Branch, InstrSel, Flags[3], Flags[2], Flags[1], Flags[0]);
        $display("=> CondEx: %b", CondEx);
        assert(CondEx == 1) else $fatal("Test 2 fallo");

        // Caso 3: Branch EQ con Z_flag = 0 (Comparacion: RD1 = 5, RD2 = 7)
        $display("\nTest 3: Branch EQ (Equal), Comparacion: RD1 = 5, RD2 = 7");
        RD1 = 5;
        RD2 = 7;
        // Para EQ, si RD1 != RD2, Z_flag = 0
        Flags = 4'b0000;          // Z_flag = 0
        Branch = 1;
        InstrSel = 2'b00;         // EQ (Equal)
        $display("Comparando: RD1 = %0d, RD2 = %0d", RD1, RD2);
        #10;
        $display("Branch: %b, InstrSel: %b, Flags: [N=%b, Z=%b, C=%b, V=%b]", Branch, InstrSel, Flags[3], Flags[2], Flags[1], Flags[0]);
        $display("=> CondEx: %b", CondEx);
        assert(CondEx == 0) else $fatal("Test 3 fallo");

        // Caso 4: Branch GT (Greater than) con N=0, Z=0, V=0 (Comparacion: RD1 = 7, RD2 = 5)
        $display("\nTest 4: Branch GT (Greater than), Comparacion: RD1 = 7, RD2 = 5");
        RD1 = 7;
        RD2 = 5;
        // Para GT, si RD1 > RD2, Z=0 y N_flag ^ V_flag = 0
        Flags = 4'b0000;          // N=0, Z=0, V=0 (positivo, mayor que)
        Branch = 1;
        InstrSel = 2'b10;         // GT (Greater than)
        $display("Comparando: RD1 = %0d, RD2 = %0d", RD1, RD2);
        #10;
        $display("Branch: %b, InstrSel: %b, Flags: [N=%b, Z=%b, C=%b, V=%b]", Branch, InstrSel, Flags[3], Flags[2], Flags[1], Flags[0]);
        $display("=> CondEx: %b", CondEx);
        assert(CondEx == 1) else $fatal("Test 4 fallo");

        // Caso 5: Branch GT con N=1, V=0, Z=0 (Comparacion: RD1 = -5, RD2 = 3)
        $display("\nTest 5: Branch GT (Greater than), Comparacion: RD1 = -5, RD2 = 3");
        RD1 = -5;
        RD2 = 3;
        // Para GT, si RD1 < RD2, N=1 y Z=0
        Flags = 4'b1000;          // N=1, Z=0, V=0 (negativo)
        Branch = 1;
        InstrSel = 2'b10;         // GT (Greater than)
        $display("Comparando: RD1 = %0d, RD2 = %0d", RD1, RD2);
        #10;
        $display("Branch: %b, InstrSel: %b, Flags: [N=%b, Z=%b, C=%b, V=%b]", Branch, InstrSel, Flags[3], Flags[2], Flags[1], Flags[0]);
        $display("=> CondEx: %b", CondEx);
        assert(CondEx == 0) else $fatal("Test 5 fallo");

        // Caso 6: Branch incondicional (InstrSel = b) (Comparacion: RD1 = 10, RD2 = 3)
        $display("\nTest 6: Branch incondicional, Comparacion: RD1 = 10, RD2 = 3");
        RD1 = 10;
        RD2 = 3;
        // Para una instrucción incondicional, CondEx debe ser 1 independientemente de los valores
        Flags = 4'b0000;          // Los flags no importan
        Branch = 1;
        InstrSel = 2'b11;         // Incondicional
        $display("Comparando: RD1 = %0d, RD2 = %0d", RD1, RD2);
        #10;
        $display("Branch: %b, InstrSel: %b, Flags: [N=%b, Z=%b, C=%b, V=%b]", Branch, InstrSel, Flags[3], Flags[2], Flags[1], Flags[0]);
        $display("=> CondEx: %b", CondEx);
        assert(CondEx == 1) else $fatal("Test 6 fallo");

        $display("\nTodas las pruebas completadas con exito.\n");
        #100;
        $finish;
    end

endmodule
