/*
Control Unit v2 module 
Date: 07/04/2024
*/
module control_unit(		
		input  logic [2:0] Opcode,
		input  logic [2:0] Func,
		input  logic [3:0] Rd,

		output logic PCSrc,
		output logic RegWrite,
		output logic MemtoReg,
		output logic MemWrite,
		output logic [2:0] ALUControl,
		output logic ALUSel, // added
		output logic Branch,
		output logic ALUSrc,
		output logic [1:0] FlagWrite,
		output logic [1:0] ImmSrc,
		output logic [1:0] RegSrc,
		output logic Stuck /* A added */
	);

    wire wAluOp;

    /* PC Logic */
    pc_logic pc_l (.Rd(Rd),
                   .Branch(Branch),
                   .RegW(RegWrite),
                   .PCS(PCSrc));

    /* Main Decoder */
    main_decoder_v2 main_deco (.Opcode(Opcode),
                            .S(S),
                            .Func(Func),
                            .Branch(Branch),
                            .RegSrc(RegSrc),
                            .RegW(RegWrite),
                            .MemW(MemWrite),
                            .MemtoReg(MemtoReg),
                            .ALUSrc(ALUSrc),
                            .ImmSrc(ImmSrc),
                            .ALUOp(wAluOp));

    /* ALU Decoder */
    alu_decoder_v2 alu_deco (.Opcode(Opcode),
                             .S(S),
                             .Func(Func),
                             .ALUOp(wAluOp),
                             .ALUSel(ALUSel),
                             .ALUControl(ALUControl),
						     .FlagWrite(FlagWrite));

	// *
	assign FlagWrite = 2'b11;
	// ** Revisar cuando se revise de donde vendrá el Stuck
	assign Stuck = 1'b0;
	

endmodule
