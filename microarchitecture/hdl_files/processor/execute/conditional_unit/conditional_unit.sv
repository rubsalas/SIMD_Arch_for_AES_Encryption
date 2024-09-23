/*
Conditional Unit v2 module 
Date: 08/04/2024
Test bench ran: XX/09/24
*/
module conditional_unit (
		input  logic PCSrcE,
		input  logic RegWriteE,
		input  logic MemWriteE,

		input  logic BranchE,

		input  logic [1:0] InstrSelE,
		input  logic [3:0] ALUFlags,
	
		output logic BranchTakenE,
		output logic PCSrcECU,
		output logic RegWriteECU,
		output logic MemWriteECU
	);

	logic [1:0] FlagWrite;
	logic CondExE;
	
	/* Checks conditions based on flags */
	condition_checker cond_checker (.Branch(BranchE),
									.InstrSel(InstrSelE),
									.Flags(ALUFlags),
									.CondEx(CondExE));

	/* Control signals based con condition */
	assign BranchTakenE = BranchE & CondExE;
	assign PCSrcECU = PCSrcE & CondExE; 		// PCSrcM before
 	assign RegWriteECU = RegWriteE & CondExE;	// RegWriteM before
	assign MemWriteECU = MemWriteE & CondExE;	// MemWriteM before

endmodule
