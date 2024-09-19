module main_decoder_tb;

    // Testbench signals
    reg [5:0] Opcode;
    reg [2:0] Func;

    wire Branch;
    wire [1:0] RegSrc;
    wire RegW;
    wire RegWV;
    wire ALUOp;
    wire MemW;
    wire MemSrc;
    wire MemtoReg;
    wire ALUSrc;
    wire [1:0] ImmSrc;
    wire [1:0] MemData;

    // Instantiate the main_decoder module
    main_decoder uut (
        .Opcode(Opcode),
        .Func(Func),
        .Branch(Branch),
        .RegSrc(RegSrc),
        .RegW(RegW),
        .RegWV(RegWV),
        .ALUOp(ALUOp),
        .MemW(MemW),
        .MemSrc(MemSrc),
        .MemtoReg(MemtoReg),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .MemData(MemData)
    );

    // Test sequence
    initial begin
        $display("Starting Main Decoder tests...\n");

        // Test 1: Scalar Arithmetic Operation (Opcode: 000000, Func: 000)
        Opcode = 6'b000000;
        Func = 3'b000;
        #10;
        $display("Test 1: Scalar Arithmetic | Opcode=%b, Func=%b, RegW=%b, ALUOp=%b, MemW=%b", 
                  Opcode, Func, RegW, ALUOp, MemW);
        if (RegW == 1 && ALUOp == 1 && MemW == 0) $display("Test 1 Passed");
        else $display("Test 1 Failed");

        // Test 2: Scalar Shift Left (Opcode: 000000, Func: 011)
        Opcode = 6'b000000;
        Func = 3'b011;
        #10;
        $display("Test 2: Scalar Shift Left | Opcode=%b, Func=%b, RegW=%b, ALUSrc=%b, ImmSrc=%b", 
                  Opcode, Func, RegW, ALUSrc, ImmSrc);
        if (RegW == 1 && ALUSrc == 1 && ImmSrc == 2'b11) $display("Test 2 Passed");
        else $display("Test 2 Failed");

        // Test 3: Vector Arithmetic Operation (Opcode: 100000, Func: 000)
        Opcode = 6'b100000;
        Func = 3'b000;
        #10;
        $display("Test 3: Vector Arithmetic | Opcode=%b, Func=%b, RegWV=%b, ALUOp=%b", 
                  Opcode, Func, RegWV, ALUOp);
        if (RegWV == 1 && ALUOp == 1) $display("Test 3 Passed");
        else $display("Test 3 Failed");

        // Test 4: Scalar Immediate Add (Opcode: 001000, Func doesn't matter)
        Opcode = 6'b001000;
        Func = 3'bxxx;
        #10;
        $display("Test 4: Scalar Immediate Add | Opcode=%b, RegW=%b, ALUSrc=%b, ImmSrc=%b", 
                  Opcode, RegW, ALUSrc, ImmSrc);
        if (RegW == 1 && ALUSrc == 1 && ImmSrc == 2'b00) $display("Test 4 Passed");
        else $display("Test 4 Failed");

        // Test 5: Scalar Load (Opcode: 011001, Func doesn't matter)
        Opcode = 6'b011001;
        Func = 3'bxxx;
        #10;
        $display("Test 5: Scalar Load | Opcode=%b, MemW=%b, MemtoReg=%b, ALUSrc=%b", 
                  Opcode, MemW, MemtoReg, ALUSrc);
        if (MemW == 0 && MemtoReg == 1 && ALUSrc == 1) $display("Test 5 Passed");
        else $display("Test 5 Failed");

        // Test 6: Vector Store (Opcode: 111000, Func doesn't matter)
        Opcode = 6'b111000;
        Func = 3'bxxx;
        #10;
        $display("Test 6: Vector Store | Opcode=%b, MemW=%b, MemSrc=%b, ALUSrc=%b", 
                  Opcode, MemW, MemSrc, ALUSrc);
        if (MemW == 1 && MemSrc == 1 && ALUSrc == 1) $display("Test 6 Passed");
        else $display("Test 6 Failed");

        // Test 7: Branch (Opcode: 001100, Func doesn't matter)
        Opcode = 6'b001100;
        Func = 3'bxxx;
        #10;
        $display("Test 7: Branch | Opcode=%b, Branch=%b, ALUOp=%b", 
                  Opcode, Branch, ALUOp);
        if (Branch == 1 && ALUOp == 1) $display("Test 7 Passed");
        else $display("Test 7 Failed");

        // Test 8: Default Case (Opcode: 111111, Func doesn't matter)
        Opcode = 6'b111111;
        Func = 3'bxxx;
        #10;
        $display("Test 8: Default Case | Opcode=%b, Branch=%b, RegW=%b, ALUOp=%b", 
                  Opcode, Branch, RegW, ALUOp);
        if (Branch === 1'bx && RegW === 1'bx && ALUOp === 1'bx) $display("Test 8 Passed");
        else $display("Test 8 Failed");

        $display("\nMain Decoder tests completed.");
        $finish;
    end

endmodule
