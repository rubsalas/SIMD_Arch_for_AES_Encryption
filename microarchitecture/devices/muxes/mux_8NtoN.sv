/*
MUX 8:1 parametrizable para N bits
Date: 27/08/24
*/
module mux_8NtoN # (parameter N = 32) (	
		input  logic [N-1:0]  	 I0,
		input  logic [N-1:0] 	 I1,
		input  logic [N-1:0] 	 I2,
		input  logic [N-1:0] 	 I3,
		input  logic [N-1:0] 	 I4,
		input  logic [N-1:0] 	 I5,
		input  logic [N-1:0] 	 I6,
		input  logic [N-1:0] 	 I7,

		input  logic   [2:0]  	  S,
		input  logic        	rst,
		input  logic	 	 	 en,

		output logic [N-1:0]  	  O
	);

	wire [N-1:0] O_00_10;
	wire [N-1:0] O_01_10;
	wire [N-1:0] O_02_11;
	wire [N-1:0] O_03_11;

	// Stage 1

	mux_2NtoN # (.N(N)) m2NtoN_0_0 (.I0(I0),
									.I1(I1),
									.rst(rst),
									.S(S[0]),
									.en(en),
									.O(O_00_10));

	mux_2NtoN # (.N(N)) m2NtoN_0_1 (.I0(I2),
									.I1(I3),
									.rst(rst),
									.S(S[0]),
									.en(en),
									.O(O_01_10));

	mux_2NtoN # (.N(N)) m2NtoN_0_2 (.I0(I4),
									.I1(I5),
									.rst(rst),
									.S(S[0]),
									.en(en),
									.O(O_02_11));

	mux_2NtoN # (.N(N)) m2NtoN_0_3 (.I0(I6),
									.I1(I7),
									.rst(rst),
									.S(S[0]),
									.en(en),
									.O(O_03_11));

	wire [N-1:0] O_10_20;
	wire [N-1:0] O_11_20;
	
	// Stage 2

	mux_2NtoN # (.N(N)) m2NtoN_1_0 (.I0(O_00_10),
									.I1(O_01_10),
									.rst(rst),
									.S(S[1]),
									.en(en),
									.O(O_10_20));

	mux_2NtoN # (.N(N)) m2NtoN_1_1 (.I0(O_02_11),
									.I1(O_03_11),
									.rst(rst),
									.S(S[1]),
									.en(en),
									.O(O_11_20));

	// Stage 3

	mux_2NtoN # (.N(N)) m2NtoN_2_0 (.I0(O_10_20),
									.I1(O_11_20),
									.rst(rst),
									.S(S[2]),
									.en(en),
									.O(O));

endmodule
