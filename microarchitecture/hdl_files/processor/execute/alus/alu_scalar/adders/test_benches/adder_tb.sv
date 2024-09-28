/*
Test bench for adder module
Date: 31/08/24
Approved
*/
module adder_tb;

    timeunit 1ps;
    timeprecision 1ps;

    parameter N = 32;

    logic [N-1:0] A;
    logic [N-1:0] B;
    logic C_in;

    logic [N-1:0] R;
    logic N_flag, Z_flag, C_flag, V_flag;

    // adder unit under testing
    adder #(.N(N)) uut (.A(A),
                        .B(B),
                        .C_in(C_in),
                        .R(R),
                        .N_flag(N_flag),
                        .Z_flag(Z_flag),
                        .C_flag(C_flag),
                        .V_flag(V_flag));

    initial begin
        $display("Adder test bench:\n");

        A = 32'b0;
        B = 32'b0;
        C_in = 0;

        $monitor("A=%b B=%b C_in=%b | R=%b\n", A, B, C_in, R,
                 "N_flag=%b Z_flag=%b C_flag=%b V_flag=%b\n\n", N_flag, Z_flag, C_flag, V_flag);
    end

    initial begin
        #100;

        // Test 1: A = 0, B = 0, C_in = 0
        A = 32'b0; B = 32'b0; C_in = 0;
        
        #100

        assert((R == 32'b0) && (N_flag == 0) && (Z_flag == 1) && (C_flag == 0) && (V_flag == 0))
            else $error("Failed for A=0 B=0 C_in=0");

        #100

        // Test 2: A = 1, B = 1, C_in = 0
        A = 32'd1; B = 32'd1; C_in = 0;
        
        #100

        assert((R == 32'd2) && (N_flag == 0) && (Z_flag == 0) && (C_flag == 0) && (V_flag == 0))
            else $error("Failed for A=1 B=1 C_in=0");

        #100

        // Test 3: A = 2^31 (número negativo), B = 1, C_in = 0
        A = 32'h80000000; B = 32'd1; C_in = 0;
        
        #100

        assert((R == 32'h80000001) && (N_flag == 1) && (Z_flag == 0) && (C_flag == 0) && (V_flag == 0))
            else $error("Failed for A=2^31 B=1 C_in=0");

        #100

        // Test 4: A = 2^31-1 (máximo positivo), B = 1, C_in = 0
        A = 32'h7FFFFFFF; B = 32'd1; C_in = 0;
        
        #100

        assert((R == 32'h80000000) && (N_flag == 1) && (Z_flag == 0) && (C_flag == 0) && (V_flag == 1))
            else $error("Failed for A=2^31-1 B=1 C_in=0");

        #100

        // Test 5: A = 2^32-1 (máximo valor), B = 1, C_in = 0
        A = 32'hFFFFFFFF; B = 32'd1; C_in = 0;
        
        #100

        assert((R == 32'd0) && (N_flag == 0) && (Z_flag == 1) && (C_flag == 1) && (V_flag == 0))
            else $error("Failed for A=2^32-1 B=1 C_in=0");

        #100;

        // Done

    end

endmodule
