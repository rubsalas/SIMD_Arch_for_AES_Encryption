/*
Pipeline's Execute Stage
Date: 22/09/24
Test bench ran: XX/09/24
*/
module execute # (parameter N = 32, parameter V = 256, parameter R = 5) (
		input  logic clk,
		input  logic rst,
		/* inputs from register */
		// Data for ALUs
		input  logic [N-1:0] RD1E,			// RD1D (from register_file) to mux SrcAE [y]
		input  logic [N-1:0] RD2E,			// RD2D (from register_file) to mux WriteDataE [y]
		input  logic [N-1:0] ExtImmE,		// ExtImmD (from extend) to mux_SrcBE [y]
		input  logic [V-1:0] VRD1E,			// VRD1D (from vector_register_file) to mux SrcAVE [y]
		input  logic [V-1:0] VRD2E,			// VRD2D (from vector_register_file) to mux SrcBVE [y]

		// Control signals
		input  logic PCSrcE,				// to allround Fetch from CU, but through CdU [n]
		input  logic RegWriteE,				// to allround Decode from CU, but through CdU [n]
		input  logic RegWriteVE,			// to allround Decode from CU [n]

		input  logic MemtoRegE,				// to Writeback from CU [n]		
		
		input  logic MemWriteE,				// to Memory from CU, but through CdU [n], to mux_ALUResultVE [y]
		input  logic MemSrcE,				// to Memory from CU [n]
		input  logic MemDataE,				// to Memory from CU [n]
		input  logic VecDataE,				// to Memory from CU [n]

		input  logic [2:0] ALUControlE,		// to ALU [y], to ALU Vector [y]
		input  logic BranchE,				// to CdU [n]
		input  logic ALUSrcE,				// to mux_SrcBE [y]
		input  logic [1:0] FlagWriteE,		// to CdU [n]

		/* inputs from forwarding */
		input  logic [N-1:0] ResultW,		// ResultW (from Writeback) to mux SrcAE [y], to mux WriteDataE [y]
		input  logic [V-1:0] ResultVW,		// ResultVW (from Writeback) to mux SrcVAE [y], to mux SrcVBE [y]
		input  logic [N-1:0] ALUResultM,	// ALUResultM (from Memory) to mux SrcAE [y], to mux WriteDataE [y]
		input  logic [V-1:0] ALUResultVM,	// ALUResultVM (from Memory) to mux SrcVAE [y], to mux SrcVBE [y]

		/* inputs from hazard unit */
		input  logic ForwardAE,				// to mux_SrcAE [y]
		input  logic ForwardBE,				// to mux_WriteDataE [y]
		input  logic ForwardAVE,			// to mux_SrcAVE [y]
		input  logic ForwardBVE,			// to mux_SrcBVE [y]

		/* outputs */
		output logic [N-1:0] WriteDataE,	// from mux_WriteDataE [y], to mux_SrcBE [y]
		output logic [N-1:0] ALUResultE,	// from ALU [y]

		output logic [V-1:0] ALUResultVE	// from mux_ALUResultVE [n]
	);

	/* wiring */
	logic [N-1:0] SrcAE;					// from mux_SrcAE [y] to ALU [y]
	logic [N-1:0] SrcBE;					// from mux_SrcBE [y] to ALU [y]

	logic [V-1:0] SrcAVE;					// from mux_SrcAVE [y] to ALU Vector [y]
	logic [V-1:0] SrcBVE;					// from mux_SrcBVE [y] to ALU Vector [y], to mux_ALUResultVE [y]

	logic [3:0]	ALUFlags;					// from ALU [y] to CdU [n]

	logic [V-1:0] ALURV;					// from ALU Vector [y] to mux_ALUResultVE [y]

	

	/* SrcAE (ALU's A Operand) Mux */
	mux_4NtoN # (.N(N)) mux_SrcAE (.I0(RD1E),			
								   .I1(ResultW),
								   .I2(ALUResultM),
								   .I3(32'h0), // All 0's, not used
								   .rst(rst),
								   .S(ForwardAE),
								   .en(1'b1),
								   .O(SrcAE));


	
	/* WriteDataE (ALU's posible operand and Memory's write data) Mux */
	mux_4NtoN # (.N(N)) mux_WriteDataE (.I0(RD2E),
										.I1(ResultW),
										.I2(ALUResultM),
										.I3(32'h0), // All 0's, not used
										.rst(rst),
										.S(ForwardBE),
										.en(1'b1),
										.O(WriteDataE));
	

	/* SrcBE (ALU's B Operand) Mux */
	mux_2NtoN # (.N(N)) mux_SrcBE (.I0(WriteDataE),
								   .I1(ExtImmE),
								   .rst(rst),
								   .S(ALUSrcE),
								   .en(1'b1),
								   .O(SrcBE));

	
	/* Scalar ALU */
	alu # (.N(N)) sALU (.A(SrcAE),
						.B(SrcBE),
						.ALUControl(ALUControlE),
						.result(ALUResultE),
						.flags(ALUFlags));


	/* ********************************** vector ***************************** */

	/* SrcAVE (ALU Vector's A Operand) Mux */
	mux_4NtoN # (.N(V)) mux_SrcAVE (.I0(VRD1E),
									.I1(ResultVW),
									.I2(ALUResultVM),
									.I3(256'h0), // All 0's, not used
									.rst(rst),
									.S(ForwardAVE),
									.en(1'b1),
									.O(SrcAVE));
	

	/* SrcBVE (ALU Vector's B Operand) Mux */
	mux_4NtoN # (.N(V)) mux_SrcBVE (.I0(VRD2E),
									.I1(ResultVW),
									.I2(ALUResultVM),
									.I3(256'h0), // All 0's, not used
									.rst(rst),
									.S(ForwardBVE),
									.en(1'b1),
									.O(SrcBVE));
	

	/* Vector ALU */
	alu_vector # (.N(V)) vALU (.A(SrcAVE),
							   .B(SrcBVE),
							   .ALUControl(ALUControlE),
							   .result(ALURV)); // ALUFlags for vector wont be needed for now

	
	/* ALUResultVE (vALU's B Operand) Mux */
	mux_2NtoN # (.N(V)) mux_ALUResultVE (.I0(ALURV),
										 .I1(SrcBVE),
										 .rst(rst),
										 .S(MemWriteE),
										 .en(1'b1),
										 .O(ALUResultVE));
	
	
	/* Conditional Unit checks flags and branches */
	conditional_unit cond_unit (.clk(clk),
							  	.rst(rst),

								.PCSrcE(),
								.RegWriteE(),
								.MemWriteE(),
								.BranchE(),

								.FlagWriteE(),
								.Opcode(),
								.FlagsE(),
								.ALUFlags(),

								.ALUFlagsD(),
								.BranchTakenE(),
								.PCSrcECU(),
								.RegWriteECU(),
								.MemWriteECU());

	
	/* Conditioned control signals */
	
	
	/* ExtImm for Fetch stage (ALUResult was used in book's implementation) */
	/* Used for sending the branch address in 'b' instruction */

	

endmodule
