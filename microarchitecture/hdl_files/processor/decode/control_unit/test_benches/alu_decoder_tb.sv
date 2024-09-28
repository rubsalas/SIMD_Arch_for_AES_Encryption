/*
Alu Decoder testbench 
Date: 20/03/24
*/

module alu_decoder_tb;

    // Testbench signals
    reg [5:0] Opcode;
    reg [2:0] Func;
    reg ALUOp;
    wire [2:0] ALUControl;

    // Instantiate the alu_decoder module
    alu_decoder uut (
        .Opcode(Opcode),
        .Func(Func),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    // Test sequence
    initial begin
        $display("Starting ALU Decoder tests...\n");

        // Test 1: Scalar Add (Opcode: 000000, Func: 000, ALUOp: 1)
        Opcode = 6'b000000;
        Func = 3'b000;
        ALUOp = 1;
        #10;
        $display("Test 1: Scalar Add | Opcode=%b, Func=%b, ALUControl=%b", Opcode, Func, ALUControl);
        if (ALUControl == 3'b000) $display("Test 1 Passed");
        else $display("Test 1 Failed");

        // Test 2: Scalar Subtract (Opcode: 000000, Func: 001, ALUOp: 1)
        Opcode = 6'b000000;
        Func = 3'b001;
        ALUOp = 1;
        #10;
        $display("Test 2: Scalar Subtract | Opcode=%b, Func=%b, ALUControl=%b", Opcode, Func, ALUControl);
        if (ALUControl == 3'b001) $display("Test 2 Passed");
        else $display("Test 2 Failed");

        // Test 3: Vector Add (Opcode: 100000, Func: 000, ALUOp: 1)
        Opcode = 6'b100000;
        Func = 3'b000;
        ALUOp = 1;
        #10;
        $display("Test 3: Vector Add | Opcode=%b, Func=%b, ALUControl=%b", Opcode, Func, ALUControl);
        if (ALUControl == 3'b000) $display("Test 3 Passed");
        else $display("Test 3 Failed");

        // Test 4: Vector Multiply (Opcode: 100000, Func: 010, ALUOp: 1)
        Opcode = 6'b100000;
        Func = 3'b010;
        ALUOp = 1;
        #10;
        $display("Test 4: Vector Multiply | Opcode=%b, Func=%b, ALUControl=%b", Opcode, Func, ALUControl);
        if (ALUControl == 3'b010) $display("Test 4 Passed");
        else $display("Test 4 Failed");

        // Test 5: Immediate Add (Opcode: 001000, ALUOp: 1)
        Opcode = 6'b001000;
        Func = 3'bxxx; // Doesn't matter for immediate
        ALUOp = 1;
        #10;
        $display("Test 5: Immediate Add | Opcode=%b, ALUControl=%b", Opcode, ALUControl);
        if (ALUControl == 3'b000) $display("Test 5 Passed");
        else $display("Test 5 Failed");

        // Test 6: Immediate Multiply (Opcode: 001010, ALUOp: 1)
        Opcode = 6'b001010;
        Func = 3'bxxx; // Doesn't matter for immediate
        ALUOp = 1;
        #10;
        $display("Test 6: Immediate Multiply | Opcode=%b, ALUControl=%b", Opcode, ALUControl);
        if (ALUControl == 3'b010) $display("Test 6 Passed");
        else $display("Test 6 Failed");

        // Test 7: Branch (Opcode: 000100, ALUOp: 1)
        Opcode = 6'b000100;
        Func = 3'bxxx; // Doesn't matter for branch
        ALUOp = 1;
        #10;
        $display("Test 7: Branch | Opcode=%b, ALUControl=%b", Opcode, ALUControl);
        if (ALUControl == 3'b001) $display("Test 7 Passed");
        else $display("Test 7 Failed");

        // Test 8: ALUOp = 0 (Default Add)
        Opcode = 6'b000000;
        Func = 3'bxxx; // Doesn't matter when ALUOp is 0
        ALUOp = 0;
        #10;
        $display("Test 8: Default Add when ALUOp=0 | ALUControl=%b", ALUControl);
        if (ALUControl == 3'b000) $display("Test 8 Passed");
        else $display("Test 8 Failed");

        $display("\nALU Decoder tests completed.");
        $finish;
    end

endmodule
