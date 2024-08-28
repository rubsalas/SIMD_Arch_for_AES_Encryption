/*
Single Adder Module
Date: 27/08/24
*/
module single_adder
 # (parameter N = 24)(

        input  logic [N-1:0] A,
        input  logic [N-1:0] B,
        output logic [N-1:0] Y
    );

    assign Y = A + B;

endmodule
