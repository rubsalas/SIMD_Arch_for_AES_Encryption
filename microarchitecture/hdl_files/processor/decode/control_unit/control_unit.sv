/*
Control Unit v3 module
Date: 19/09/2024
Test bench ran: XX/09/24
*/
module control_unit(		
		input  logic [5:0] Opcode,
		input  logic [2:0] Func,
		input  logic [4:0] Rd,

		output logic PCSrc,                 // allround Fetch
		output logic RegWrite,              // allround Decode
        output logic RegWriteV,             // allround Decode

		output logic MemtoReg,              // Writeback

		output logic MemWrite,              // Memory
        output logic MemSrc,                // Memory
        output logic MemData,               // Memory
        output logic VecData,               // Memory

		output logic [2:0] ALUControl,      // Execute
		output logic Branch,                // Execute
		output logic ALUSrc,                // Execute
		output logic [1:0] FlagWrite,       // Execute

		output logic [1:0] RegSrc,          // Decode
		output logic [1:0] ImmSrc           // Decode
	);

    logic wAluOp;

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
                            .ALUControl(ALUControl),
                            .FlagWrite(FlagWrite));	

endmodule
