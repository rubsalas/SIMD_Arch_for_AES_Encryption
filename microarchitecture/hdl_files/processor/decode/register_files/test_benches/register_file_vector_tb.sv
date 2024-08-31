/*
Test bench for Register_file_vector module
Date: 30/08/24
Approved
*/
module register_file_vector_tb;

	parameter N = 256;

	logic         clk;
	logic         rst;
	logic [4:0]    VA1;     // RA1D
	logic [4:0]    VA2;     // RA2D
	logic [4:0]    VA3;     // WA3W
	logic [N-1:0] VWD3;     // ResultW
	logic         VWE3;     // RegWriteW

	logic [N-1:0] VRD1;     // RD1
	logic [N-1:0] VRD2;     // RD2

	// Registers
	logic [N-1:0] reg_array_vector [7:0];

	/* register_file_vector unit under testing */
	register_file_vector # (.N(N)) uut (.clk(clk),
										.rst(rst),
										.VA1(VA1),
										.VA2(VA2),
										.VA3(VA3),
										.VWD3(VWD3),
										.VWE3(VWE3),
										.VRD1(VRD1),
										.VRD2(VRD2));

				
	// Initialize inputs
    initial begin
		$display("register_file_vector module testbench:\n");

		clk = 0;
		rst = 1'b0;
		VA1 = 5'b0;
		VA2 = 5'b0;
		VA3 = 5'b0;
		VWD3 = 256'b0;
		VWE3 = 1'b0;
        
        $monitor("Register File Vector Signals:\n",

				"10000: $v0 = (%h)\n", reg_array_vector[0],
				"10001: $v1 = (%h)\n", reg_array_vector[1],
				"10010: $v2 = (%h)\n", reg_array_vector[2],
				"10011: $v3 = (%h)\n", reg_array_vector[3],
				"10100: $v4 = (%h)\n", reg_array_vector[4],
				"10101: $v5 = (%h)\n", reg_array_vector[5],
				"10110: $v6 = (%h)\n", reg_array_vector[6],
				"10111: $v7 = (%h)\n", reg_array_vector[7],
				"VWE3 = %b\n", VWE3,
				"VA1 = %b (%d) | VA2 = %b (%d)\n", VA1, VA1, VA2, VA2,
				"VRD1 = (%h) | VRD2 = (%h)\n", VRD1, VRD2,
				"VA3 = %b (%d)\n", VA3, VA3,
				"VWD3 = (%h)\n", VWD3);
    end

    always begin
		#50 clk = !clk;
		reg_array_vector = uut.reg_array_vector;
    end

    initial	begin

        #200

        rst = 1;

        #100

        rst = 0;

        #100

		VA1 = 5'b10000;
		VA2 = 5'b10001;
		VA3 = 5'b10110;
		VWD3 = 256'b0;
		VWE3 = 1'b0;

		#100

		VWD3 = 256'b110110;
		VWE3 = 1'b0;

		#100

		VWD3 = 256'b1010101;
		VWE3 = 1'b1;

		#100

		VA1 = 5'b10110;
		VA2 = 5'b10001;
		VA3 = 5'b10000;
		VWD3 = 256'b1100;
		VWE3 = 1'b0;

		#100

		VA1 = 5'b10010;
		VA2 = 5'b10110;
		VWD3 = 256'b11001100;
		VWE3 = 1'b1;

		#100

		VA1 = 5'b10000;
		VA2 = 5'b10110;
		VA3 = 5'b10110;
		VWD3 = 256'b0;
		VWE3 = 1'b0;

		#100

		// Vector registers' address
		VA1 = 5'b01011;
		VA2 = 5'b01001;

        #100;

		// Done

    end

    initial
	#3600 $finish;                                 

endmodule