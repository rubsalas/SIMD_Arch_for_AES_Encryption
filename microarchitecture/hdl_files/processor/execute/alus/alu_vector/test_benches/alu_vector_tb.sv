/*
Test bench for ALU Vector module
Date: 13/09/24
Approved
*/
module alu_vector_tb;

    // Testbench signals
    logic [255:0] A, B;
    logic [2:0] ALUControl;
    logic [255:0] result;
    logic [31:0] flags;

    // Instantiate the ALU vector module
    alu_vector uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .result(result),
        .flags(flags)
    );

    initial begin
        $display("ALU Vector test bench:\n");

        A = 256'b0;
        B = 256'b0;
        ALUControl = 3'b000; // Default: Addition
    end

    initial begin
        // Test 1: Addition in SIMD style (8 lanes)
        $display("\nTest 1: SIMD Addition (8 lanes)");
        A = 256'h0000000100000002000000030000000400000005000000060000000700000008;
        B = 256'h0000000100000002000000030000000400000005000000060000000700000008;
        ALUControl = 3'b000; // Add
        #100;
        $display("Lane 0: A = %h, B = %h, result = %h, flags = %b", A[31:0], B[31:0], result[31:0], flags[3:0]);
        $display("Lane 1: A = %h, B = %h, result = %h, flags = %b", A[63:32], B[63:32], result[63:32], flags[7:4]);
        $display("Lane 2: A = %h, B = %h, result = %h, flags = %b", A[95:64], B[95:64], result[95:64], flags[11:8]);
        $display("Lane 3: A = %h, B = %h, result = %h, flags = %b", A[127:96], B[127:96], result[127:96], flags[15:12]);
        $display("Lane 4: A = %h, B = %h, result = %h, flags = %b", A[159:128], B[159:128], result[159:128], flags[19:16]);
        $display("Lane 5: A = %h, B = %h, result = %h, flags = %b", A[191:160], B[191:160], result[191:160], flags[23:20]);
        $display("Lane 6: A = %h, B = %h, result = %h, flags = %b", A[223:192], B[223:192], result[223:192], flags[27:24]);
        $display("Lane 7: A = %h, B = %h, result = %h, flags = %b", A[255:224], B[255:224], result[255:224], flags[31:28]);

        // Test 2: Subtraction in SIMD style (8 lanes)
        $display("\n\nTest 2: SIMD Subtraction (8 lanes)");
        A = 256'h0000000900000008000000070000000600000005000000040000000300000002;
        B = 256'h0000000100000002000000030000000400000005000000060000000700000008;
        ALUControl = 3'b001; // Subtract
        #100;
        $display("Lane 0: A = %h, B = %h, result = %h, flags = %b", A[31:0], B[31:0], result[31:0], flags[3:0]);
        $display("Lane 1: A = %h, B = %h, result = %h, flags = %b", A[63:32], B[63:32], result[63:32], flags[7:4]);
        $display("Lane 2: A = %h, B = %h, result = %h, flags = %b", A[95:64], B[95:64], result[95:64], flags[11:8]);
        $display("Lane 3: A = %h, B = %h, result = %h, flags = %b", A[127:96], B[127:96], result[127:96], flags[15:12]);
        $display("Lane 4: A = %h, B = %h, result = %h, flags = %b", A[159:128], B[159:128], result[159:128], flags[19:16]);
        $display("Lane 5: A = %h, B = %h, result = %h, flags = %b", A[191:160], B[191:160], result[191:160], flags[23:20]);
        $display("Lane 6: A = %h, B = %h, result = %h, flags = %b", A[223:192], B[223:192], result[223:192], flags[27:24]);
        $display("Lane 7: A = %h, B = %h, result = %h, flags = %b", A[255:224], B[255:224], result[255:224], flags[31:28]);

        // Test 3: Multiplication in SIMD style (8 lanes)
        $display("\n\nTest 3: SIMD Multiplication (8 lanes)");
        A = 256'h0000000100000002000000030000000400000005000000060000000700000008;
        B = 256'h0000000200000003000000040000000500000006000000070000000800000009;
        ALUControl = 3'b010; // Multiply
        #100;
        $display("Lane 0: A = %h, B = %h, result = %h, flags = %b", A[31:0], B[31:0], result[31:0], flags[3:0]);
        $display("Lane 1: A = %h, B = %h, result = %h, flags = %b", A[63:32], B[63:32], result[63:32], flags[7:4]);
        $display("Lane 2: A = %h, B = %h, result = %h, flags = %b", A[95:64], B[95:64], result[95:64], flags[11:8]);
        $display("Lane 3: A = %h, B = %h, result = %h, flags = %b", A[127:96], B[127:96], result[127:96], flags[15:12]);
        $display("Lane 4: A = %h, B = %h, result = %h, flags = %b", A[159:128], B[159:128], result[159:128], flags[19:16]);
        $display("Lane 5: A = %h, B = %h, result = %h, flags = %b", A[191:160], B[191:160], result[191:160], flags[23:20]);
        $display("Lane 6: A = %h, B = %h, result = %h, flags = %b", A[223:192], B[223:192], result[223:192], flags[27:24]);
        $display("Lane 7: A = %h, B = %h, result = %h, flags = %b", A[255:224], B[255:224], result[255:224], flags[31:28]);

        // Test 4: Shift Left Logical in SIMD style (8 lanes)
        $display("\n\nTest 4: SIMD Shift Left Logical (8 lanes)");
        A = 256'h0000000100000002000000030000000400000005000000060000000700000008;
        B = 256'h0000000100000001000000010000000100000001000000010000000100000001;
        ALUControl = 3'b011; // Shift Left Logical
        #100;
        $display("Lane 0: A = %h, B = %h, result = %h, flags = %b", A[31:0], B[31:0], result[31:0], flags[3:0]);
        $display("Lane 1: A = %h, B = %h, result = %h, flags = %b", A[63:32], B[63:32], result[63:32], flags[7:4]);
        $display("Lane 2: A = %h, B = %h, result = %h, flags = %b", A[95:64], B[95:64], result[95:64], flags[11:8]);
        $display("Lane 3: A = %h, B = %h, result = %h, flags = %b", A[127:96], B[127:96], result[127:96], flags[15:12]);
        $display("Lane 4: A = %h, B = %h, result = %h, flags = %b", A[159:128], B[159:128], result[159:128], flags[19:16]);
        $display("Lane 5: A = %h, B = %h, result = %h, flags = %b", A[191:160], B[191:160], result[191:160], flags[23:20]);
        $display("Lane 6: A = %h, B = %h, result = %h, flags = %b", A[223:192], B[223:192], result[223:192], flags[27:24]);
        $display("Lane 7: A = %h, B = %h, result = %h, flags = %b", A[255:224], B[255:224], result[255:224], flags[31:28]);

        // Test 5: Shift Right Logical in SIMD style (8 lanes)
        $display("\n\nTest 5: SIMD Shift Right Logical (8 lanes)");
        A = 256'h0000000800000007000000060000000500000004000000030000000200000001;
        B = 256'h1000000001000000001000000001000000001000000001000000001000000001;
        ALUControl = 3'b100; // Shift Right Logical
        #100;
        $display("Lane 0: A = %h, B = %h, result = %h, flags = %b", A[31:0], B[31:0], result[31:0], flags[3:0]);
        $display("Lane 1: A = %h, B = %h, result = %h, flags = %b", A[63:32], B[63:32], result[63:32], flags[7:4]);
        $display("Lane 2: A = %h, B = %h, result = %h, flags = %b", A[95:64], B[95:64], result[95:64], flags[11:8]);
        $display("Lane 3: A = %h, B = %h, result = %h, flags = %b", A[127:96], B[127:96], result[127:96], flags[15:12]);
        $display("Lane 4: A = %h, B = %h, result = %h, flags = %b", A[159:128], B[159:128], result[159:128], flags[19:16]);
        $display("Lane 5: A = %h, B = %h, result = %h, flags = %b", A[191:160], B[191:160], result[191:160], flags[23:20]);
        $display("Lane 6: A = %h, B = %h, result = %h, flags = %b", A[223:192], B[223:192], result[223:192], flags[27:24]);
        $display("Lane 7: A = %h, B = %h, result = %h, flags = %b", A[255:224], B[255:224], result[255:224], flags[31:28]);

        $display("\n\nALU vector SIMD tests completed.");
        $finish;
    end

endmodule
