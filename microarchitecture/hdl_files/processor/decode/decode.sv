/*
Pipeline's Decode Stage
Date: 19/09/24
Test bench ran: XX/09/24
*/
module decode # (parameter N = 32, parameter V = 256, parameter R = 5) (
		input  logic 		 clk,
		input  logic 		 rst,
		/* instruction */
		input  logic [N-1:0] InstrD, 		// instruction for decoding [y]
		/* inputs for register file */
		input  logic 		 RegWriteW,		// RegWriteW (from register_MW at writeback) to sRF [y]
		input  logic [N-1:0] PCPlus8D,		// PCPlus8D (PCPlus4F from fetch) to sRF [y]
		input  logic [R-1:0] WA3W,			// WA3W (forwarding from writeback) to sRF [y], to vSF [y]
		input  logic [N-1:0] ResultW,		// ResultW (from writeback) to sRF [y]
		/* inputs for vector register file */
		input  logic 		 RegWriteVW,	// RegWriteVW (from register_MW at writeback) to vRF [y]
		input  logic [V-1:0] ResultVW,		// ResultVW (from writeback) to vRF [y]


		/* control signal outputs for register_DE */
		output logic PCSrcD,               	// to allround Fetch from CU [y]
		output logic RegWriteD,             // to allround Decode from CU [y]
        output logic RegWriteVD,            // to allround Decode from CU [y]

		output logic MemtoRegD,             // to Writeback from CU [y]

		output logic MemWriteD,             // to Memory from CU [y]
        output logic MemSrcD,               // to Memory from CU [y]
        output logic MemDataD,              // to Memory from CU [y]
        output logic VecDataD,              // to Memory from CU [y]

		output logic [2:0] ALUControlD,     // to Execute from CU [y]
		output logic BranchD,               // to Execute from CU [y]
		output logic ALUSrcD,               // to Execute from CU [y]
		output logic [1:0] FlagWriteD,      // to Execute from CU [y]

		/* outputs for hazard unit and register_DE*/
		output logic [R-1:0] RA1DH,			// from mux [y]
		output logic [R-1:0] RA2DH,			// from mux [y]

		/* data outputs for register_DE */
		output logic [N-1:0] RD1D,			// from sRF [y]
		output logic [N-1:0] RD2D,			// from sRF [y]
		output logic [V-1:0] VRD1D,			// from vRF [y]
		output logic [V-1:0] VRD2D,			// from vRF [y]

		output logic [R-1:0] WA3D, 			// from Instr (rd) [y]
		output logic [N-1:0] ExtImmD		// from extend [y]
	);

	/* Instruction */
	logic [5:0]   inst_opcode;		/* [31:28] */
	logic [R-1:0] inst_rd;			/* [25:21] */
	logic [R-1:0] inst_rs;			/* [20:16] */
	logic [R-1:0] inst_rt;			/* [15:11] */
	logic [2:0]   inst_func;		/* [02:00] */
	logic [25:0]  inst_addr;		/* [25:00] */

	/* Opcode => ||V(31)|Mem(30)|Imm(29)|J/Comp(28)|Sel(27,26)|| */
	assign inst_opcode = InstrD[31:26];			// to CU [y] 
	/* RD */		
	assign inst_rd = InstrD[25:21];				// to mux [y], output to WA3D (rDE) [y], to CU [y]
	/* RS */			
	assign inst_rs = InstrD[20:16];				// to mux [y]
	/* RT */			
	assign inst_rt = InstrD[15:11];				// to mux [y]
	/* Func */			
	assign inst_func = InstrD[2:0];				// to CU [y]
	/* address(j)[25:0], immediate(i)[15:0], shamt(r)[10:3] */			
	assign inst_addr = InstrD[25:0];			// to extend [y]

	/* $pc's address */
	logic [R-1:0] reg15_address;
	assign reg15_address = 5'b01111;			// to mux [y]

	/* Scalar Register File wires */
	logic [R-1:0] RA1D;		// [y] mux to sRF [y], vRF [y], output to RA1H (HU) [y]
	logic [R-1:0] RA2D;		// [y] mux to sRF [y], vRF [y], output to RA2H (HU) [y]

	/* Internal Control Signals from CU */
	logic [1:0] RegSrcD; 	// [y] CU to mux0 [y], to mux1 [y]
	logic [1:0] ImmSrcD;	// [y] CU to extend [y]


	/* Control_Unit */ 
	control_unit cont_unit (.Opcode(inst_opcode),
							.Func(inst_func),
							.Rd(inst_rd),

							.PCSrc(PCSrcD),
							.RegWrite(RegWriteD),
							.RegWriteV(RegWriteVD),

							.MemtoReg(MemtoRegD),

							.MemWrite(MemWriteD),
							.MemSrc(MemSrcD),
							.MemData(MemDataD),
							.VecData(VecDataD),

							.ALUControl(ALUControlD),
							.Branch(BranchD),
							.ALUSrc(ALUSrcD),
							.FlagWrite(FlagWriteD),

							.RegSrc(RegSrcD),
							.ImmSrc(ImmSrcD));

	/* RA1D (A1 from Register File) Mux */
	mux_2NtoN # (.N(R)) mux_ra1d (.I0(inst_rs),
								  .I1(reg15_address),
								  .rst(rst),
								  .S(RegSrcD[0]),
								  .en(1'b1),
								  .O(RA1D));			

	/* RA1D output for Hazard Unit and register_DE */
	assign RA1DH = RA1D;

	/* RA2D (A2 from Register File) Mux */
	mux_2NtoN # (.N(R)) mux_ra2d (.I0(inst_rt),
								  .I1(inst_rd),
								  .rst(rst),
								  .S(RegSrcD[1]),
								  .en(1'b1),
								  .O(RA2D));

	/* RA2D output for Hazard Unit and register_DE */
	assign RA2DH = RA2D;

	/* Register File Scalar */
	register_file # (.N(N)) reg_file_s (.clk(clk),
									  	.rst(rst),
									 	.A1(RA1D),
									  	.A2(RA2D),
									  	.A3(WA3W),
									  	.WD3(ResultW),
									  	.R15(PCPlus8D),
									  	.WE3(RegWriteW),

									  	.RD1(RD1D),
									  	.RD2(RD2D));

	/* Register File Vector */
	register_file_vector # (.N(V)) reg_file_v (.clk(clk),
											   .rst(rst),
											   .VA1(RA1D),
											   .VA2(RA2D),
											   .VA3(WA3W),
											   .VWD3(ResultVW),
											   .VWE3(RegWriteVW),

											   .VRD1(VRD1D),
											   .VRD2(VRD2D));

	/* Writeback rd register for A3 in register files (for register_ED) */
	assign WA3D = inst_rd;

	/* Extend */
	extend # (.N(N)) extender (.A(inst_addr),
							   .ImmSrc(ImmSrcD),
						   	   .ExtImm(ExtImmD));

endmodule
