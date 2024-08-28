/*
Testbench for register_v2 module
Date: 27/08/24
*/
module register_tb;

	timeunit 1ps;
  	timeprecision 1ps;

  	parameter N = 24;

	logic	      clk;
	logic	      rst;
	logic [N-1:0] RegIn;
	logic         WriteEn;
	logic [N-1:0] RegOut;

	/* Register unit under testing */
	register # (.N(N)) uut (.clk(clk),
							   .rst(rst),
							   .en(WriteEn),
							   .D(RegIn),
							   .Q(RegOut));
	
    // Initialize inputs
    initial begin
		$display("register testbench:\n");

		clk = 1;
		rst = 0;
		RegIn = 24'b0;
		WriteEn = 0;
        
        
        $monitor("Register Signals:\n",
                 "RegIn = %b (%h)\n", RegIn, RegIn,
                 "WriteEn = %b\n", WriteEn,
                 "RegOut = %b (%h)\n\n\n", RegOut, RegOut);
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

        RegIn = 24'h11111;

        #200

        WriteEn = 1;

        #200

        WriteEn = 0;

        #200

        WriteEn = 1;

        #200

        WriteEn = 0;

        #200

        RegIn = 24'hAAAAA;
        WriteEn = 1;

        #200

        WriteEn = 0;

        #200

        WriteEn = 1;

        #200

        WriteEn = 0;

        #200

        rst = 1;

        #200

        rst = 0;
        RegIn = 24'h44444;
        WriteEn = 1;

        #200

        RegIn = 24'h77777;

        #200

        RegIn = 24'h22222;

        #200

        RegIn = 24'hEEEEE;
        WriteEn = 0;

        #200

        RegIn = 24'h00000;

        #100;

		// Done

    end

    initial
	#3600 $finish;                                 

endmodule
