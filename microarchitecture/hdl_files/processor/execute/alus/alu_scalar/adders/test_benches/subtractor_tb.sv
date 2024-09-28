/*
Adder module as Substractor
Date: 31/08/24
Test bench ran: 31/08/24
*/
module subtractor_tb;

    parameter N = 32;

    logic [N-1:0] A, B;
    logic C_in;
    logic [N-1:0] R;
    logic N_flag, Z_flag, C_flag, V_flag;

    // Instancia del módulo adder
    adder #(.N(N)) uut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .R(R),
        .N_flag(N_flag),
        .Z_flag(Z_flag),
        .C_flag(C_flag),
        .V_flag(V_flag)
    );

    initial begin
        // Monitoreo de las señales
        $monitor("A=%h B=%h C_in=%b | R=%h N_flag=%b Z_flag=%b C_flag=%b V_flag=%b",
                 A, B, C_in, R, N_flag, Z_flag, C_flag, V_flag);

        // Test 1: Resta sin desbordamiento (A - B)
        A = 32'd30; B = 32'd10; C_in = 1'b1; // A = 30, B = 10, resta
        #10;
        assert((R == 32'd20) && (N_flag == 0) && (Z_flag == 0) && (C_flag == 0) && (V_flag == 0))
            else $error("Test 1 Failed: A=30, B=10, Expected: R=20, N=0, Z=0, C=0, V=0");

        // Test 2: Resta con resultado negativo (A - B)
        A = 32'd10; B = 32'd30; C_in = 1'b1; // A = 10, B = 30, resta
        #10;
        assert((R == -32'd20) && (N_flag == 1) && (Z_flag == 0) && (C_flag == 1) && (V_flag == 0))
            else $error("Test 2 Failed: A=10, B=30, Expected: R=-20, N=1, Z=0, C=1, V=0");

        // Test 3: Resta con resultado cero (A - B)
        A = 32'd1; B = 32'd1; C_in = 1'b1; // A = 1, B = 1, resta
        #10;
        assert((R == 32'd0) && (N_flag == 0) && (Z_flag == 1) && (C_flag == 0) && (V_flag == 0))
            else $error("Test 3 Failed: A=1, B=1, Expected: R=0, N=0, Z=1, C=0, V=0");

        // Test 4: Resta con desbordamiento positivo (A - B)
        A = 32'h80000000; B = 32'hFFFFFFFF; C_in = 1'b1; // A = -2^31, B = -1, resta
        #10;
        assert((R == 32'h80000001) && (N_flag == 1) && (Z_flag == 0) && (C_flag == 0) && (V_flag == 0))
            else $error("Test 4 Failed: A=-2^31, B=-1, Expected: R=-2^31 + 1, N=1, Z=0, C=0, V=0");

        // Test 5: Resta con desbordamiento negativo (A - B)
        A = 32'h7FFFFFFF; B = 32'hFFFFFFFF; C_in = 1'b1; // A = 2^31-1, B = -1, resta
        #10;
        assert((R == 32'h80000000) && (N_flag == 1) && (Z_flag == 0) && (C_flag == 0) && (V_flag == 1))
            else $error("Test 5 Failed: A=2^31-1, B=-1, Expected: R=-2^31, N=1, Z=0, C=0, V=1");

        $display("All tests completed.");
        $finish;
    end
endmodule
