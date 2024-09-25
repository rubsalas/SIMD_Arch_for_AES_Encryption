/*
Register between Memory and Writeback stages at the pipeline datapath.
Date: 25/09/24
Test bench ran: XX/09/24
*/
module register_MW # (parameter N = 32, parameter V = 256, parameter R = 5) (
		input  logic clk,
		input  logic rst,
		input  logic en,			// StallW (from hazard_unit) /* neg enable */
		/* control signals inputs */
		input  logic PCSrcM,
		input  logic RegWriteM,
		input  logic RegWriteVM,
		input  logic MemtoRegM,
		/* data inputs */
		input  logic [N-1:0] ALUResultM,
		input  logic [N-1:0] ReadDataM,
		input  logic [V-1:0] ALUResultVM,
		input  logic [V-1:0] ReadDataVM,

		input  logic [R-1:0] WA3M,

		/* control signal outputs */
		output logic PCSrcW,
		output logic RegWriteW,
		output logic RegWriteVW,
		output logic MemtoRegW,
		/* data outputs */
		output logic [N-1:0] ALUResultW,
		output logic [N-1:0] ReadDataW,
		output logic [V-1:0] ALUResultVW,
		output logic [V-1:0] ReadDataVW,

		output logic [R-1:0] WA3W
	);
					
	always_ff @ (posedge clk) begin

		if (rst) begin
			PCSrcW <= 1'b0;
			RegWriteW <= 1'b0;
			RegWriteVW <= 1'b0;
			MemtoRegW <= 1'b0;

			ALUResultW <= 32'b0;
			ReadDataW <= 32'b0;
			ALUResultVW <= 256'b0;
			ReadDataVW <= 256'b0;

			WA3W <= 5'b0;
			
		end

		else if (en) begin
			PCSrcW <= PCSrcM;
			RegWriteW <= RegWriteM;
			RegWriteVW <= RegWriteVM;
			MemtoRegW <= MemtoRegM;

			ALUResultW <= ALUResultM;
			ReadDataW <= ReadDataM;
			ALUResultVW <= ALUResultVM;
			ReadDataVW <= ReadDataVM;

			WA3W <= WA3M;
		end

	end

endmodule
