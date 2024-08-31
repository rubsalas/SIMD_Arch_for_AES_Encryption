/*
Test bench for Register_file module
Date: 30/08/24
Approved
*/
module register_file_tb;

	parameter N = 32;

	logic         clk;
	logic         rst;
	logic [4:0]    A1;     // RA1D
	logic [4:0]    A2;     // RA2D
	logic [4:0]    A3;     // WA3W
	logic [N-1:0] WD3;     // ResultW
	logic [N-1:0] R15;     // PCPlus8D
	logic         WE3;     // RegWriteW

	logic [N-1:0] RD1;     // RD1
	logic [N-1:0] RD2;     // RD2

	// Registers
	logic [N-1:0] reg_array [15:0];

	/* register_file unit under testing */
	register_file # (.N(N)) uut (.clk(clk),
								 .rst(rst),
								 .A1(A1),
								 .A2(A2),
								 .A3(A3),
								 .WD3(WD3),
								 .R15(R15),
								 .WE3(WE3),
								 .RD1(RD1),
								 .RD2(RD2));

				
	// Initialize inputs
    initial begin
		$display("register_file module testbench:\n");

		clk = 0;
		rst = 1'b0;
		A1 = 5'b0;
		A2 = 5'b0;
		A3 = 5'b0;
		WD3 = 32'b0;
		R15 = 32'b0;
		WE3 = 1'b0;
        
        
        $monitor("Register File Signals:\n",

				"00000: $zero = %b (%h)\n", reg_array[0], reg_array[0],
				"00001: $sp = %b (%h)\n", reg_array[1], reg_array[1],
				"00010: $lr = %b (%h)\n", reg_array[2], reg_array[2],
				"00011: $cpsr = %b (%h)\n", reg_array[3], reg_array[3],
				"00100: $r0 = %b (%h)\n", reg_array[4], reg_array[4],
				"00101: $r1 = %b (%h)\n", reg_array[5], reg_array[5],
				"00110: $r2 = %b (%h)\n", reg_array[6], reg_array[6],
				"00111: $r3 = %b (%h)\n", reg_array[7], reg_array[7],
				"01000: $e0 = %b (%h)\n", reg_array[8], reg_array[8],
				"01001: $e1 = %b (%h)\n", reg_array[9], reg_array[9],
				"01010: $e2 = %b (%h)\n", reg_array[10], reg_array[10],
				"01011: $e3 = %b (%h)\n", reg_array[11], reg_array[11],
				"01100: $e4 = %b (%h)\n", reg_array[12], reg_array[12],
				"01101: $e5 = %b (%h)\n", reg_array[13], reg_array[13],
				"01110: $e6 = %b (%h)\n", reg_array[14], reg_array[14],
				"01111: $pc = %b (%h)\n", reg_array[15], reg_array[15],
				"WE3 = %b\n", WE3,
				"A1 = %b (%d) | A2 = %b (%d)\n", A1, A1, A2, A2,
				"RD1 = %b (%h) | RD2 = %b (%h)\n", RD1, RD1, RD2, RD2,
				"A3 = %b (%d)\n", A3, A3,
				"WD3 = %b (%h)\n", WD3, WD3,
				"R15 = %b (%d)\n", R15, R15);
    end

    always begin
		#50 clk = !clk;

		reg_array = uut.reg_array;
    end

    initial	begin

        #200

        rst = 1;

        #100

        rst = 0;

        #100

		A1 = 5'b1000;
		A2 = 5'b1001;
		A3 = 5'b1110;
		WD3 = 32'b0;
		R15 = 32'b0;
		WE3 = 1'b0;

		#100

		WD3 = 32'b110110;
		R15 = 32'b100;
		WE3 = 1'b0;

		#100

		WD3 = 32'b1010101;
		R15 = 32'b1000;
		WE3 = 1'b1;

		#100

		A1 = 5'b1110;
		A2 = 5'b1001;
		A3 = 5'b1000;
		WD3 = 32'b1100;
		R15 = 32'b1100;
		WE3 = 1'b0;

		#100

		A1 = 5'b1010;
		A2 = 5'b1110;
		WD3 = 32'b11001100;
		R15 = 32'b10000;
		WE3 = 1'b1;

		#100

		A1 = 5'b1000;
		A2 = 5'b1110;
		A3 = 5'b1110;
		WD3 = 32'b0;
		R15 = 32'b10100;
		WE3 = 1'b0;

		#100

		// Vector registers' address
		A1 = 5'b11000;
		A2 = 5'b10110;

        #100;

		// Done

    end

    initial
	#3600 $finish;                                 

endmodule