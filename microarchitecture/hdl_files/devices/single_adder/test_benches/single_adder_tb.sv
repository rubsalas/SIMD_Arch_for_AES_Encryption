/*
Test bench for single_adder module.
Date: 28/08/24
Approved
*/
module single_adder_tb;

	timeunit 1ps;
  	timeprecision 1ps;

  	parameter N = 32;

	logic [N-1:0] A;
   	logic [N-1:0] B;
   	logic [N-1:0] Y;

	single_adder # (.N(N)) uut (.A(A),
							 .B(B),
							 .Y(Y));

	initial begin
		$display("single_adder Test Bench:\n");

		A <= 32'b0;
		B <= 32'b0;

		$monitor("A + B = Y",
				 "%b (%d) + %b (%d) = %b (%d)\n",  A,A, B,B, Y,Y);
	end
	
	initial	begin

		#100

		A <= 32'b11100101100111110001000000100000;
		B <= 32'b0;

		#100
		
		assert((Y === 32'b11100101100111110001000000100000))
		else $error("Failed when A=%b + B=%b", A, B);
		
		#100
		
		A <= 32'b11100101100111110001000000100000;
		B <= 32'b100;

		#100
		
		assert((Y === 32'b11100101100111110001000000100100))
		else $error("Failed when A=%b + B=%b", A, B);
		
		#100
		
		A <= 32'b100;
		B <= 32'b11100101100111110001000000100000;

		#100
		
		assert((Y === 32'b11100101100111110001000000100100))
		else $error("Failed when A=%b + B=%b", A, B);
		
		#100
		
		A <= 32'b00101000101001000100111010101111;
		B <= 32'b10101000100101011101001001110101;
		
		#100
		
		assert((Y === 32'b11010001001110100010000100100100))
		else $error("Failed when A=%b + B=%b", A, B);

		#100;

		// Done
		
    end

endmodule
