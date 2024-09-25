/*
Full Memory module
Date: 13/09/24
Test bench ran: XX/09/24
*/
module memory # (parameter N = 32, parameter V = 256) (
		input  logic clk,
		/* Instruction inputs */
		input  logic [N-1:0] pc_address,	// PCF (Q from pc register) to A
		/* Data inputs */
		input  logic [13:0] address_data,	// MemAddress (Ao from data_aligner) to A
		input  logic [31:0] byteena_data,	// Control Signal: Byteena from data_aligner
		input  logic [V-1:0] write_data,	// MemWriteData (WD from data_aligner) to WD
		input  logic rden_data,				// Control Signal: Rden from data_aligner 
		input  logic wren_data,				// Control Signal: Wren from data_aligner 

		/* Instruction outputs */
		output logic [N-1:0] instruction,	// InstrF (to InstF from register_FD) from RD
		/* Data ouputs */
		output logic [V-1:0] read_data,		// MemReadData (to RDi from data memory) from RD
	);

	// Specific addresses for ips
	logic [13:0] in_address;
	logic [13:0] dt_address;	// 16384 addresses of 256 bits

	// Bus length adjust
	assign in_address = pc_address[13:0];
	assign dt_address = address_data[13:0];

	
	/* Instruction memory */
	instruction_memory #(.N(N)) inst_memory (.address(in_address),
								  	   		 .instruction(instruction));


	/* Data memory */
	data_memory ram_memory (.address(dt_address),
							.byteena(byteena_data),
							.clock(clk),
							.data(write_data),
							.rden(rden_data),
							.wren(wren_data),
							.q(read_data));

endmodule
