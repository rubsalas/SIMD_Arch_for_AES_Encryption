/*
Multiplier module
Date: 31/08/24
Test bench ran: 31/08/24
*/
module multiplier # (parameter N = 32) (
		input  logic [N-1:0]      A,
		input  logic [N-1:0]      B,

		output logic [N-1:0]      R,
		output logic         N_flag,
		output logic         Z_flag,
		output logic         C_flag,
		output logic         V_flag
	);

    logic [2*N-1:0] temp_R;
    logic sign_A, sign_B;

    assign temp_R = A * B;
    assign R = temp_R[N-1:0];

    assign Z_flag = (R == 0) ? 1'b1 : 1'b0;
    assign C_flag = (temp_R[2*N-2:N] > 0) ? 1'b1 : 1'b0;
    assign N_flag = temp_R[N-1];

    assign sign_A = A[N-1];
    assign sign_B = B[N-1];
    assign V_flag = (sign_A ~^ sign_B) & N_flag;

endmodule
