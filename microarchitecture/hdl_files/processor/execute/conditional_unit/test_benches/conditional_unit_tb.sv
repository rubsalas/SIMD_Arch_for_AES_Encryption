module conditional_unit_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg PCSrcE;
    reg RegWriteE;
    reg MemWriteE;
    reg BranchE;
    reg [1:0] FlagWriteE;
    reg [5:0] Opcode;
    reg [3:0] FlagsE;
    reg [3:0] ALUFlags;

    wire [3:0] ALUFlagsD;
    wire BranchTakenE;
    wire PCSrcM;
    wire RegWriteM;
    wire MemWriteM;

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
        .FlagsE(FlagsE),
        .ALUFlags(ALUFlags),
        .ALUFlagsD(ALUFlagsD),
        .BranchTakenE(BranchTakenE),
        .PCSrcM(PCSrcM),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        $display("Starting Conditional Unit tests...\n");

        // Initialize signals
        clk = 0;
        rst = 1;
        PCSrcE = 0;
        RegWriteE = 0;
        MemWriteE = 0;
        BranchE = 0;
        FlagWriteE = 2'b00;
        Opcode = 6'b000000;
        FlagsE = 4'b0000;
        ALUFlags = 4'b0000;

        // Deassert reset
        #10;
        rst = 0;

        // Test 1: Branch is taken (Opcode: 001100, BranchE = 1, Z_flag = 1)
        $display("Test 1: Branch is taken | Opcode=%b, Z_flag=1", Opcode);
        PCSrcE = 1;
        BranchE = 1;
        Opcode = 6'b001100;
        FlagsE = 4'b0100; // Z_flag = 1
        RegWriteE = 1;
        MemWriteE = 1;
        #10;
        $display("BranchTakenE=%b, PCSrcM=%b, RegWriteM=%b, MemWriteM=%b", BranchTakenE, PCSrcM, RegWriteM, MemWriteM);
        if (BranchTakenE == 1 && PCSrcM == 1 && RegWriteM == 1 && MemWriteM == 1) $display("Test 1 Passed");
        else $display("Test 1 Failed");

        // Test 2: Branch is not taken (Opcode: 001100, BranchE = 1, Z_flag = 0)
        $display("Test 2: Branch is not taken | Opcode=%b, Z_flag=0", Opcode);
        FlagsE = 4'b0000; // Z_flag = 0
        #10;
        $display("BranchTakenE=%b, PCSrcM=%b, RegWriteM=%b, MemWriteM=%b", BranchTakenE, PCSrcM, RegWriteM, MemWriteM);
        if (BranchTakenE == 0 && PCSrcM == 0 && RegWriteM == 0 && MemWriteM == 0) $display("Test 2 Passed");
        else $display("Test 2 Failed");

        // Test 3: GT condition (Opcode: 001110, BranchE = 1, Z_flag = 0, N_flag = 0, V_flag = 0)
        $display("Test 3: GT Condition | Opcode=%b, Z_flag=0, N_flag=0, V_flag=0", Opcode);
        Opcode = 6'b001110;
        FlagsE = 4'b0000; // Z_flag = 0, N_flag = 0, V_flag = 0
        #10;
        $display("BranchTakenE=%b, PCSrcM=%b, RegWriteM=%b, MemWriteM=%b", BranchTakenE, PCSrcM, RegWriteM, MemWriteM);
        if (BranchTakenE == 1 && PCSrcM == 1 && RegWriteM == 1 && MemWriteM == 1) $display("Test 3 Passed");
        else $display("Test 3 Failed");

        // Test 4: Unconditional (Opcode: 001111, BranchE = 1)
        $display("Test 4: Unconditional Branch | Opcode=%b", Opcode);
        Opcode = 6'b001111;
        #10;
        $display("BranchTakenE=%b, PCSrcM=%b, RegWriteM=%b, MemWriteM=%b", BranchTakenE, PCSrcM, RegWriteM, MemWriteM);
        if (BranchTakenE == 1 && PCSrcM == 1 && RegWriteM == 1 && MemWriteM == 1) $display("Test 4 Passed");
        else $display("Test 4 Failed");

        // Test 5: No branch, no condition met (Opcode: 000000, BranchE = 0)
        $display("Test 5: No branch | Opcode=%b, BranchE=0", Opcode);
        Opcode = 6'b000000;
        BranchE = 0;
        #10;
        $display("BranchTakenE=%b, PCSrcM=%b, RegWriteM=%b, MemWriteM=%b", BranchTakenE, PCSrcM, RegWriteM, MemWriteM);
        if (BranchTakenE == 0 && PCSrcM == 0 && RegWriteM == 0 && MemWriteM == 0) $display("Test 5 Passed");
        else $display("Test 5 Failed");

        $display("\nConditional Unit tests completed.");
        $finish;
    end

endmodule
