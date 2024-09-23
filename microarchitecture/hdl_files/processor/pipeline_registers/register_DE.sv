/*
Register between Decode and Execute stages at the pipeline datapath.
Date: 20/09/24
Test bench ran: XX/09/24
*/
module register_DE # (parameter N = 32, parameter V = 256, parameter R = 5) (
		input  logic clk,
		input  logic rst,
		input  logic en,		// StallE (from hazard_unit) /* neg enable */
		input  logic clr,		// FlushE (from hazard_unit)

		input  logic PCSrcD,
		input  logic RegWriteD,
		input  logic RegWriteVD,

		input  logic MemtoRegD,
		
		input  logic MemWriteD,
		input  logic MemSrcD,
		input  logic MemDataD,
		input  logic MemDataVD,
		input  logic VecDataD,
		
		input  logic [1:0] InstrSelD,
		input  logic [2:0] ALUControlD,
		input  logic BranchD,
		input  logic ALUSrcD,
		
		input  logic [R-1:0] RA1D,		// RA1DH
		input  logic [R-1:0] RA2D,		// RA2DH

		input  logic [N-1:0] RD1D,
		input  logic [N-1:0] RD2D,
		input  logic [255:0] VRD1D,
		input  logic [255:0] VRD2D,

		input  logic [R-1:0] WA3D,
		input  logic [N-1:0] ExtImmD,

		
		output logic PCSrcE,
		output logic RegWriteE,
		output logic RegWriteVE,
		
		output logic MemtoRegE,

		output logic MemWriteE,
		output logic MemSrcE,
		output logic MemDataE,
		output logic MemDataVE,
		output logic VecDataE,

		output logic [1:0] InstrSelE,
		output logic [2:0] ALUControlE, 
		output logic BranchE,
		output logic ALUSrcE,

		output logic [R-1:0] RA1E,
		output logic [R-1:0] RA2E,

		output logic [N-1:0] RD1E,
		output logic [N-1:0] RD2E,
		output logic [V-1:0] VRD1E,
		output logic [V-1:0] VRD2E,

		output logic [R-1:0] WA3E,
		output logic [N-1:0] ExtImmE
	);
					

	always_ff @(posedge clk) begin

		if (clr || rst) begin
			PCSrcE <= 1'b0;
			RegWriteE <= 1'b0;
			RegWriteVE <= 1'b0;

			MemtoRegE <= 1'b0;

			MemWriteE <= 1'b0;
			MemSrcE <= 1'b0;
			MemDataE <= 1'b0;
			MemDataVE <= 1'b0;
			VecDataE <= 1'b0;
			
			InstrSelE <= 2'b0;
			ALUControlE <= 3'b0;
			BranchE <= 1'b0;
			ALUSrcE <= 1'b0;

			RA1E <= 5'b0;
			RA2E <= 5'b0;

			RD1E <= 32'b0;
			RD2E <= 32'b0;
			VRD1E <= 256'b0;
			VRD2E <= 256'b0;

			WA3E <= 5'b0;
			ExtImmE <= 32'b0;
		end

		else if (en) begin
			PCSrcE <= PCSrcD;
			RegWriteE <= RegWriteD;
			RegWriteVE <= RegWriteVD;

			MemtoRegE <= MemtoRegD;

			MemWriteE <= MemWriteD;
			MemSrcE <= MemSrcD;
			MemDataE <= MemDataD;
			MemDataVE <= MemDataVD;
			VecDataE <= VecDataD;
			
			InstrSelE <= InstrSelD;
			ALUControlE <= ALUControlD;
			BranchE <= BranchD;
			ALUSrcE <= ALUSrcD;

			RA1E <= RA1D;
			RA2E <= RA2D;

			RD1E <= RD1D;
			RD2E <= RD2D;
			VRD1E <= VRD1D;
			VRD2E <= VRD2D;

			WA3E <= WA3D;
			ExtImmE <= ExtImmD;
		end

	end

endmodule
