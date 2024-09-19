/*
Register between Fetch and Decode stages at the pipeline datapath.
Date: 27/08/24
Test bench ran: 29/08/24
*/
module register_FD # (parameter N = 32) (
		input  logic 		 clk,
		input  logic 		 rst,
		input  logic 		 en,		// StallD (from hazard_unit) /* neg enable */
		input  logic 		 clr,		// FlushD (from hazard_unit)
		input  logic [N-1:0] InstrF,	// InstrF (RD from instruction memory)  // L = InstrF / RG = instruction
		
		output logic [N-1:0] InstrD		// InstrD (to decode)
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
