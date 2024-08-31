/*
Testbench for register module
Date: 27/08/24
Approved
*/
module register_tb;

	timeunit 1ps;
  	timeprecision 1ps;

  	parameter N = 32;

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
		RegIn = 32'b0;
		WriteEn = 0;
        
        
        $monitor("Register Signals:\n",
				 "rst = %b\n", rst,
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

        RegIn = 32'h11111;

        #200

        WriteEn = 1;

        #200

        WriteEn = 0;

        #200

        WriteEn = 1;

        #200

        WriteEn = 0;

        #200

        RegIn = 32'hAAAAA;
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
        RegIn = 32'h44444;
        WriteEn = 1;

        #200

        RegIn = 32'h77777;

        #200

        RegIn = 32'h22222;

        #200

        RegIn = 32'hEEEEE;
        WriteEn = 0;

        #200

        RegIn = 32'h00000;

        #100;

		// Done

    end

    initial
	#3600 $finish;                                 

endmodule
