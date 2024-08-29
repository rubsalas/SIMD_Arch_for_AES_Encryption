/*
Pipeline's Fetch Stage
Date: 28/08/24
Test bench ran: 29/08/24 
*/
module fetch # (parameter N = 32) (
		input  logic 				  clk,
		input  logic 				  rst,
		input  logic [N-1:0] 	  ResultW, // mux_ResultW output (writeback)
		input  logic [N-1:0] 	  ExtImmE, // extend output (execute)
		input  logic 			   PCSrcW, // mux_PCfromResult control
		input  logic 		 BranchTakenE, // mux_PCfromALU control
		input  logic 			   StallF, // register enable
		input  logic 			   StallD, // register_FD clear
		input  logic 			   FlushD, // register_FD clear
		input  logic [N-1:0]  	   InstrF, /* Input from Memory */ // L = InstrF / RG = instruction

		output logic [N-1:0] 		  PCF, /* Output to Memory */ // L = PCF / RG = pc_address
		output logic [N-1:0] 	   InstrD,
		output logic [N-1:0] 	 PCPlus8D
	);

	/* wiring */
	logic [N-1:0] PCPlus4F;
	logic [N-1:0] PCJump;
	logic [N-1:0] NPC; // L = PC' / RG = next_pc_address
	
	/* PC from Result Mux */
	mux_2NtoN # (.N(N)) mux_PCfromResult (.I0(PCPlus4F),
										  .I1(ResultW),
										  .rst(rst),
										  .S(PCSrcW),
										  .en(1'b1),
										  .O(PCJump));
	
	/* PC from ALU Mux */
	mux_2NtoN # (.N(N)) mux_PCfromALU (.I0(PCJump),
									   .I1(ExtImmE),
									   .rst(rst),
									   .S(BranchTakenE),
									   .en(1'b1),
									   .O(NPC));
		
	/* PC Register */
	register # (.N(N)) program_counter (.clk(clk),
										.rst(rst),
										.en(!StallF), /* Neg enable */
										.D(NPC),
										.Q(PCF));
	
	/* PCPlus4_Adder */
	single_adder # (.N(N)) pc_plus_4_adder (.A(PCF),
									  		.B(32'h4),	// instruction memory's address convention
									  		.Y(PCPlus4F));
	
	/* PCPlus8D goes into Register File in next stage */
	assign PCPlus8D = PCPlus4F;
	
	
	/* Pipeline Register Fetch-Decode Stages */
	register_FD # (.N(N)) reg_FD (.clk(clk),
								  .rst(rst),
								  .en(!StallD), /* Neg enable */
								  .clr(FlushD),
								  .InstrF(InstrF),
								  .InstrD(InstrD));

endmodule
