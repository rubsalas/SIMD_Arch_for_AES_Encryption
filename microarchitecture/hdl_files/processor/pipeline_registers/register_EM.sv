/*
Register between Execute and Memory stages at the pipeline datapath.
Date: 24/09/24
Test bench ran: XX/09/24
*/
module register_EM # (parameter N = 32, parameter V = 256, parameter R = 5) (
		input  logic clk,
		input  logic rst,
		input  logic en,		// StallM (from hazard_unit) /* neg enable */
		
		input  logic PCSrcE,
		input  logic RegWriteE,
		input  logic RegWriteVE,

		input  logic MemtoRegE,
		
		input  logic MemWriteE,
		input  logic MemSrcE,
		input  logic MemDataE,
		input  logic MemDataVE,
		input  logic VecDataE,

		input  logic [N-1:0] ALUResultE,
		input  logic [N-1:0] WriteDataE,
		input  logic [V-1:0] ALUResultVE,
		input  logic [V-1:0] WriteDataVE,

		input  logic [R-1:0] WA3E,


		output logic PCSrcM,
		output logic RegWriteM,
		output logic RegWriteVM,

		output logic MemtoRegM,

		output logic MemWriteM,
		output logic MemSrcM,
		output logic MemDataM,
		output logic MemDataVM,
		output logic VecDataM,

		output logic [N-1:0] ALUResultM,
		output logic [N-1:0] WriteDataM,
		output logic [V-1:0] ALUResultVM,
		output logic [V-1:0] WriteDataVM,

		output logic [R-1:0] WA3M
	);
					
	always_ff @ (posedge clk) begin

		if (rst) begin
			PCSrcM <= 1'b0;
			RegWriteM <= 1'b0;
			RegWriteVM <= 1'b0;

			MemtoRegM <= 1'b0;

			MemWriteM <= 1'b0;
			MemSrcM <= 1'b0;
			MemDataM <= 1'b0;
			MemDataVM <= 1'b0;
			VecDataM <= 1'b0;
			
			ALUResultM <= 32'b0;
			WriteDataM <= 32'b0;
			ALUResultVM <= 256'b0;
			WriteDataVM <= 256'b0;

			WA3M <= 5'b0;
		end

		else if (en) begin
			PCSrcM <= PCSrcE;
			RegWriteM <= RegWriteE;
			RegWriteVM <= RegWriteVE;

			MemtoRegM <= MemtoRegE;
			
			MemWriteM <= MemWriteE;
			MemSrcM <= MemSrcE;
			MemDataM <= MemDataE;
			MemDataVM <= MemDataVE;
			VecDataM <= VecDataE;
			
			ALUResultM <= ALUResultE;
			WriteDataM <= WriteDataE;
			ALUResultVM <= ALUResultVE;
			WriteDataVM <= WriteDataVE;
			
			WA3M <= WA3E;
		end

	end

endmodule
