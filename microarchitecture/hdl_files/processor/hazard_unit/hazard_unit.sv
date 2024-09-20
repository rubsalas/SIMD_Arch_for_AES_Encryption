/*
Hazard Unit module
IMPLEMENTATION AWAITS
Data: 19/09/24
Test bench ran: XX/09/24
*/
module hazard_unit(
		input  logic [2:0] RA1D,
		input  logic [2:0] RA2D,
		input  logic [2:0] RA1E,
		input  logic [2:0] RA2E,
		input  logic [2:0] WA3E,
		input  logic [2:0] WA3M,
		input  logic [2:0] WA3W,
		input  logic RegWriteM,
		input  logic RegWriteW,
		input  logic MemtoRegE,
		input  logic PCSrcD,
		input  logic PCSrcE,
		input  logic PCSrcM,
		input  logic PCSrcW,
		input  logic BranchTakenE,
		/* check added input */
		input  logic Busy,
		
		output logic StallF,
		output logic StallD,
		output logic StallE,
		output logic StallM,
		output logic StallW,
		output logic FlushD,
		output logic FlushE,
		output logic [1:0] ForwardAE,
		output logic [1:0] ForwardBE
	);

	assign StallF = 1'b0;
	assign StallD = 1'b0;
	assign StallE = 1'b0;
	assign StallM = 1'b0;
	assign StallW = 1'b0;
	assign FlushD = 1'b0;
	assign FlushE = 1'b0;
	assign ForwardAE = 2'b00;
	assign ForwardBE = 2'b00;

endmodule
