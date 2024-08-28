/*
Test Bench para MUX 2:1 parametrizable para N bits
Date: 27/08/24
*/
module mux2NtoN_tb;

	parameter integer N = 32;

	reg  [N-1:0] I0;
	reg  [N-1:0] I1;
	reg   	      S;
	reg 	 en;
	wire [N-1:0]  O;	

	mux_2NtoN # (.N(N)) uut (.I0(I0),
							 .I1(I1),
							 .S(S),
							 .en(en),
							 .O(O));

	initial begin
		$display("mux2NtoN Test Bench:\n");

		I0 <= 32'b0;
		I1 <= 32'b0;
		S <= 0;
		en <= 0;

		$monitor("S=%b en=%b\n", S, en,
				 "I0=%b I1=%b\n", I0, I1,
				 "O=%b\n", O);
	end
	
	initial	begin
	
		#100

		en = 1;

		#100

		I0 <= 32'b11100101100111110001000000100000;
		I1 <= 32'b10101010000000000000000000000100;
		S <= 1;

		#100
		
		assert((O === 32'b10101010000000000000000000000100))
		else $error("Failed when S=%b with en=%b", S, en);
		
		#100
		
		I0 <= 32'b11100011101000000000000000000000;
		I1 <= 32'b11100001101000000010000010100010;
		S <= 0;

		#100
		
		assert((O === 32'b11100011101000000000000000000000))
		else $error("Failed when S=%b with en=%b", S, en);

		#100

		en = 0;

		#100

		I0 <= 32'b11100101100111110001000000100000;
		I1 <= 32'b10101010000000000000000000000100;
		S <= 1;

		#100
		
		assert((O === 32'b0))
		else $error("Failed when S=%b with en=%b", S, en);
		
		#100
		
		I0 <= 32'b11100011101000000000000000000000;
		I1 <= 32'b11100001101000000010000010100010;
		S <= 0;

		#100
		
		assert((O === 32'b0))
		else $error("Failed when S=%b with en=%b", S, en);

		#100;

		// Done
		
    end

endmodule
