/*
AES_encryptor (Top Module) test bench
Date: 25/09/24
*/
module AES_encryptor_tb;

	timeunit 1ps;
	timeprecision 1ps;

	parameter N = 32;
	parameter V = 256;
	parameter R = 5;

	logic clk;
	logic eclk;
	logic rst;
	logic pwr;
	logic enable;
	logic dbg;
	logic stp;

	logic out;

	/* internal signals */
	// AES_enctryptor


	// Fetch
	logic PCSrcW;
	logic BranchTakenE;
	logic [N-1:0] NPC;
	logic [N-1:0] PCF;
	logic [N-1:0] InstrF;

	// Decode
	// -> Instruction
	logic [N-1:0] InstrD;

	// -> Register File
	logic [1:0] RegSrc;
	logic [R-1:0] RA1D;
	logic [R-1:0] RA2D;
	logic [N-1:0] RD1D;
	logic [N-1:0] RD2D;
	logic [V-1:0] VRD1D;
	logic [V-1:0] VRD2D;
	logic [R-1:0] WA3D;

	// -> Registers
	logic [N-1:0] e0_reg;
	logic [N-1:0] e1_reg;
	logic [N-1:0] e2_reg;
	logic [N-1:0] e3_reg;
	logic [N-1:0] e4_reg;
	logic [N-1:0] e5_reg;
	logic [N-1:0] e6_reg;
	logic [N-1:0] pc_reg;

	// -> RegFile data

	// -> Extend
	logic [1:0] ImmSrcD;
	logic [N-1:0] ExtImmD;

	// -> Control Unit
	logic [5:0] Opcode;
	logic [2:0] Func;
	logic [4:0] Rd;

	logic PCSrcD;

	logic RegWriteD;
	logic RegWriteVD;

	logic MemtoRegD;

	logic MemWriteD;
	logic MemSrcD;
	logic MemDataD;
	logic MemDataVD;
	logic VecDataD;

	logic [1:0] InstrSelD;
	logic BranchD;
	logic ALUSrcD;
	
	logic ALUOp;

	// Execute
	logic RegWriteECU;
	logic [2:0] ALUControlE;

	logic [1:0] ForwardAE;
	logic [1:0] ForwardBE;
	logic [N-1:0] SrcAE;
	logic [N-1:0] SrcBE;

	logic [N-1:0] ALUResultE;
	logic [3:0]	ALUFlags;

	logic [N-1:0] ExtImmEo;

	logic [1:0] ForwardAVE;
	logic [1:0] ForwardBVE;
	logic [V-1:0] SrcAVE;
	logic [V-1:0] SrcBVE;

	logic [V-1:0] ALUResultVE;


	// Memory
	logic RegWriteMo;

	logic MemDataM;
	logic MemDataVM;

	logic [N-1:0] SWData; 	// internal
	logic [V-1:0] VWData;	// internal

	logic MemWriteM;
	logic MemSrcM;
	logic MemtoRegMi;

	logic [N-1:0] ALUResultMi;

	logic MemRden;
	logic MemWren;
	logic [13:0] MemAddress;
	logic [31:0] MemByteena;
	logic [V-1:0] MemWriteData;

	logic BusyDA;
	logic [V-1:0] MemReadData;

	logic [N-1:0] ReadDataM;
	logic VecDataM;
	logic [V-1:0] ReadDataVM;



	// Writeback
	logic RegWriteWo;
	logic [R-1:0] WA3Wo;


	// Hazard Unit
	logic StallF;
    
    logic StallD;
    logic FlushD;
    
    logic StallE;
    logic FlushE;

    logic StallM;

    logic StallW;


	/* AES_encryptor instance */
	AES_encryptor  #(.N(N), .V(V), .R(R)) uut (
		.clk(clk),
		.rst(rst),
		.pwr(pwr),
		.dbg(dbg),
		.stp(stp),
		.out(out)
	);

	// Generación del reloj
    always begin
		#10 clk = ~clk;

		// AES_encryptor
		eclk = uut.eclk;
		enable = uut.enable;
		
		// Fetch
		PCSrcW = uut.asip.fetch_stage.PCSrcW;
		BranchTakenE = uut.asip.fetch_stage.BranchTakenE; 
		NPC = uut.asip.fetch_stage.NPC;
		PCF = uut.asip.fetch_stage.PCF;
		InstrF = uut.data_memory.instruction;

		
		// Decode
		// -> Instruction
		InstrD = uut.asip.decode_stage.InstrD;

		// -> Register File
		RegSrc = uut.asip.decode_stage.cont_unit.RegSrc;
		RA1D = uut.asip.decode_stage.RA1D;
		RA2D = uut.asip.decode_stage.RA2D;
		RD1D = uut.asip.decode_stage.RD1D;
		RD2D = uut.asip.decode_stage.RD2D;
		VRD1D = uut.asip.decode_stage.VRD1D;
		VRD2D = uut.asip.decode_stage.VRD2D;
		WA3D = uut.asip.decode_stage.WA3D;

		// -> Registers
		e0_reg = uut.asip.decode_stage.reg_file_s.reg_array[8];
		e1_reg = uut.asip.decode_stage.reg_file_s.reg_array[9];
		e2_reg = uut.asip.decode_stage.reg_file_s.reg_array[10];
		e3_reg = uut.asip.decode_stage.reg_file_s.reg_array[11];
		e4_reg = uut.asip.decode_stage.reg_file_s.reg_array[12];
		e5_reg = uut.asip.decode_stage.reg_file_s.reg_array[13];
		e6_reg = uut.asip.decode_stage.reg_file_s.reg_array[14];
		pc_reg = uut.asip.decode_stage.reg_file_s.reg_array[15];

		// -> RegFile data

		// -> Extend
		ImmSrcD = uut.asip.decode_stage.ImmSrcD;
		ExtImmD = uut.asip.decode_stage.ExtImmD;

		// -> Control Unit
		Opcode = uut.asip.decode_stage.cont_unit.Opcode;
		Func = uut.asip.decode_stage.cont_unit.Func;
		Rd = uut.asip.decode_stage.cont_unit.Rd;
		
		PCSrcD = uut.asip.decode_stage.cont_unit.PCSrc;

		RegWriteD = uut.asip.decode_stage.cont_unit.RegWrite;
		RegWriteVD = uut.asip.decode_stage.cont_unit.RegWriteV;
		
		MemtoRegD = uut.asip.decode_stage.cont_unit.MemtoReg;

		MemWriteD = uut.asip.decode_stage.cont_unit.MemWrite;
		MemSrcD = uut.asip.decode_stage.cont_unit.MemSrc;
		MemDataD = uut.asip.decode_stage.cont_unit.MemData;
		MemDataVD = uut.asip.decode_stage.cont_unit.MemDataV;
		VecDataD = uut.asip.decode_stage.cont_unit.VecData;

		InstrSelD = uut.asip.decode_stage.cont_unit.InstrSel;
		BranchD = uut.asip.decode_stage.cont_unit.Branch;
		ALUSrcD = uut.asip.decode_stage.cont_unit.ALUSrc;

		ALUOp = uut.asip.decode_stage.cont_unit.main_deco.ALUOp;


		// Execute
		RegWriteECU = uut.asip.execute_stage.RegWriteECU;

		ALUControlE = uut.asip.execute_stage.ALUControlE;

		ForwardAE = uut.asip.execute_stage.ForwardAE;
		ForwardBE = uut.asip.execute_stage.ForwardBE;
		SrcAE = uut.asip.execute_stage.SrcAE;
		SrcBE = uut.asip.execute_stage.SrcBE;

		ALUResultE = uut.asip.execute_stage.ALUResultE;
		ALUFlags = uut.asip.execute_stage.ALUFlags;
		
		ExtImmEo = uut.asip.execute_stage.ExtImmEo;

		ForwardAVE = uut.asip.execute_stage.ForwardAVE;
		ForwardBVE = uut.asip.execute_stage.ForwardBVE;
		SrcAVE = uut.asip.execute_stage.SrcAVE;
		SrcBVE = uut.asip.execute_stage.SrcBVE;

		ALUResultVE = uut.asip.execute_stage.ALUResultVE;

		// Memory
		RegWriteMo = uut.asip.memory_stage.RegWriteMo;
	
		MemDataM = uut.asip.memory_stage.MemDataM;
		MemDataVM = uut.asip.memory_stage.MemDataVM;

		SWData = uut.asip.memory_stage.SWData;
		VWData = uut.asip.memory_stage.VWData;

		MemWriteM = uut.asip.memory_stage.MemWriteM;
		MemSrcM = uut.asip.memory_stage.MemSrcM;
		MemtoRegMi = uut.asip.memory_stage.MemtoRegMi;

		ALUResultMi = uut.asip.memory_stage.ALUResultMi;

		MemRden = uut.asip.memory_stage.MemRden;
		MemWren = uut.asip.memory_stage.MemWren;
		MemAddress = uut.asip.memory_stage.MemAddress;
		MemByteena = uut.asip.memory_stage.MemByteena;
		MemWriteData = uut.asip.memory_stage.MemWriteData;

		BusyDA = uut.asip.memory_stage.BusyDA;
		MemReadData = uut.asip.memory_stage.MemReadData;

		ReadDataM = uut.asip.memory_stage.ReadDataM;
		VecDataM = uut.asip.memory_stage.VecDataM;
		ReadDataVM = uut.asip.memory_stage.ReadDataVM;

		//Writeback
		RegWriteWo = uut.asip.writeback_stage.RegWriteWo;
		WA3Wo = uut.asip.writeback_stage.WA3Wo;

		// Hazard Unit
		StallF = uut.asip.eden_unit.StallF;
    
		StallD = uut.asip.eden_unit.StallD;
		FlushD = uut.asip.eden_unit.FlushD;
		
		StallE = uut.asip.eden_unit.StallE;
		FlushE = uut.asip.eden_unit.FlushE;

		StallM = uut.asip.eden_unit.StallM;

		StallW = uut.asip.eden_unit.StallW;

	end

	// Initialize inputs

	initial begin
		$display("AES_encryptor test bench:\n");

		clk = 0;
		rst = 1;
		pwr = 1;
		dbg = 1;
		stp = 1;

		#60;

		rst = 0;
		pwr = 0;

		#20;

		pwr = 1;

		// rst = 1;

		// #100;

		#500;
		$finish; 

	end
	                                

endmodule
