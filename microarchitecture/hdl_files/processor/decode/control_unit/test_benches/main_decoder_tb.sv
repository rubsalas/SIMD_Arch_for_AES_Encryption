/*
Main Decoder testbench 
Date: 20/03/24
*/

module main_decoder_tb;

    // Testbench signals
    reg [5:0] Opcode;
    reg [2:0] Func;
    
    wire RegW;
    wire RegWV;
    wire MemtoReg;
    wire MemW;
    wire MemSrc;
    wire MemData;
    wire MemDataV;
    wire VecData;
    wire Branch;
    wire ALUOp;
    wire ALUSrc;
    wire [1:0] RegSrc;
    wire [1:0] ImmSrc;

    // Instantiate the main_decoder module
    main_decoder uut (
        .Opcode(Opcode),
        .Func(Func),
        .RegW(RegW),
        .RegWV(RegWV),
        .MemtoReg(MemtoReg),
        .MemW(MemW),
        .MemSrc(MemSrc),
        .MemData(MemData),
        .MemDataV(MemDataV),
        .VecData(VecData),
        .Branch(Branch),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RegSrc(RegSrc),
        .ImmSrc(ImmSrc)
    );

    // Test sequence
    initial begin
        $display("Starting Main Decoder tests...\n");

        // Test 1: Scalar Arithmetic (Opcode: 000000, Func: 011) -> sll or slr
        Opcode = 6'b000000;
        Func = 3'b011;
        #10;
        $display("Test 1: Scalar Arithmetic (sll/slr) | Opcode=%b, Func=%b, RegW=%b, ALUSrc=%b, ImmSrc=%b", 
                  Opcode, Func, RegW, ALUSrc, ImmSrc);
        if (RegW == 1 && ALUSrc == 1 && ImmSrc == 2'b11) $display("Test 1 Passed");
        else $display("Test 1 Failed");

        // Test 2: Scalar Arithmetic (add) (Opcode: 000000, Func: 000)
        Opcode = 6'b000000;
        Func = 3'b000;
        #10;
        $display("Test 2: Scalar Arithmetic (add) | Opcode=%b, Func=%b, RegW=%b, ALUOp=%b, MemW=%b", 
                  Opcode, Func, RegW, ALUOp, MemW);
        if (RegW == 1 && ALUOp == 1 && MemW == 0) $display("Test 2 Passed");
        else $display("Test 2 Failed");

        // Test 3: Vector Arithmetic (Opcode: 100000, Func: doesn't matter)
        Opcode = 6'b100000;
        Func = 3'bxxx;
        #10;
        $display("Test 3: Vector Arithmetic | Opcode=%b, Func=%b, RegWV=%b, MemtoReg=%b", 
                  Opcode, Func, RegWV, MemtoReg);
        if (RegWV == 1 && MemtoReg == 1) $display("Test 3 Passed");
        else $display("Test 3 Failed");

        // Test 4: Scalar Immediate Arithmetic (Opcode: 001000)
        Opcode = 6'b001000;
        Func = 3'bxxx;
        #10;
        $display("Test 4: Scalar Immediate Add | Opcode=%b, ALUSrc=%b, ImmSrc=%b", 
                  Opcode, ALUSrc, ImmSrc);
        if (ALUSrc == 1 && ImmSrc == 2'b00) $display("Test 4 Passed");
        else $display("Test 4 Failed");

        // Test 5: Scalar Store (Opcode: 011000)
        Opcode = 6'b011000;
        Func = 3'bxxx;
        #10;
        $display("Test 5: Scalar Store | Opcode=%b, MemW=%b, MemSrc=%b", 
                  Opcode, MemW, MemSrc);
        if (MemW == 1 && MemSrc == 0) $display("Test 5 Passed");
        else $display("Test 5 Failed");

        // Test 6: Scalar Load (Opcode: 011001)
        Opcode = 6'b011001;
        Func = 3'bxxx;
        #10;
        $display("Test 6: Scalar Load | Opcode=%b, RegW=%b, MemtoReg=%b", 
                  Opcode, RegW, MemtoReg);
        if (RegW == 1 && MemtoReg == 1) $display("Test 6 Passed");
        else $display("Test 6 Failed");

        // Test 7: Vector Store (Opcode: 111000)
        Opcode = 6'b111000;
        Func = 3'bxxx;
        #10;
        $display("Test 7: Vector Store | Opcode=%b, MemW=%b, MemSrc=%b", 
                  Opcode, MemW, MemSrc);
        if (MemW == 1 && MemSrc == 1) $display("Test 7 Passed");
        else $display("Test 7 Failed");

        // Test 8: Vector Load (Opcode: 111001)
        Opcode = 6'b111001;
        Func = 3'bxxx;
        #10;
        $display("Test 8: Vector Load | Opcode=%b, RegWV=%b, MemtoReg=%b", 
                  Opcode, RegWV, MemtoReg);
        if (RegWV == 1 && MemtoReg == 1) $display("Test 8 Passed");
        else $display("Test 8 Failed");

        // Test 9: Branch (beq) (Opcode: 001100)
        Opcode = 6'b001100;
        Func = 3'bxxx;
        #10;
        $display("Test 9: Branch (beq) | Opcode=%b, Branch=%b, ALUOp=%b", 
                  Opcode, Branch, ALUOp);
        if (Branch == 1 && ALUOp == 1) $display("Test 9 Passed");
        else $display("Test 9 Failed");

        // Test 10: Branch (bgt) (Opcode: 001101)
        Opcode = 6'b001101;
        Func = 3'bxxx;
        #10;
        $display("Test 10: Branch (bgt) | Opcode=%b, Branch=%b, ALUOp=%b", 
                  Opcode, Branch, ALUOp);
        if (Branch == 1 && ALUOp == 1) $display("Test 10 Passed");
        else $display("Test 10 Failed");

        // Test 11: Jump (Opcode: 000100)
        Opcode = 6'b000100;
        Func = 3'bxxx;
        #10;
        $display("Test 11: Jump | Opcode=%b, Branch=%b", Opcode, Branch);
        if (Branch == 1) $display("Test 11 Passed");
        else $display("Test 11 Failed");

        $display("\nMain Decoder tests completed.");
        $finish;
    end

endmodule
