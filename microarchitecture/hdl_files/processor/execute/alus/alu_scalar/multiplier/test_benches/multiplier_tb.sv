/*
Test bench for multiplier module.
Date: 31/08/24
Approved
*/
module multiplier_tb;

    timeunit 1ps;
    timeprecision 1ps;

    parameter N = 32;

    logic [N-1:0] A;
    logic [N-1:0] B;

    logic [N-1:0] R;
    logic N_flag, Z_flag, C_flag, V_flag;

    // multiplier unit under testing
    multiplier #(.N(N)) uut (.A(A),
                             .B(B),
                             .R(R),
                             .N_flag(N_flag),
                             .Z_flag(Z_flag),
                             .C_flag(C_flag),
                             .V_flag(V_flag));

    initial begin
        $display("Multiplier test bench:\n");

        A = 32'b0;
        B = 32'b0;

        $monitor("A=%b B=%b | R=%b\n", A, B, R,
                 "N_flag=%b Z_flag=%b C_flag=%b V_flag=%b\n\n", N_flag, Z_flag, C_flag, V_flag);
    end

    initial begin
        #100;

        // Test 1: A = 0, B = 0
        A = 32'b0; B = 32'b0;

        #100

        assert((R == 32'b0) && (N_flag == 0) && (Z_flag == 1) && (C_flag == 0) && (V_flag == 0))
            else $error("Failed for A=0 B=0");

        #100

        // Test 2: A = 1, B = 1
        A = 32'd1; B = 32'd1;

        #100

        assert((R == 32'd1) && (N_flag == 0) && (Z_flag == 0) && (C_flag == 0) && (V_flag == 0))
            else $error("Failed for A=1 B=1");

        #100

        // Test 3: A = -1 (32'hFFFFFFFF), B = 1
        A = 32'hFFFFFFFF; B = 32'd1;

        #100

        assert((R == 32'hFFFFFFFF) && (N_flag == 1) && (Z_flag == 0) && (C_flag == 0) && (V_flag == 0))
            else $error("Failed for A=-1 B=1");

        #100

        // Test 4: A = 2^16, B = 2^16
        A = 32'h00010000; B = 32'h00010000;

        #100

        assert((R == 32'h00000000) && (N_flag == 0) && (Z_flag == 1) && (C_flag == 1) && (V_flag == 0))
            else $error("Failed for A=2^16 B=2^16");

        #100

        // Test 5: A = 2^31, B = 2
        A = 32'h80000000; B = 32'd2;

        #100

        assert((R == 32'h00000000) && (N_flag == 0) && (Z_flag == 1) && (C_flag == 1) && (V_flag == 0))
            else $error("Failed for A=2^31 B=2");

        #100;

        // Done

    end

endmodule
