/*
Test bench for register_FD module
Date: 28/08/24
Approved
*/
module register_FD_tb;

	timeunit 1ps;
  	timeprecision 1ps;

  	parameter N = 32;

	logic	         clk;
	logic	         rst;
	logic         StallD; //en;
	logic         FlushD; //clr;
	logic [N-1:0] InstrF;
	logic [N-1:0] InstrD;

	/* Register_FD unit under testing */
	register_FD # (.N(N)) uut (.clk(clk),
							   .rst(rst),
							   .en(!StallD), /* Neg enable */
							   .clr(FlushD),
							   .InstrF(InstrF),
							   .InstrD(InstrD));
	
    // Initialize inputs
    initial begin
		$display("register_FD testbench:\n");

		clk = 1;
		rst = 0;
		StallD = 1;
		FlushD = 0;
		InstrF = 32'b0;
        
        $monitor("Register_FD Signals:\n",
				 "rst = %b\n", rst,
                 "en (!StallD) = %b\n", !StallD,
                 "clr (FlushD) = %b\n", FlushD,
                 "InstrF = %b\n", InstrF,
                 "InstrD = %b\n\n\n", InstrD);
    end

    always begin
		#50 clk = !clk;
    end

    initial	begin

        #300

        rst = 1;

        #200

        rst = 0;

        #200

        InstrF = 32'b10011000000000000000000100000000;

        #200

        StallD = 0; //en = 1

        #200

        StallD = 1; //en = 0

		#200

        InstrF = 32'b00001000100000000110001100000000;

		#200

        FlushD = 1;

		#200

        InstrF = 32'b01001001100000000000000000000000;

		#200

        FlushD = 0;

		#200

        StallD = 0; //en = 1

		#200

        InstrF = 32'b11101000100100000000000000000000;

		#200

        StallD = 1; //en = 0

        #100;

		// Done

    end

    initial
	#3600 $finish;                                 

endmodule
