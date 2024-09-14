/*
Test bench for Condition Checker module
Date: 13/09/24
NY Approved
*/
module condition_checker_tb;

    // Testbench signals
    logic [2:0] Opcode;
    logic [1:0] S;
    logic [3:0] Flags;
    logic CondEx;

    // Instantiate the Condition Checker module
    condition_checker uut (
        .Opcode(Opcode),
        .S(S),
        .Flags(Flags),
        .CondEx(CondEx)
    );

    initial begin
        $display("Condition Checker test bench:\n");

        Opcode = 3'b0;
        S = 2'b0;
        Flags = 4'b0000;
    end

    // Test sequence
    initial begin
        // Test 1: Opcode = 110, S = EQ (2'b00), Z_flag = 1
        $display("\nTest 1: EQ Condition, Z_flag = 1");
        Opcode = 3'b110;
        S = 2'b00;
        Flags = 4'b0100; // Z_flag = 1
        #10;
        assert(CondEx == 1) else $fatal("Test 1 failed: CondEx = %b", CondEx);
        $display("Opcode = %b, S = %b, Flags = %b, CondEx = %b", Opcode, S, Flags, CondEx);

        // Test 2: Opcode = 110, S = NE (2'b01), Z_flag = 0
        $display("\nTest 2: NE Condition, Z_flag = 0");
        Opcode = 3'b110;
        S = 2'b01;
        Flags = 4'b0000; // Z_flag = 0
        #10;
        assert(CondEx == 1) else $fatal("Test 2 failed: CondEx = %b", CondEx);
        $display("Opcode = %b, S = %b, Flags = %b, CondEx = %b", Opcode, S, Flags, CondEx);

        // Test 3: Opcode = 110, S = GT (2'b10), Z_flag = 0, N_flag = 0, V_flag = 0
        $display("\nTest 3: GT Condition, Z_flag = 0, N_flag = 0, V_flag = 0");
        Opcode = 3'b110;
        S = 2'b10;
        Flags = 4'b0000; // Z_flag = 0, N_flag = 0, V_flag = 0
        #10;
        assert(CondEx == 1) else $fatal("Test 3 failed: CondEx = %b", CondEx);
        $display("Opcode = %b, S = %b, Flags = %b, CondEx = %b", Opcode, S, Flags, CondEx);

        // Test 4: Opcode = 110, S = GT (2'b10), Z_flag = 0, N_flag = 1, V_flag = 1
        $display("\nTest 4: GT Condition, Z_flag = 0, N_flag = 1, V_flag = 1");
        Opcode = 3'b110;
        S = 2'b10;
        Flags = 4'b1001; // Z_flag = 0, N_flag = 1, V_flag = 1
        #10;
        assert(CondEx == 1) else $fatal("Test 4 failed: CondEx = %b", CondEx);
        $display("Opcode = %b, S = %b, Flags = %b, CondEx = %b", Opcode, S, Flags, CondEx);

        // Test 5: Opcode = 110, S = Unconditional (2'b11)
        $display("\nTest 5: Unconditional Condition");
        Opcode = 3'b110;
        S = 2'b11;
        Flags = 4'b0000; // Flags don't matter
        #10;
        assert(CondEx == 1) else $fatal("Test 5 failed: CondEx = %b", CondEx);
        $display("Opcode = %b, S = %b, Flags = %b, CondEx = %b", Opcode, S, Flags, CondEx);

        // Test 6: Opcode not equal to 110
        $display("\nTest 6: Opcode not 110, default behavior");
        Opcode = 3'b101; // Opcode not equal to 110
        S = 2'b00; // S and Flags don't matter
        Flags = 4'b0000;
        #10;
        assert(CondEx == 1) else $fatal("Test 6 failed: CondEx = %b", CondEx);
        $display("Opcode = %b, S = %b, Flags = %b, CondEx = %b", Opcode, S, Flags, CondEx);

        $display("Condition Checker tests completed.");
        $finish;
    end

endmodule
