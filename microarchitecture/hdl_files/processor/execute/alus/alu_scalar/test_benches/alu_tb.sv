/*
Test bench for ALU module
Date: 31/08/24
Approved
*/
module alu_tb;

    timeunit 1ps;
    timeprecision 1ps;

    parameter N = 32;

    logic [N-1:0] A;
    logic [N-1:0] B;
    logic [2:0] ALUControl;

    logic [N-1:0] result;
    logic [3:0] flags; // {N_flag, Z_flag, C_flag, V_flag}
    
    // alu unit under testing
    alu #(.N(N)) uut (.A(A),
                      .B(B),
                      .ALUControl(ALUControl),
                      .result(result),
                      .flags(flags));

    initial begin
        $display("ALU test bench:\n");

        A = 32'b0;
        B = 32'b0;
        ALUControl = 3'b000; // Default: Addition
    end

    initial begin
        // Test 1: Addition (A + B)
        $display("\nTest 1: Addition (A + B)");
        A = 32'd10; B = 32'd20; ALUControl = 3'b000; // Add

        #100;

        $display("A=%b B=%b ALUControl=%b | result=%b flags=%b",
                  A, B, ALUControl, result, flags);
        assert((result == 32'd30) && (flags == 4'b0000))
        else $error("Failed Addition Test: A=10, B=20, result=%d, flags=%b\n", result, flags);

        // Test 2: Subtraction (A - B)
        $display("\nTest 2: Subtraction (A - B)");
        A = 32'd30; B = 32'd10; ALUControl = 3'b001; // Subtract

        #100;

        $display("A=%b B=%b ALUControl=%b | result=%b flags=%b",
                  A, B, ALUControl, result, flags);
        assert((result == 32'd20) && (flags == 4'b0000))
        else $error("Failed Subtraction Test: A=30, B=10, result=%d, flags=%b\n", result, flags);

        // Test 3: Multiplication (A * B)
        $display("Test 3: Multiplication (A * B)");
        A = 32'd4; B = 32'd5; ALUControl = 3'b010; // Multiply

        #100;

        $display("A=%b B=%b ALUControl=%b | result=%b flags=%b",
                  A, B, ALUControl, result, flags);
        assert((result == 32'd20) && (flags == 4'b0000))
        else $error("Failed Multiplication Test: A=4, B=5, result=%d, flags=%b\n", result, flags);

        // Test 4: Shift Left Logical (A << B)
        $display("Test 4: Shift Left Logical (A << B)");
        A = 32'd1; B = 32'd2; ALUControl = 3'b011; // Shift Left Logical

        #100;

        $display("A=%b B=%b ALUControl=%b | result=%b flags=%b",
                  A, B, ALUControl, result, flags);
        assert((result == 32'd4) && (flags == 4'b0000))
        else $error("Failed Shift Left Logical Test: A=1, B=2, result=%d, flags=%b\n", result, flags);

        // Test 5: Shift Right Logical (A >> B)
        $display("Test 5: Shift Right Logical (A >> B)");
        A = 32'd4; B = 32'd1; ALUControl = 3'b111; // Shift Right Logical

        #100;

        $display("A=%b B=%b ALUControl=%b | result=%b flags=%b",
                  A, B, ALUControl, result, flags);
        assert((result == 32'd2) && (flags == 4'b0000))
        else $error("Failed Shift Right Logical Test: A=4, B=1, result=%d, flags=%b\n", result, flags);

        // Test 6: Zero Result (Addition)
        $display("Test 6: Zero Result (A + (-B))");
        A = 32'd1; B = -32'd1; ALUControl = 3'b000; // Add A + (-B)

        #100;

        $display("A=%b B=%b ALUControl=%b | result=%b flags=%b",
                  A, B, ALUControl, result, flags);
        assert((result == 32'd0) && (flags == 4'b0110)) // Z = 1, C = 1
        else $error("Failed Zero Flag Test (Addition): A=1, B=-1, result=%d, flags=%b\n", result, flags);

        // Test 7: Negative Result (Subtraction)
        $display("Test 7: Negative Result (A - B)");
        A = 32'd10; B = 32'd20; ALUControl = 3'b001; // Subtract

        #100;

        $display("A=%b B=%b ALUControl=%b | result=%b flags=%b",
                  A, B, ALUControl, result, flags);
        assert((result == -32'd10) && (flags == 4'b1000)) // N = 1
        else $error("Failed Negative Flag Test: A=10, B=20, result=%d, flags=%b\n", result, flags);

        // Test 8: Overflow (Addition)
        $display("Test 8: Overflow (A + B)");
        A = 32'h7FFFFFFF; B = 32'd1; ALUControl = 3'b000; // Add

        #100;
        
        $display("A=%b B=%b ALUControl=%b | result=%b flags=%b",
                  A, B, ALUControl, result, flags);
        assert((result == 32'h80000000) && (flags == 4'b1001)) // V = 1, N = 1
        else $error("Failed Overflow Flag Test: A=2^31-1, B=1, result=%h, flags=%b\n", result, flags);

        $display("ALU test completed successfully.");
        $finish;
    end

endmodule
