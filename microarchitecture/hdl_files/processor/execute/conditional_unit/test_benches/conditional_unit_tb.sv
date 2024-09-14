/*
Condition Logic testbench 
Date: 13/09/24
NY Approved
*/  
module conditional_unit_tb;

    logic clk;
    logic rst;

    logic PCSrcE;
    logic RegWriteE;
    logic MemWriteE;
    logic BranchE;

    logic [1:0] FlagWriteE;
    logic [2:0] Opcode;
    logic [1:0] S;
    logic [3:0] FlagsE;
    logic [3:0] ALUFlags;

    logic [3:0] ALUFlagsD;
    logic BranchTakenE;
    logic PCSrcM;
    logic RegWriteM;
    logic MemWriteM;

    // Instantiate the conditional_unit module
    conditional_unit uut (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .BranchE(BranchE),
        .FlagWriteE(FlagWriteE),
        .Opcode(Opcode),
        .S(S),
        .FlagsE(FlagsE),
        .ALUFlags(ALUFlags),
        .ALUFlagsD(ALUFlagsD),
        .BranchTakenE(BranchTakenE),
        .PCSrcM(PCSrcM),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM)
    );

    // Clock generation
    always #50 clk = ~clk;

    // Test sequence
    initial begin
        $display("Conditional_unit testbench :\n");

        // Initialize signals
        clk = 0;
        rst = 0;
        PCSrcE = 0;
        RegWriteE = 0;
        MemWriteE = 0;
        BranchE = 0;
        FlagWriteE = 2'b00;
        Opcode = 3'b000;
        S = 2'b00;
        FlagsE = 4'b0000;
        ALUFlags = 4'b0000;

        // Monitor signals
        $monitor("Time: %t | Opcode=%b, FlagsE=%b, ALUFlags=%b, BranchTakenE=%b, PCSrcM=%b, RegWriteM=%b, MemWriteM=%b", 
                 $time, Opcode, FlagsE, ALUFlags, BranchTakenE, PCSrcM, RegWriteM, MemWriteM);

        // Start with reset
        rst = 1;
        #100;
        rst = 0;

        // Test 1: Unconditional operation, no flags
        $display("Test 1: Opcode: unconditional, no flags");
        Opcode = 3'b110;
        FlagsE = 4'b0000;
        PCSrcE = 1'b1;
        RegWriteE = 1'b1;
        MemWriteE = 1'b0;
        BranchE = 1'b0;
        FlagWriteE = 2'b00;
        S = 2'b11;
        #100;
        assert(PCSrcM == 1 && RegWriteM == 1 && MemWriteM == 0)
        else $fatal("Test 1 failed");

        // Test 2: Unconditional operation, N=0 Z=1 C=0 V=0
        $display("Test 2: Opcode: unconditional, N=0 Z=1 C=0 V=0");
        Opcode = 3'b110;
        FlagsE = 4'b0100;
        PCSrcE = 1'b1;
        RegWriteE = 1'b1;
        MemWriteE = 1'b0;
        BranchE = 1'b0;
        S = 2'b11;
        #100;
        assert(PCSrcM == 1 && RegWriteM == 1 && MemWriteM == 0)
        else $fatal("Test 2 failed");

        // Test 3: EQ condition, last flags: N=0 Z=1 C=0 V=0
        $display("Test 3: Opcode: EQ, last flags: N=0 Z=1 C=0 V=0");
        Opcode = 3'b011;
        FlagsE = 4'b0100;
        PCSrcE = 1'b1;
        RegWriteE = 1'b1;
        MemWriteE = 1'b1;
        S = 2'b00; // EQ condition
        #50;
        assert(BranchTakenE == 1 && PCSrcM == 1 && RegWriteM == 1 && MemWriteM == 1)
        else $fatal("Test 3 failed");

        // Test 4: EQ condition, last flags: N=0 Z=0 C=0 V=0
        $display("Test 4: Opcode: EQ, last flags N=0 Z=0 C=0 V=0");
        Opcode = 3'b011;
        FlagsE = 4'b0000;
        PCSrcE = 1'b1;
        RegWriteE = 1'b1;
        MemWriteE = 1'b0;
        S = 2'b00; // EQ condition
        #50;
        assert(BranchTakenE == 0 && PCSrcM == 0 && RegWriteM == 0 && MemWriteM == 0)
        else $fatal("Test 4 failed");

        // Test 5: NE condition, last flags N=0 Z=1 C=0 V=0
        $display("Test 5: Opcode: NE, last flags N=0 Z=1 C=0 V=0");
        Opcode = 3'b011;
        FlagsE = 4'b0100;
        PCSrcE = 1'b1;
        RegWriteE = 1'b1;
        MemWriteE = 1'b0;
        S = 2'b01; // NE condition
        #50;
        assert(BranchTakenE == 0 && PCSrcM == 0 && RegWriteM == 0 && MemWriteM == 0)
        else $fatal("Test 5 failed");

        // Test 6: NE condition, last flags N=0 Z=0 C=0 V=0
        $display("Test 6: Opcode: NE, last flags N=0 Z=0 C=0 V=0");
        Opcode = 3'b011;
        FlagsE = 4'b0000;
        PCSrcE = 1'b1;
        RegWriteE = 1'b1;
        MemWriteE = 1'b1;
        S = 2'b01; // NE condition
        #50;
        assert(BranchTakenE == 1 && PCSrcM == 1 && RegWriteM == 1 && MemWriteM == 1)
        else $fatal("Test 6 failed");

        $display("All tests completed successfully.");
        #1000;
        $finish;
    end

endmodule
