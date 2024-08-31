/*
Register for Fetch and Decode pipeline datapath.
Date: 27/08/24
Test bench ran: 29/08/24
*/
module register_FD # (parameter N = 32) (
		input  logic 		 clk,
		input  logic 		 rst,
		input  logic 		 en,
		input  logic 		 clr,
		input  logic [N-1:0] InstrF,
		output logic [N-1:0] InstrD
	);
					
	always_ff @ (posedge clk) begin

		if (clr || rst) begin
			InstrD <= 32'b0;
		end

		else if (en) begin
			InstrD <= InstrF;
		end

	end

endmodule
