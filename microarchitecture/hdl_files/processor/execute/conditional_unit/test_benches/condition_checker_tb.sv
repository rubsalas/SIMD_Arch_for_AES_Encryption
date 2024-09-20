module condition_checker_tb;

    // Testbench signals
    reg [5:0] Opcode;
    reg [3:0] Flags;
    wire CondEx;

    // Instantiate the condition_checker module
    condition_checker uut (
        .Opcode(Opcode),
        .Flags(Flags),
        .CondEx(CondEx)
    );

    // Test sequence
    initial begin
        $display("Starting Condition Checker tests...\n");

        // Test 1: EQ condition (Opcode: 001100, Z_flag = 1)
        Opcode = 6'b001100;
        Flags = 4'b0100; // Z_flag = 1
        #10;
        $display("Test 1: EQ Condition | Opcode=%b, Flags=%b, CondEx=%b", Opcode, Flags, CondEx);
        if (CondEx == 1) $display("Test 1 Passed");
        else $display("Test 1 Failed");

        // Test 2: EQ condition (Opcode: 001100, Z_flag = 0)
        Opcode = 6'b001100;
        Flags = 4'b0000; // Z_flag = 0
        #10;
        $display("Test 2: EQ Condition | Opcode=%b, Flags=%b, CondEx=%b", Opcode, Flags, CondEx);
        if (CondEx == 0) $display("Test 2 Passed");
        else $display("Test 2 Failed");

        // Test 3: GT condition (Opcode: 001110, Z_flag = 0, N_flag = 0, V_flag = 0)
        Opcode = 6'b001110;
        Flags = 4'b0000; // Z_flag = 0, N_flag = 0, V_flag = 0
        #10;
        $display("Test 3: GT Condition | Opcode=%b, Flags=%b, CondEx=%b", Opcode, Flags, CondEx);
        if (CondEx == 1) $display("Test 3 Passed");
        else $display("Test 3 Failed");

        // Test 4: GT condition (Opcode: 001110, Z_flag = 0, N_flag = 1, V_flag = 1)
        Opcode = 6'b001110;
        Flags = 4'b1001; // Z_flag = 0, N_flag = 1, V_flag = 1
        #10;
        $display("Test 4: GT Condition | Opcode=%b, Flags=%b, CondEx=%b", Opcode, Flags, CondEx);
        if (CondEx == 1) $display("Test 4 Passed");
        else $display("Test 4 Failed");

        // Test 5: Unconditional (Opcode: 001111)
        Opcode = 6'b001111;
        Flags = 4'b0000; // Flags don't matter for unconditional
        #10;
        $display("Test 5: Unconditional | Opcode=%b, Flags=%b, CondEx=%b", Opcode, Flags, CondEx);
        if (CondEx == 1) $display("Test 5 Passed");
        else $display("Test 5 Failed");

        // Test 6: Undefined condition (Opcode: 000000)
        Opcode = 6'b000000;
        Flags = 4'b0000;
        #10;
        $display("Test 6: Undefined Condition | Opcode=%b, Flags=%b, CondEx=%b", Opcode, Flags, CondEx);
        if (CondEx == 1) $display("Test 6 Passed");
        else $display("Test 6 Failed");

        $display("\nCondition Checker tests completed.");
        $finish;
    end

endmodule
