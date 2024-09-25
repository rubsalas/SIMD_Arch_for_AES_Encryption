/*
Pipeline's Memory Stage
Date: 24/09/24
Test bench ran: XX/0/24 
*/
module mem # (parameter N = 32, parameter V = 256, parameter R = 5) (
		input  logic clk,
		input  logic rst,
		/* inputs from register */
		// Control signals
		input  logic PCSrcMi,				// to allround Fetch from CU, PCSrcE to PCSrcMo f [y]
		input  logic RegWriteMi,			// to allround Decode from CU, RegWriteE to RegWriteMo f [y]
		input  logic RegWriteVMi,			// to allround Decode from CU. RegWriteVE to RegWriteVMo f [y]

		input  logic MemtoRegMi,			// to Writeback from CU. MemtoRegE to MemtoRegMo f [y], to DA [y]	
		input  logic MemWriteM,				// to DA [y]
		input  logic MemSrcM,				// to DA [y]

		input  logic MemDataM,				// to mux_SWData [y]
		input  logic MemDataVM,				// to mux_VWData [y]
		input  logic VecDataM,				// to mux_ReadDataVM [y]

		input  logic [N-1:0] ALUResultMi,	// ALUResultE (from Execute) to Ai (DA) [y], to ALUResultMo [y]
		input  logic [N-1:0] WriteDataM,	// WriteDataE (from Execute) to mux_SWData [y]

		input  logic [V-1:0] ALUResultVMi,	// ALUResultVE (from Execute) to mux_SWData (31:0) [y], to mux_VWData [y], to ALUResultVMo [y]
		input  logic [N-1:0] WriteDataVM,	// WriteDataVE (from Execute) to mux_VWData [y]

		// Data for forwarding
		input  logic [R-1:0] WA3Mi,			// WA3E (from instructions's Rd) to WA3Eo f [y]

		/* input from SDRAM */
		input  logic [V-1:0] MemReadData, 	// RD from data_memory to RDi (DA) [y]


		/* outputs */
		output logic PCSrcMo,				// from PCSrcMi [y]
		output logic RegWriteMo,			// from RegWriteMi [y]
		output logic RegWriteVMo,			// from RegWriteVMi [y]
		output logic MemtoRegMo,			// from MemtoRegMi [y]

		output logic [N-1:0] ALUResultMo,	// from ALUResultMi [y]
		output logic [N-1:0] ALUResultVMo,	// from ALUResultVMi [y]

		output logic [N-1:0] ReadDataM,		// from DA [y], to vector_extend [y]
		output logic [V-1:0] ReadDataVM,	// from mux_ReadDataVM [y]
		
		output logic [R-1:0] WA3Mo,			// from WA3Ei [y]

		/* DA outputs */
		// for Hazard Unit
		output logic BusyDA,				// from DA [y]
		// for SDRAM
		output logic MemRden,				// from DA [y]
		output logic MemWren,				// from DA [y]
		output logic [13:0] MemAddress, 	// {Ao} from DA [y]
		output logic [31:0] MemByteena,		// from DA [y]
		output logic [V-1:0] MemWriteData  	// {WD} from DA [y]
	);


	/* wiring */
	logic [N-1:0] SWData;					// [y] from mux_SWData to WD (DA) [y]
	logic [V-1:0] VWData;					// [y] from mux_VWData to VWD (DA) [y]
	
	logic [V-1:0] REData;					// [y] from vector_extend to mux_ReadDataVM [y]
	logic [V-1:0] VRData;					// [y] from DA to mux_ReadDataVM [y]

	
	/* Write Data (scalar) for Data Aligner */
	mux_2NtoN # (.N(N)) mux_SWData (.I0(WriteDataM),
									.I1(ALUResultVMi[N-1:0]),
									.rst(rst),
									.S(MemDataM),
									.en(1'b1),
									.O(SWData));

	
	/* Write Data (vector) for Data Aligner */
	mux_2NtoN # (.N(V)) mux_VWData (.I0(WriteDataVM),
									.I1(ALUResultVMi),
									.rst(rst),
									.S(MemDataVM),
									.en(1'b1),
									.O(VWData));


	/*  Data Aligner */
	data_aligner # (.N(N), .V(V)) data_manager (
        .clk(clk),
        .rst(rst),

        .memtoRegM(MemtoRegMi),
        .memWriteM(MemWriteM),
        .memSrcM(MemSrcM),

        .address(ALUResultMi),		// Ai
        .scalarDataIn(SWData),		// WD
        .vectorDataIn(VWData),		// VWD

        .readData(MemReadData),		// RDi

		/* outputs */
        .busy(BusyDA),

        .scalarDataOut(ReadDataM),	// RDo
        .vectorDataOut(VRData),		// VRD

        .rden(MemRden),
        .wren(MemWren),
        .ip_address(MemAddress),	// Ao
        .byteena(MemByteena),
        .writeData(MemWriteData)	// WD
    );


	/* vector_extend */
	assign REData = { 224'd0, ReadDataM };


	/* ReadDataVM for Register_MW */
	mux_2NtoN # (.N(V)) mux_ReadDataVM (.I0(REData),
										.I1(VRData),
										.rst(rst),
										.S(VecDataM),
										.en(1'b1),
										.O(ReadDataVM));


	/* ********************************** forwarding data ***************************** */


	/* ALUResultM forwarding output for register_EM and Execute stage */
	assign ALUResultMo = ALUResultMi;

	/* ALUResultVM forwarding output for register_EM and Execute stage */
	assign ALUResultVMo = ALUResultVMi;

	/* WA3M forwarding output for register_EM */
	assign WA3Mo = WA3Mi;


	/* ********************************** forwarding control signals ***************************** */

	/* PCSrcM */
	assign PCSrcMo = PCSrcMi;

	/* RegWriteM */
	assign RegWriteMo = RegWriteMi;

	/* RegWriteVM */
	assign RegWriteVMo = RegWriteVMi;

	/* MemtoRegM */
	assign MemtoRegMo = MemtoRegMi;


endmodule
