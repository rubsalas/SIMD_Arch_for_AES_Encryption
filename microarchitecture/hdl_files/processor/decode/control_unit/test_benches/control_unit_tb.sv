module control_unit_tb;

    // Testbench signals
    reg [5:0] Opcode;
    reg [2:0] Func;
    reg [4:0] Rd;

    wire PCSrc;
    wire RegWrite;
    wire RegWriteV;
    wire MemtoReg;
    wire MemWrite;
    wire [2:0] ALUControl;
    wire ALUSel;
    wire Branch;
    wire ALUSrc;
    wire MemSrc;
    wire [1:0] FlagWrite;
    wire [1:0] ImmSrc;
    wire [1:0] RegSrc;
    wire [1:0] MemData;
    wire Stuck;

    // Instantiate the control_unit module
    control_unit uut (
        .Opcode(Opcode),
        .Func(Func),
        .Rd(Rd),
        .PCSrc(PCSrc),
        .RegWrite(RegWrite),
        .RegWriteV(RegWriteV),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSel(ALUSel),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .MemSrc(MemSrc),
        .FlagWrite(FlagWrite),
        .ImmSrc(ImmSrc),
        .RegSrc(RegSrc),
        .MemData(MemData),
        .Stuck(Stuck)
    );

    // Test sequence
    initial begin
        $display("Starting Control Unit tests...\n");

        // Test 1: Scalar Add (Opcode: 000000, Func: 000)
        Opcode = 6'b000000;
        Func = 3'b000;
        Rd = 5'b00001;
        #10;
        $display("Test 1: Scalar Add | Opcode=%b, Func=%b, PCSrc=%b, RegWrite=%b, ALUControl=%b", 
                  Opcode, Func, PCSrc, RegWrite, ALUControl);
        if (RegWrite == 1 && ALUControl == 3'b000) $display("Test 1 Passed");
        else $display("Test 1 Failed");

        // Test 2: Vector Add (Opcode: 100000, Func: 000)
        Opcode = 6'b100000;
        Func = 3'b000;
        Rd = 5'b00010;
        #10;
        $display("Test 2: Vector Add | Opcode=%b, Func=%b, PCSrc=%b, RegWriteV=%b, ALUControl=%b", 
                  Opcode, Func, PCSrc, RegWriteV, ALUControl);
        if (RegWriteV == 1 && ALUControl == 3'b000) $display("Test 2 Passed");
        else $display("Test 2 Failed");

        // Test 3: Branch (Opcode: 001100)
        Opcode = 6'b001100;
        Func = 3'bxxx;
        Rd = 5'b00011;
        #10;
        $display("Test 3: Branch | Opcode=%b, PCSrc=%b, Branch=%b, ALUControl=%b", 
                  Opcode, PCSrc, Branch, ALUControl);
        if (Branch == 1 && ALUControl == 3'b001) $display("Test 3 Passed");
        else $display("Test 3 Failed");

        // Test 4: Scalar Load (Opcode: 011001)
        Opcode = 6'b011001;
        Func = 3'bxxx;
        Rd = 5'b00100;
        #10;
        $display("Test 4: Scalar Load | Opcode=%b, MemtoReg=%b, MemWrite=%b, ALUSrc=%b", 
                  Opcode, MemtoReg, MemWrite, ALUSrc);
        if (MemtoReg == 1 && MemWrite == 0 && ALUSrc == 1) $display("Test 4 Passed");
        else $display("Test 4 Failed");

        // Test 5: Scalar Store (Opcode: 011000)
        Opcode = 6'b011000;
        Func = 3'bxxx;
        Rd = 5'b00101;
        #10;
        $display("Test 5: Scalar Store | Opcode=%b, MemWrite=%b, ALUSrc=%b", 
                  Opcode, MemWrite, ALUSrc);
        if (MemWrite == 1 && ALUSrc == 1) $display("Test 5 Passed");
        else $display("Test 5 Failed");

        // Test 6: Vector Store (Opcode: 111000)
        Opcode = 6'b111000;
        Func = 3'bxxx;
        Rd = 5'b00110;
        #10;
        $display("Test 6: Vector Store | Opcode=%b, MemWrite=%b, MemSrc=%b, ALUSrc=%b", 
                  Opcode, MemWrite, MemSrc, ALUSrc);
        if (MemWrite == 1 && MemSrc == 1 && ALUSrc == 1) $display("Test 6 Passed");
        else $display("Test 6 Failed");

        // Test 7: Default Case
        Opcode = 6'b111111;
        Func = 3'bxxx;
        Rd = 5'b11111;
        #10;
        $display("Test 7: Default Case | Opcode=%b, Stuck=%b", Opcode, Stuck);
        if (Stuck == 0) $display("Test 7 Passed");
        else $display("Test 7 Failed");

        $display("\nControl Unit tests completed.");
        $finish;
    end

endmodule
