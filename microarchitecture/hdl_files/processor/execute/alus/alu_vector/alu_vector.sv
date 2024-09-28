/*
ALU vector module v2
Date: 13/09/24
Test bench ran: 13/09/24
*/
module alu_vector # (parameter N = 32, parameter V = 256) (
        input logic [V-1:0]  A,
        input logic [V-1:0]  B,
        input logic [2:0]    ALUControl,

        output logic [V-1:0] result,
        output logic [31:0]  flags
	);

	logic [N-1:0] A00,A01,A02,A03,A04,A05,A06,A07;
	logic [N-1:0] B00,B01,B02,B03,B04,B05,B06,B07;

	logic [N-1:0] result00,result01,result02,result03,result04,result05,result06,result07;
				  
	logic [3:0] flags00,flags01,flags02,flags03,flags04,flags05,flags06,flags07;

	//logic [31:0]  flags;

	assign A00 = A[31:0];
	assign A01 = A[63:32];
	assign A02 = A[95:64];
	assign A03 = A[127:96];
	assign A04 = A[159:128];
	assign A05 = A[191:160];
	assign A06 = A[223:192];
	assign A07 = A[255:224];

	assign B00 = B[31:0];
	assign B01 = B[63:32];
	assign B02 = B[95:64];
	assign B03 = B[127:96];
	assign B04 = B[159:128];
	assign B05 = B[191:160];
	assign B06 = B[223:192];
	assign B07 = B[255:224];

	alu #(N) vector_alu0 (
					.A(A00),
					.B(B00),
					.ALUControl(ALUControl),
					.result(result00),
					.flags(flags00));

	alu #(N) vector_alu1 (
					.A(A01),
					.B(B01),
					.ALUControl(ALUControl),
					.result(result01),
					.flags(flags01));

	alu #(N) vector_alu2(
					.A(A02),
					.B(B02),
					.ALUControl(ALUControl),
					.result(result02),
					.flags(flags02));

	alu #(N) vector_alu3(
					.A(A03),
					.B(B03),
					.ALUControl(ALUControl),
					.result(result03),
					.flags(flags03));

	alu #(N) vector_alu4(
					.A(A04),
					.B(B04),
					.ALUControl(ALUControl),
					.result(result04),
					.flags(flags04));

	alu #(N) vector_alu5(
					.A(A05),
					.B(B05),
					.ALUControl(ALUControl),
					.result(result05),
					.flags(flags05));

	alu #(N) vector_alu6(
					.A(A06),
					.B(B06),
					.ALUControl(ALUControl),
					.result(result06),
					.flags(flags06));

	alu #(N) vector_alu7(
					.A(A07),
					.B(B07),
					.ALUControl(ALUControl),
					.result(result07),
					.flags(flags07));


	// assign para formar el result de 256 bits
	assign result[31:0] = result00;
	assign result[63:32] = result01;
	assign result[95:64] = result02;
	assign result[127:96] = result03;
	assign result[159:128] = result04;
	assign result[191:160] = result05;
	assign result[223:192] = result06;
	assign result[255:224] = result07;

	// assign para formar las flags de 32 bits
	assign flags[3:0] = flags00;
	assign flags[7:4] = flags01;
	assign flags[11:8] = flags02;
	assign flags[15:12] = flags03;
	assign flags[19:16] = flags04;
	assign flags[23:20] = flags05;
	assign flags[27:24] = flags06;
	assign flags[31:28] = flags07;

endmodule
