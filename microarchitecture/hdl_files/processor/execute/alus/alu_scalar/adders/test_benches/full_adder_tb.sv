/*
Test bench for full adder module.
Date: 31/08/24
Approved
*/
module full_adder_tb;

    logic A, B, C_in;       // Entradas de prueba
    logic R, C_out;         // Salidas de prueba

    // Instancia del full adder
    full_adder uut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .R(R),
        .C_out(C_out)
    );

    initial begin
        // Test 1
        A = 0; B = 0; C_in = 0;
        #100

        $display("A=%b B=%b C_in=%b | R=%b C_out=%b | Expected R=0, C_out=0", A, B, C_in, R, C_out);
        assert(R == 0 && C_out == 0) 
            else $error("Error: Test 1 failed. Expected R=0, C_out=0; Obtained R=%b, C_out=%b", R, C_out);
        
        #100

        // Test 2
        A = 1; B = 0; C_in = 0;
        
        #100

        $display("A=%b B=%b C_in=%b | R=%b C_out=%b | Expected R=0, C_out=0", A, B, C_in, R, C_out);
        assert(R == 1 && C_out == 0) 
            else $error("Error: Test 2 failed. Expected R=1, C_out=0; Obtained R=%b, C_out=%b", R, C_out);
        
        #100

        // Test 3
        A = 1; B = 1; C_in = 0;
        
        #100

        $display("A=%b B=%b C_in=%b | R=%b C_out=%b | Expected R=0, C_out=0", A, B, C_in, R, C_out);
        assert(R == 0 && C_out == 1) 
            else $error("Error: Test 3 failed. Expected R=0, C_out=1; Obtained R=%b, C_out=%b", R, C_out);
        
        #100

        // Test 4
        A = 1; B = 1; C_in = 1;
        
        #100

        $display("A=%b B=%b C_in=%b | R=%b C_out=%b | Expected R=0, C_out=0", A, B, C_in, R, C_out);
        assert(R == 1 && C_out == 1) 
            else $error("Error: Test 4 failed. Expected R=1, C_out=1; Obtained R=%b, C_out=%b", R, C_out);
        
        // Test 5
        A = 1; B = 1; C_in = 1;
        
        #100

        $display("A=%b B=%b C_in=%b | R=%b C_out=%b | Expected R=0, C_out=0", A, B, C_in, R, C_out);
        assert(R == 1 && C_out == 1) 
            else $error("Error: Test 5 failed. Expected R=1, C_out=1; Obtained R=%b, C_out=%b", R, C_out);

        #100;

    end

endmodule
