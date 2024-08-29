/*
Testbench for Fetch module
Date: 28/08/24
*/
module fetch_tb;

	parameter N = 32;

	logic clk;
	logic rst;
	logic [N-1:0] ResultW;
	logic [N-1:0] ExtImmE;
	logic PCSrcW;
	logic BranchTakenE;
	logic StallF;
	logic StallD;
	logic FlushD;
	logic [N-1:0] instruction;
	/* */
	logic V;
	logic [2:0] opcode;
	/* */
	logic [N-1:0] PCF;
	logic [N-1:0] InstrD;
	logic [N-1:0] InstrD_vector;
	logic [N-1:0] PCPlus8D;

	/* internal signals */
	// logic [N-1:0] PCPlus4F;
	// logic [N-1:0] PCJump;
	// logic [N-1:0] NPC;
	// logic [N-1:0] InstF;
	// logic [N-1:0] InstF_vector;

	
	// CAMBIAR LOGICA DE INSTRUCCION A 32 BITS
	assign V = instruction[20];
	assign opcode = instruction[23:21];

	fetch # (.N(N)) uut (.clk(clk),
						 .rst(rst),
						 .ResultW(ResultW),
						 .ExtImmE(ExtImmE),
						 .PCSrcW(PCSrcW),
						 .BranchTakenE(BranchTakenE),
						 .StallF(StallF),
						 .StallD(StallD),
						 .FlushD(FlushD),
						 .instruction(instruction),

						 .PCF(PCF),
						 .InstrD(InstrD),
						 .PCPlus8D(PCPlus8D));

	instruction_memory # (.N(N)) inst_mem_ut (.address(PCF),
												 .instruction(instruction));
				
	// Initialize inputs
    initial begin
		$display("fetch stage module testbench:\n");

		clk = 0;
		ResultW = 32'b0;
		ExtImmE = 32'b0;
		PCSrcW = 1'b0;
		BranchTakenE = 1'b0;
		StallF = 1'b1; // enable pc register
		StallD = 1'b1; // enable pipeline register 
		FlushD = 1'b0; // clear pipeline register
        
        /*
        $monitor("Register_v2 Signals:\n",
                 "RegIn = %b (%h)\n", RegIn, RegIn,
                 "WriteEn = %b\n", WriteEn,
                 "RegOut = %b (%h)\n\n\n", RegOut, RegOut);*/
    end

    always begin
		#50 clk = !clk;
		// PCPlus4F = uut.PCPlus4F;
		// PCJump = uut.PCJump;
		// NPC = uut.NPC;
		// InstF = uut.InstF;
		// InstF_vector = uut.InstF_vector;
    end

    initial	begin

        #200

        rst = 1;

        #100

        rst = 0;

        #100

 

        #100;

		// Done

    end

    initial
	#3600 $finish;                                 

endmodule
