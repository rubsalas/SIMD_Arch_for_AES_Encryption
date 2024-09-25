/*
Pipeline's Execute Stage
Date: 22/09/24
Test bench ran: XX/09/24
*/
module execute # (parameter N = 32, parameter V = 256, parameter R = 5) (
		input  logic rst,
		/* inputs from register */
		// Data for ALUs
		input  logic [N-1:0] RD1E,			// RD1D (from register_file) to mux SrcAE [y]
		input  logic [N-1:0] RD2E,			// RD2D (from register_file) to mux WriteDataE [y]
		input  logic [N-1:0] ExtImmEi,		// ExtImmD (from extend) to mux_SrcBE [y], to ExtImmo f [y]
		input  logic [V-1:0] VRD1E,			// VRD1D (from vector_register_file) to mux SrcAVE [y]
		input  logic [V-1:0] VRD2E,			// VRD2D (from vector_register_file) to mux SrcBVE [y]

		// Data for forwarding
		input  logic [R-1:0] WA3Ei,			// WA3D (from instructions's Rd) to WA3Eo f [y]

		// Control signals
		input  logic PCSrcE,				// to allround Fetch from CU, but through CdU [y]
		input  logic RegWriteE,				// to allround Decode from CU, but through CdU [y]
		input  logic RegWriteVEi,			// to allround Decode from CU. RegWriteVD to RegWriteVEo f [y]

		input  logic MemtoRegEi,			// to Writeback from CU. MemtoRegD to MemtoRegEo f [y]		
		
		input  logic MemWriteE,				// to Memory from CU, but through CdU [y]
		input  logic MemSrcEi,				// to Memory from CU. MemSrcD to MemSrcEo f [y]
		input  logic MemDataEi,				// to Memory from CU. MemDataD to MemDataEo f [y]
		input  logic MemDataVEi,			// to Memory from CU. MemDataVD to MemDataVEo f [y]
		input  logic VecDataEi,				// to Memory from CU. VecDataD to VecDataEo f [y]

		input  logic [1:0] InstrSelE,		// to CdU [y]
		input  logic [2:0] ALUControlE,		// to ALU [y], to ALU Vector [y]
		input  logic BranchE,				// to CdU [y]
		input  logic ALUSrcE,				// to mux_SrcBE [y]

		/* inputs from forwarding */
		input  logic [N-1:0] ResultW,		// ResultW (from Writeback) to mux SrcAE [y], to mux WriteDataE [y]
		input  logic [V-1:0] ResultVW,		// ResultVW (from Writeback) to mux SrcVAE [y], to mux SrcBVE [y]
		input  logic [N-1:0] ALUResultM,	// ALUResultM (from Memory) to mux SrcAE [y], to mux WriteDataE [y]
		input  logic [V-1:0] ALUResultVM,	// ALUResultVM (from Memory) to mux SrcVAE [y], to mux SrcBVE [y]

		/* inputs from hazard unit */
		input  logic ForwardAE,				// to mux_SrcAE [y]
		input  logic ForwardBE,				// to mux_WriteDataE [y]
		input  logic ForwardAVE,			// to mux_SrcAVE [y]
		input  logic ForwardBVE,			// to mux_SrcBVE [y]

		/* inputs for hazard unit */
		input  logic [R-1:0] RA1Ei,			// RA1D (from register_file) to RA1Eo (to HU) [y]
		input  logic [R-1:0] RA2Ei,			// RA2D (from register_file) to RA2Eo (to HU) [y]

		/* outputs */
		output logic [N-1:0] WriteDataE,	// from mux_WriteDataE [y], to mux_SrcBE [y]
		output logic [N-1:0] ALUResultE,	// from ALU [y]

		output logic [V-1:0] WriteDataVE,	// from SrcBVE f [y]
		output logic [V-1:0] ALUResultVE,	// from ALU Vector [y]

		output logic [R-1:0] WA3Eo,			// from WA3Ei [y]
		
		/* outputs for forwarding */
		output logic [N-1:0] ExtImmEo,		// from ExtImmEi [y]

		/* control signal outputs */
		output logic BranchTakenE,			// from CdU [y]
		output logic PCSrcECU,				// from CdU [y]
		output logic RegWriteECU,			// from CdU [y]
		output logic MemWriteECU,			// from CdU	[y]

		output logic RegWriteVEo,			// from RegWriteVEi [y]
		output logic MemtoRegEo,			// from MemtoRegEi [y]

		output logic MemSrcEo,				// from MemSrcEi [y]
		output logic MemDataEo,				// from MemDataEi [y]
		output logic MemDataVEo,			// from MemDataVEi [y]
		output logic VecDataEo,				// from VecDataEi [y]

		/* outputs for hazard unit */
		output logic [R-1:0] RA1Eo,			// from RA1Ei [y]
		output logic [R-1:0] RA2Eo			// from RA2Ei [y]
	);


	/* wiring */
	logic [N-1:0] SrcAE;					// from mux_SrcAE [y] to ALU [y]
	logic [N-1:0] SrcBE;					// from mux_SrcBE [y] to ALU [y]

	logic [V-1:0] SrcAVE;					// from mux_SrcAVE [y] to ALU Vector [y]
	logic [V-1:0] SrcBVE;					// from mux_SrcBVE [y] to ALU Vector [y], to f WriteDataVE [y]

	logic [3:0]	ALUFlags;					// from ALU [y] to CdU [y]


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
								   .I1(ExtImmEi),
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

	
	/* WriteDataVE output for register_EM */
	assign WriteDataVE = SrcBVE;
	

	/* Vector ALU */
	alu_vector # (.N(N), .V(V)) vALU (.A(SrcAVE),
									  .B(SrcBVE),
									  .ALUControl(ALUControlE),
									  .result(ALUResultVE)); // ALUFlags for vector wont be needed for now

	
	/* ********************************** forwarding data ***************************** */


	/* WA3E forwarding output for register_EM */
	assign WA3Eo = WA3Ei;

	/* ExtImmE forwarding output for Fetch */
	/* Used for sending the branch address in 'b' instruction */
	assign ExtImmEo = ExtImmEi;

	/* RA1E forwarding output for hazard unit */
	assign RA1Eo = RA1Ei;

	/* RA2E forwarding output for hazard unit */
	assign RA2Eo = RA2Ei;


	/* ********************************** conditional_unit ***************************** */
	
	
	/* Conditional Unit checks flags and branches */
	conditional_unit cond_unit (.PCSrcE(PCSrcE),
								.RegWriteE(RegWriteE),
								.MemWriteE(MemWriteE),

								.BranchE(BranchE),

								.InstrSelE(InstrSelE),
								.ALUFlags(ALUFlags),

								/* outputs */
								.BranchTakenE(BranchTakenE),
								.PCSrcECU(PCSrcECU),
								.RegWriteECU(RegWriteECU),
								.MemWriteECU(MemWriteECU));


	/* ********************************** forwarding control signals ***************************** */


	/* RegWriteVE forwarding output for register_EM */
	assign RegWriteVEo = RegWriteVEi;

	/* MemtoRegE forwarding output for register_EM */
	assign MemtoRegEo = MemtoRegEi;

	/* MemSrcE forwarding output for register_EM */
	assign MemSrcEo = MemSrcEi;

	/* MemDataE forwarding output for register_EM */
	assign MemDataEo = MemDataEi;

	/* MemDataVE forwarding output for register_EM */
	assign MemDataVEo = MemDataVEi;

	/* VecDataE forwarding output for register_EM */
	assign VecDataEo = VecDataEi;
	

endmodule
