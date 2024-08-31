/*
Test bench for Fetch module
Date: 28/08/24
Approved
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
	logic [N-1:0] InstrF;

	logic [N-1:0] PCF;
	logic [N-1:0] InstrD;
	logic [N-1:0] PCPlus8D;

	/* internal signals */
	logic [N-1:0] PCPlus4F;
	logic [N-1:0] PCJump;
	logic [N-1:0] NPC;
	// logic [N-1:0] InstF;

	/* Fetch unit under testing */
	fetch # (.N(N)) uut (.clk(clk),
						 .rst(rst),
						 .ResultW(ResultW),
						 .ExtImmE(ExtImmE),
						 .PCSrcW(PCSrcW),
						 .BranchTakenE(BranchTakenE),
						 .StallF(StallF),
						 .StallD(StallD),
						 .FlushD(FlushD),
						 .InstrF(InstrF),

						 .PCF(PCF),
						 .InstrD(InstrD),
						 .PCPlus8D(PCPlus8D));

	/* Instruction_memory unit instance for fetch unit */
	instruction_memory # (.N(N)) inst_mem_ut (.address(PCF),
											  .instruction(InstrF));
				
	// Initialize inputs
    initial begin
		$display("fetch stage module testbench:\n");

		clk = 0;
		ResultW = 32'b0;
		ExtImmE = 32'b0;
		PCSrcW = 1'b0;
		BranchTakenE = 1'b0; // source mux_PCfromALU
		StallF = 1'b0; // enable pc register
		StallD = 1'b0; // enable pipeline register
		FlushD = 1'b0; // clear pipeline register
        
        
        $monitor("Fetch Signals:\n",
                 "PCSrcW (mux_PCfromResult source) = %b\n", PCSrcW,
                 "[1]: ResultW = %b (%d)", ResultW, ResultW,
				 " || ",
                 "[0]: PCPlus4F = %b (%d)\n", PCPlus4F, PCPlus4F,
				 "BranchTakenE (mux_PCfromALU source) = %b\n", BranchTakenE,
                 "[0]: PCJump = %b (%d)", PCJump, PCJump,
				 " || ",
                 "[1]: ExtImmE = %b (%d)\n", ExtImmE, ExtImmE,
				 "NPC = %b (%d)\n", NPC, NPC,
				 "StallF (program_counter !enable) = %b\n", StallF,
				 "PCF (instruction address) = %b (%d)\n", PCF, PCF,
                 "InstrF = %b (%h)\n\n\n", InstrF, InstrF);
    end

    always begin
		#50 clk = !clk;
		//PCPlus4F = uut.PCPlus4F;
		//PCJump = uut.PCJump;
		//NPC = uut.NPC;
    end

    initial	begin

        #200

        rst = 1;

        #100

        rst = 0;

        #100

		ResultW = 32'b0;
		ExtImmE = 32'b0;
		PCSrcW = 1'b0; // PC+4
		BranchTakenE = 1'b0; // no branch
		StallF = 1'b0;
		StallD = 1'b0;
		FlushD = 1'b0;

        #100;

		// Done

    end

    initial
	#3600 $finish;                                 

endmodule
