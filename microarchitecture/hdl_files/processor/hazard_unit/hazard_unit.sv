/*
Hazard Unit module
IMPLEMENTATION AWAITS
Data: 19/09/24
Test bench ran: XX/09/24
*/
module hazard_unit(
		input  logic PCSrcD,
		input  logic [2:0] RA1D,
		input  logic [2:0] RA2D,

		input  logic PCSrcE,
		input  logic MemtoRegE,
		input  logic BranchTakenE,
		input  logic [2:0] RA1E,
		input  logic [2:0] RA2E,
		input  logic [2:0] WA3E,

		input  logic PCSrcM,
		input  logic RegWriteM,
		input  logic RegWriteVM,
		input  logic [2:0] WA3M,
		input  logic BusyDA,

		input  logic PCSrcW,
		input  logic RegWriteW,
		input  logic RegWriteVW,
		input  logic [2:0] WA3W,
		
		
		output logic StallF,

		output logic StallD,
		output logic FlushD,
		
		output logic StallE,
		output logic FlushE,
		output logic [1:0] ForwardAE,
		output logic [1:0] ForwardBE,
		output logic [1:0] ForwardAVE,
		output logic [1:0] ForwardBVE,
		
		output logic StallM,
		
		output logic StallW
	);

	/* LOGIC PENDING */

	assign StallF = 1'b0;

	assign StallD = 1'b0;
	assign FlushD = 1'b0;

	assign StallE = 1'b0;
	assign FlushE = 1'b0;
	assign ForwardAE = 2'b00;
	assign ForwardBE = 2'b00;
	assign ForwardAVE = 2'b00;
	assign ForwardBVE = 2'b00;

	assign StallM = 1'b0;

	assign StallW = 1'b0;
	
endmodule
