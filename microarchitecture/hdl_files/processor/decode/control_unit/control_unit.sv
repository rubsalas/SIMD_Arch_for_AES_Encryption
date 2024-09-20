/*
Control Unit v2 module 
Date: 07/04/2024
*/
module control_unit(		
		input  logic [5:0] Opcode,
		input  logic [2:0] Func,
		input  logic [4:0] Rd,

		output logic PCSrc,
		output logic RegWrite,
        output logic RegWriteV,

		output logic MemtoReg,
		output logic MemWrite,
		output logic [2:0] ALUControl,

		output logic ALUSel, // added
		output logic Branch,
		output logic ALUSrc,

        output logic MemSrc,
		output logic [1:0] FlagWrite,
		output logic [1:0] ImmSrc,

		output logic [1:0] RegSrc,
        output logic [1:0] MemData
	);

    wire wAluOp;

    /* PC Logic */
    pc_logic pc_l (.Rd(Rd),
                   .Branch(Branch),
                   .RegW(RegWrite),
                   .PCS(PCSrc));

    /* Main Decoder */
    main_decoder main_deco (.Opcode(Opcode),
                            .Func(Func),
                            .Branch(Branch),
                            .RegSrc(RegSrc),
                            .RegW(RegWrite),
                            .RegWV(RegWriteV),
                            .ALUOp(wAluOp),
                            .MemW(MemWrite),
                            .MemSrc(MemSrc),
                            .MemtoReg(MemtoReg),
                            .ALUSrc(ALUSrc),
                            .ImmSrc(ImmSrc),
                            .MemData(MemData));

    /* ALU Decoder */
    alu_decoder alu_deco (.Opcode(Opcode),
                            .Func(Func),
                            .ALUOp(wAluOp),
                            .ALUSel(ALUSel),
                            .ALUControl(ALUControl),
                            .FlagWrite(FlagWrite));	

endmodule
