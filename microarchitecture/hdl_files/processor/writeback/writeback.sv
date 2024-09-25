/*
Pipeline's Memory Stage
Date: 25/09/24
Test bench ran: XX/09/24 
*/
module writeback # (parameter N = 32, parameter V = 256, parameter R = 5) (
		input  logic rst,
		/* inputs from register */
		input  logic PCSrcWi,				// to allround Fetch from CU, PCSrcM to PCSrcWo f [y]
		input  logic RegWriteWi,			// to allround Decode from CU, RegWriteM to RegWriteWo f [y]
		input  logic RegWriteVWi,			// to allround Decode from CU. RegWriteVM to RegWriteVWo f [y]
		input  logic MemtoRegW,				// to mux_ResultW [y], to mux_ResultVW [y]

		input  logic [N-1:0] ALUResultW,	// ALUResultM (from Memory) to mux_ResultW [y]
		input  logic [N-1:0] ReadDataW,		// ReadDataM (from Memory) to mux_ResultW [y]

		input  logic [V-1:0] ALUResultVW,	// ALUResultVM (from Memory) to mux_ResultVW [y]
		input  logic [N-1:0] ReadDataVW,	// ReadDataVM (from Memory) to mux_ResultVW [y]

		input  logic [R-1:0] WA3Wi,			// WA3M (from instructions's Rd) to WA3Mo f [y]

		/* outputs */
		output logic PCSrcWo,				// from PCSrcWi [y]
		output logic RegWriteWo,			// from RegWriteWi [y]
		output logic RegWriteVWo,			// from RegWriteVWi [y]

		output logic [N-1:0] ResultW,		// from mux_ResultW [y]
		output logic [V-1:0] ResultVW,		// from mux_ResultVW [y]
		
		output logic [R-1:0] WA3Wo			// from WA3Wi [y]
	);

	
	/* ResultW output for Decode and Execute */
	mux_2NtoN # (.N(N)) mux_ResultW (.I0(ALUResultW),
									 .I1(ReadDataW),
									 .rst(rst),
									 .S(MemtoRegW),
									 .en(1'b1),
									 .O(ResultW));

	
	/* ResultVW output for Decode and Execute */
	mux_2NtoN # (.N(V)) mux_ResultVW (.I0(ALUResultVW),
									  .I1(ReadDataVW),
									  .rst(rst),
									  .S(MemtoRegW),
									  .en(1'b1),
									  .O(ResultVW));


	/* ********************************** forwarding data ***************************** */

	
	/* WA3W forwarding output for Decode */
	assign WA3Wo = WA3Wi;


	/* ********************************** forwarding control signals ***************************** */


	/* PCSrcW forwarding output for Fetch and Hazard Unit */
	assign PCSrcWo = PCSrcWi;

	/* RegWriteW forwarding output for Decode and Execute */
	assign RegWriteWo = RegWriteWi;

	/* RegWriteVW forwarding output for Decode and Execute  */
	assign RegWriteVWo = RegWriteVWi;


endmodule
