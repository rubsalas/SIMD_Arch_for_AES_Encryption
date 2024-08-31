/*
Test bench for extend module.
Date: 30/08/24
Approved
*/
module extend_tb;

	timeunit 1ps;
  	timeprecision 1ps;

  	parameter N = 32;

	logic [25:0] A;
   	logic [1:0] ImmSrc;
   	logic [N-1:0] ExtImm;

	extend # (.N(N)) uut (.A(A),
						  .ImmSrc(ImmSrc),
						  .ExtImm(ExtImm));

	initial begin
		$display("Extend test bench:\n");

		A <= 26'b0;
		ImmSrc <= 2'b0;

		$monitor("A=%b ImmSrc=%b\n", A, ImmSrc,
             	 "ExtImm=%b\n", ExtImm);
	end
	
	initial	begin

		#100

		A <= 26'b10010010010101011111111000;

		#100

		ImmSrc <= 2'b00;

		#100
		
		assert((ExtImm === 32'b00000000000000000101011111111000))
		else $error("Failed when ImmSrc=%b", ImmSrc);
		
		#100

		ImmSrc <= 2'b01;

		#100
		
		assert((ExtImm === 32'b00000010010010010101011111111000))
		else $error("Failed when ImmSrc=%b", ImmSrc);
		
		#100
		
		ImmSrc <= 2'b11;

		#100
		
		assert((ExtImm === 32'b00000000000000000000000011111111))
		else $error("Failed when ImmSrc=%b", ImmSrc);

		#100;

		// Done
		
    end

endmodule
