/*
Adder v2 module
Date: 31/08/24
Test bench ran: 31/08/24
*/
module adder # (parameter N = 32) (
    input  logic [N-1:0] A,
    input  logic [N-1:0] B,
    input  logic         C_in,

    output logic [N-1:0] R,
    output logic         N_flag,
    output logic         Z_flag,
    output logic         C_flag,
    output logic         V_flag
);

    logic [N:0] C_ins;
    logic [N-1:0] B_logic;
    assign C_ins[0] = C_in;
    assign B_logic = (C_in) ? ~B : B;  // Complemento de B si es una resta (C_in = 1)

    genvar i;
    generate
        for (i = 0; i < N; i += 1) begin : GenAdders
            full_adder f_a (.A(A[i]),
                            .B(B_logic[i]),
                            .C_in(C_ins[i]),
                            .C_out(C_ins[i + 1]),
                            .R(R[i]));
        end
    endgenerate

    assign N_flag = R[N-1];
    assign Z_flag = (R == {N{1'b0}}) ? 1'b1 : 1'b0;  // Asegura que Z_flag se active solo cuando R es completamente cero
    assign C_flag = (C_in == 1'b1) ? ~C_ins[N] : C_ins[N];
    assign V_flag = (~C_in && (A[N-1] == B[N-1]) && (R[N-1] != A[N-1])) ||
                    (C_in && (A[N-1] != B[N-1]) && (R[N-1] == A[N-1]));

endmodule
