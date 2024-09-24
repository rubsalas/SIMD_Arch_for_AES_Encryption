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
			PCSrcE <= 1'b0;
			RegWriteE <= 1'b0;
			RegWriteVE <= 1'b0;

			MemtoRegE <= 1'b0;

			MemWriteE <= 1'b0;
			MemSrcE <= 1'b0;
			MemDataE <= 1'b0;
			MemDataVE <= 1'b0;
			VecDataE <= 1'b0;
			
			ALUResultE <= 32'b0;
			WriteDataE <= 32'b0;
			ALUResultVE <= 32'b0;
			WriteDataVE <= 32'b0;

			WA3E <= 32'b0;
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
