
module memory # (parameter N = 32) (
		input  logic clk,

		input  logic [N-1:0] pc_address,	// from PC to A in instruction memory
		input  logic [N-1:0] data_address_scalar,	// from ALUResult to A in data memory
	//	input  logic [N-1:0] data_address_vector,	// NYI: not yet implemented

		input  logic [N-1:0] write_data_scalar,		// WriteData (RD2 from register file) to WD
	//	input  logic [255:0] write_data_vector,		// NYI

		input  logic MemWrite_scalar,				// Control Signal: MemWrite from Control Unit 
		input  logic MemWrite_vector,				// Control Signal: NYI
	
		output logic [N-1:0] instruction,			// to Instruction after instruction memory
		output logic [N-1:0] read_data_scalar,		// ReadData from RD in data memory to MemtoRegMux
	//	output logic [255:0] read_data_vector		// NYI
	);

	// Specific addresses for ips
	logic [13:0] in_address;
	logic [13:0] sd_address;	// 16384 addresses of 24 bits
	logic [14:0] vd_address;	// 32768 addresses of 256 bits

	// Bus length adjust
	assign in_address = pc_address[13:0];
	assign sd_address = data_address_scalar[13:0];
	assign vd_address = data_address_vector[14:0];

	
	/* Instruction memory */
	instruction_memory_v2 #(.N(N)) inst_memory (.address(in_address),
								  	   			.instruction(instruction));


	/* Scalar data mamory */
	data_memory ram_scalar_memory (.address(sd_address),
								  .clock(clk),
								  .data(write_data_scalar),
								  .wren(MemWrite_scalar),
								  .q(read_data_scalar));


	/* Vector Data Memory */ /*
	ram_vector ram_scalar_memory (.address(vd_address),
								  .clock(clk),
								  .data(write_data_vector),
								  .rden(1'b1),
								  .wren(MemWrite_vector),
								  .q(read_data_vector));
	*/

endmodule
