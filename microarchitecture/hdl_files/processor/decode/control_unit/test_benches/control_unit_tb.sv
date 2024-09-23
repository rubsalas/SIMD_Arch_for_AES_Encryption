/*
Control Unit testbench 
Date: 20/03/24
*/

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
    wire MemSrc;
    wire MemData;
    wire MemDataV;
    wire VecData;
    wire [1:0] InstrSel;
    wire [2:0] ALUControl;
    wire Branch;
    wire ALUSrc;
    wire [1:0] RegSrc;
    wire [1:0] ImmSrc;

    wire ALUOp;

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
        .MemSrc(MemSrc),
        .MemData(MemData),
        .MemDataV(MemDataV),
        .VecData(VecData),
        .InstrSel(InstrSel),
        .ALUControl(ALUControl),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .RegSrc(RegSrc),
        .ImmSrc(ImmSrc)
    );

    assign ALUOp = uut.wAluOp;

    // Test sequence
    initial begin
        $display("Starting Control Unit tests...\n");

        // Test 1: Scalar Arithmetic (Opcode: 000000, Func: 000, Rd: 00001)
        Opcode = 6'b000000;
        Func = 3'b000;
        Rd = 5'b00001;
        #10;
        $display("Test 1: Scalar Arithmetic (add) | Opcode=%b, Func=%b, Rd=%b, PCSrc=%b, RegWrite=%b, ALUControl=%b", 
                  Opcode, Func, Rd, PCSrc, RegWrite, ALUControl);
        if (RegWrite == 1 && ALUControl == 3'b000) $display("Test 1 Passed");
        else $display("Test 1 Failed");

        // Test 2: Vector Arithmetic (Opcode: 100000, Func: 001, Rd: 00010)
        Opcode = 6'b100000;
        Func = 3'b001;
        Rd = 5'b00010;
        #10;
        $display("Test 2: Vector Arithmetic | Opcode=%b, Func=%b, Rd=%b, RegWriteV=%b, ALUControl=%b", 
                  Opcode, Func, Rd, RegWriteV, ALUControl);
        if (RegWriteV == 1 && ALUControl == 3'b001) $display("Test 2 Passed");
        else $display("Test 2 Failed");

        // Test 3: Scalar Immediate Arithmetic (Opcode: 001000, Func: xxx, Rd: 00011)
        Opcode = 6'b001000;
        Func = 3'bxxx;
        Rd = 5'b00011;
        #10;
        $display("Test 3: Scalar Immediate Add | Opcode=%b, Func=%b, Rd=%b, ALUSrc=%b, ImmSrc=%b", 
                  Opcode, Func, Rd, ALUSrc, ImmSrc);
        if (ALUSrc == 1 && ImmSrc == 2'b00) $display("Test 3 Passed");
        else $display("Test 3 Failed");

        // Test 4: Scalar Load (Opcode: 011001, Func: xxx, Rd: 00100)
        Opcode = 6'b011001;
        Func = 3'bxxx;
        Rd = 5'b00100;
        #10;
        $display("Test 4: Scalar Load | Opcode=%b, Func=%b, Rd=%b, RegWrite=%b, MemtoReg=%b", 
                  Opcode, Func, Rd, RegWrite, MemtoReg);
        if (RegWrite == 1 && MemtoReg == 1) $display("Test 4 Passed");
        else $display("Test 4 Failed");

        // Test 5: Scalar Store (Opcode: 011000, Func: xxx, Rd: 00101)
        Opcode = 6'b011000;
        Func = 3'bxxx;
        Rd = 5'b00101;
        #10;
        $display("Test 5: Scalar Store | Opcode=%b, Func=%b, Rd=%b, MemWrite=%b, MemSrc=%b", 
                  Opcode, Func, Rd, MemWrite, MemSrc);
        if (MemWrite == 1 && MemSrc == 0) $display("Test 5 Passed");
        else $display("Test 5 Failed");

        // Test 6: Vector Store (Opcode: 111000, Func: xxx, Rd: 00110)
        Opcode = 6'b111000;
        Func = 3'bxxx;
        Rd = 5'b00110;
        #10;
        $display("Test 6: Vector Store | Opcode=%b, Func=%b, Rd=%b, MemWrite=%b, MemSrc=%b", 
                  Opcode, Func, Rd, MemWrite, MemSrc);
        if (MemWrite == 1 && MemSrc == 1) $display("Test 6 Passed");
        else $display("Test 6 Failed");

        // Test 7: Vector Load (Opcode: 111001, Func: xxx, Rd: 00111)
        Opcode = 6'b111001;
        Func = 3'bxxx;
        Rd = 5'b00111;
        #10;
        $display("Test 7: Vector Load | Opcode=%b, Func=%b, Rd=%b, RegWriteV=%b, MemtoReg=%b", 
                  Opcode, Func, Rd, RegWriteV, MemtoReg);
        if (RegWriteV == 1 && MemtoReg == 1) $display("Test 7 Passed");
        else $display("Test 7 Failed");

        // Test 8: Branch (beq) (Opcode: 001100, Func: xxx, Rd: 01000)
        Opcode = 6'b001100;
        Func = 3'bxxx;
        Rd = 5'b01000;
        #10;
        $display("Test 8: Branch (beq) | Opcode=%b, Func=%b, Rd=%b, Branch=%b, ALUOp=%b", 
                  Opcode, Func, Rd, Branch, ALUOp);
        if (Branch == 1 && ALUOp == 1) $display("Test 8 Passed");
        else $display("Test 8 Failed");

        // Test 9: Branch (bgt) (Opcode: 001101, Func: xxx, Rd: 01001)
        Opcode = 6'b001101;
        Func = 3'bxxx;
        Rd = 5'b01001;
        #10;
        $display("Test 9: Branch (bgt) | Opcode=%b, Func=%b, Rd=%b, Branch=%b, ALUOp=%b", 
                  Opcode, Func, Rd, Branch, ALUOp);
        if (Branch == 1 && ALUOp == 1) $display("Test 9 Passed");
        else $display("Test 9 Failed");

        // Test 10: Jump (Opcode: 000100, Func: xxx, Rd: 01010)
        Opcode = 6'b000100;
        Func = 3'bxxx;
        Rd = 5'b01010;
        #10;
        $display("Test 10: Jump | Opcode=%b, Func=%b, Rd=%b, Branch=%b", Opcode, Func, Rd, Branch);
        if (Branch == 1) $display("Test 10 Passed");
        else $display("Test 10 Failed");

        $display("\nControl Unit tests completed.");
        $finish;
    end

endmodule
