/*
Processor Module
Date: 19/09/24
Test bench ran: XX/09/24
*/
module processor # (parameter N = 32, parameter V = 256, parameter R = 5) (
        input  logic		 clk,
		input  logic		 rst,
		input  logic		 en,

        input  logic [N-1:0] Instr,       	// InstrF (RD from instruction memory) to register_FD [y]

        input  logic [V-1:0] ReadData, 	    // MemReadData (RD from data_memory) to Memory stage (RDi from data_aligner) [y]

        output logic [N-1:0] PC,       	 	// PCF (Q from pc register) to instruction_memory [y]

        output logic         RdenData,      // from DA to rden_data (Data memory) [y]
        output logic         WrenData,      // from DA to wren_data (Data memory) [y]
        output logic [N-1:0] AddressData,	// from DA to address_data (Data memory) [y]
        output logic [N-1:0] ByteenaData,	// from DA to byteena_data (Data memory) [y]
        output logic [V-1:0] WriteData  	// to WD (write_scalar_data) from data memory [y]
    );


    /* ***************************** Fetch stage's wiring ***************************** */

    logic [N-1:0] wPCPlus4F;        // [y] sdata from F to D [y]


    /* ***************************** Decode stage's wiring ***************************** */

    logic [N-1:0] wInstrD;          // [y] sdata from rFD to D [y]

    logic wPCSrcD;                  // [y] cs f to rDE [y], to HU [y]
    logic wRegWriteD;               // [y] cs f to rDE [y]
    logic wRegWriteVD;              // [y] cs f to rDE [y]

    logic wMemtoRegD;               // [y] cs f to rDE [y]

    logic wMemWriteD;               // [y] cs f to rDE [y]
    logic wMemSrcD;                 // [y] cs f to rDE [y]
    logic wMemDataD;                // [y] cs f to rDE [y]
    logic wMemDataVD;               // [y] cs f to rDE [y]
    logic wVecDataD;                // [y] cs f to rDE [y]

    logic [1:0] wInstrSelD;         // [y] cs f to rDE [y]
    logic [2:0] wALUControlD;       // [y] cs f to rDE [y]
    logic wBranchD;                 // [y] cs f to rDE [y]
    logic wALUSrcD;                 // [y] cs f to rDE [y]

    logic [R-1:0] wRA1D;            // [y] raddr f to rDE [y], to HU [y]
    logic [R-1:0] wRA2D;            // [y] raddr f to rDE [y], to HU [y]

    logic [N-1:0] wRD1D;            // [y] sdata f to rDE [y]
    logic [N-1:0] wRD2D;            // [y] sdata f to rDE [y]
    logic [V-1:0] wVRD1D;           // [y] vdata f to rDE [y]
    logic [V-1:0] wVRD2D;           // [y] vdata f to rDE [y]

    logic [R-1:0] wWA3D;            // [y] raddr f to rDE [y]
    logic [N-1:0] wExtImmD;         // [y] sdata f to rDE [y]

    
    /* ***************************** Execute stage's wiring ***************************** */
    
    /* reg to E */
    logic wPCSrcE;                  // [y] cs from rDE to E [y] 
    logic wRegWriteE;               // [y] cs from rDE to E [y] 
    logic wRegWriteVEi;             // [y] cs from rDE to E [y]

    logic wMemtoRegEi;              // [y] cs from rDE to E [y]

    logic wMemWriteE;               // [y] cs from rDE to E [y]
    logic wMemSrcEi;                // [y] cs from rDE to E [y]
    logic wMemDataEi;               // [y] cs from rDE to E [y]
    logic wMemDataVEi;              // [y] cs from rDE to E [y]
    logic wVecDataEi;               // [y] cs from rDE to E [y]

    logic [1:0] wInstrSelE;         // [y] cs from rDE to E [y]
    logic [2:0] wALUControlE;       // [y] cs from rDE to E [y]
    logic wBranchE;                 // [y] cs from rDE to E [y]
    logic wALUSrcE;                 // [y] cs from rDE to E [y]

    logic [R-1:0] wRA1Ei;           // [y] raddr from rDE to E [y]
    logic [R-1:0] wRA2Ei;           // [y] raddr from rDE to E [y]

    logic [N-1:0] wRD1E;            // [y] sdata from rDE to E [y]
    logic [N-1:0] wRD2E;            // [y] sdata from rDE to E [y]

    logic [V-1:0] wVRD1E;           // [y] vdata from rDE to E [y]
    logic [V-1:0] wVRD2E;           // [y] vdata from rDE to E [y]

    logic [R-1:0] wWA3Ei;           // [y] raddr from rDE to E [y]    
    logic [N-1:0] wExtImmEi;        // [y] sdata from rDE to E [y]

    /* E's outputs */
    logic [N-1:0] wWriteDataE;      // [y] sdata to rEM [y]
    logic [N-1:0] wALUResultE;      // [y] sdata to rDE [y]
    logic [N-1:0] wWriteDataVE;     // [y] vdata to rEM [y]
    logic [N-1:0] wALUResultVE;     // [y] vdata to rDE [y]

    logic [R-1:0] wWA3Eo;           // [y] raddr to rEM [y], to HU [y]

    logic [N-1:0] wExtImmE;         // [y] sdata to F [y]

    logic wBranchTakenE;            // [y] cs to F [y], to HU [y]
    logic wPCSrcECU;                // [y] cs to rDE [y], to HU [y]
    logic wRegWriteECU;             // [y] cs to rDE [y]
    logic wMemWriteECU;             // [y] cs to rDE [y]

    logic wRegWriteVEo;             // [y] cs to rDE [y]
    logic wMemtoRegEo;              // [y] cs to rDE [y], to HU [y]

    logic wMemSrcEo;                // [y] cs to rDE [y]
    logic wMemDataEo;               // [y] cs to rDE [y]
    logic wMemDataVEo;              // [y] cs to rDE [y]
    logic wVecDataEo;               // [y] cs to rDE [y]

    logic [R-1:0] wRA1Eo;           // [y] raddr to HU [y]
    logic [R-1:0] wRA2Eo;           // [y] raddr to HU [y]


    /* ***************************** Memory stage's wiring ***************************** */
    
    /* reg to M */
    logic wPCSrcMi;                 // [y] cs from rEM to M [y]
    logic wRegWriteMi;              // [y] cs from rEM to M [y]
    logic wRegWriteVMi;             // [y] cs from rEM to M [y]

    logic wMemtoRegMi;              // [y] cs from rEM to M [y]

    logic wMemWriteM;               // [y] cs from rEM to M [y]
    logic wMemSrcM;                 // [y] cs from rEM to M [y]
    logic wMemDataM;                // [y] cs from rEM to M [y]
    logic wMemDataVM;               // [y] cs from rEM to M [y]
    logic wVecDataM;                // [y] cs from rEM to M [y]

    logic [N-1:0] wALUResultMi;     // [y] sdata from rEM to M [y]
    logic [N-1:0] wWriteDataM;      // [y] sdata from rEM to M [y]

    logic [V-1:0] wALUResultVMi;    // [y] vdata from rEM to M [y]
    logic [V-1:0] wWriteDataVM;     // [y] vdata from rEM to M [y]

    logic [R-1:0] WA3Mi;            // [y] raddr from rEM to M [y]

    /* M's outputs */
    logic wPCSrcMo;                 // [y] cs from M to rMW [y], to HU [y]
    logic wRegWriteMo;              // [y] cs from M to rMW [y], to HU [y]
    logic wRegWriteVMo;             // [y] cs from M to rMW [y], to HU [y]
    logic wMemtoRegMo;              // [y] cs from M to rMW [y]

    logic [N-1:0] wALUResultM;      // [y] sdata to E [y], to rMW [y]
    logic [V-1:0] wALUResultVM;     // [y] vdata to E [y], to rMW [y]

    logic [N-1:0] wReadDataM;       // [y] sdata from M to rMW [y]
    logic [V-1:0] wReadDataVM;      // [y] vdata from M to rMW [y]

    logic [R-1:0] wWA3Mo;           // [y] raddr from M to rMW [y], to HU [y]

    logic wBusyDA;                  // [y] cs to HU [y]

    
    /* ***************************** Writeback stage's wiring ***************************** */

    /* regs to W */
    logic wPCSrcWi;                 // [y] cs from rMW to W [y]
    logic wRegWriteWi;              // [y] cs from rMW to W [y]
    logic wRegWriteVWi;             // [y] cs from rMW to W [y]
    logic wMemtoRegW;               // [y] cs from rMW to W [y]

    logic [N-1:0] wALUResultW;      // [y] sdata from rMW to W [y]
    logic [V-1:0] wALUResultVW;     // [y] vdata from rMW to W [y]

    logic [N-1:0] wReadDataW;       // [y] sdata from rMW to W [y]
    logic [V-1:0] wReadDataVW;      // [y] vdata from rMW to W [y]

    logic [R-1:0] WA3Wi;            // [y] raddr from rMW to W [y]

    /* W's outputs */
    logic wPCSrcW;                  // [y] cs to F [y], to HU [y]
    logic wRegWriteW;               // [y] cs to D [y], to HU [y]
    logic wRegWriteVW;              // [y] cs to D [y], to HU [y]
    // Data
    logic [N-1:0] wResultW;         // [y] sdata to F [y], to E [y]
    logic [V-1:0] wResultVW;        // [y] vdata to F [y], to E [y]
    logic [R-1:0] wWA3W;            // [n] raddr to D [y], to HU [n]


    /* ***************************** Hazard Unit's wiring ***************************** */

    logic wStallF;                  // [y] cs to F [y]
    
    logic wStallD;                  // [y] cs to rFD [y]
    logic wFlushD;                  // [y] cs to rFD [y]
    
    logic wStallE;                  // [y] cs to rDE [y]
    logic wFlushE;                  // [y] cs to rDE [y]
    logic [1:0] wForwardAE;         // [y] cs to E [y]
    logic [1:0] wForwardBE;         // [y] cs to E [y]
    logic [1:0] wForwardAVE;        // [y] cs to E [y]
    logic [1:0] wForwardBVE;        // [y] cs to E [y]
    
    logic wStallM;                  // [y] cs to rEM [y]

    logic wStallW;                  // [y] cs to rMW [y]


    /* Performance Counter Unit's wiring */



    /* Fetch stage */
    fetch #(.N(N)) fetch_stage (
        // inputs
        .clk(clk),
        .rst(rst),
        .ResultW(wResultW),
        .ExtImmE(wExtImmE),
        .PCSrcW(wPCSrcW),
        .BranchTakenE(wBranchTakenE),
        .StallF(wStallF),
        // outputs
        .PCF(PC),
        .PCPlus4F(wPCPlus4F)
    );

    /* Pipeline Register between Fetch-Decode */
	register_FD # (.N(N)) reg_FD (
        // inputs
        .clk(clk),
        .rst(rst),
        .en(!wStallD), /* neg enable */
        .clr(wFlushD),
        .InstrF(Instr),
        // outputs
        .InstrD(wInstrD)
    );

    /* Decode stage */
    decode #(.N(N), .V(V), .R(R)) decode_stage (
        // inputs 
        .clk(clk),
        .rst(rst),
        // instruction
        .InstrD(wInstrD),
        // inputs for register file
        .RegWriteW(wRegWriteW),
        .PCPlus8D(wPCPlus4F),
        .WA3W(wWA3W),
        .ResultW(wResultW),
        // inputs for vector register file
        .RegWriteVW(wRegWriteVW),
        .ResultVW(wResultVW),
        
        // control signal outputs for register_DE
        .PCSrcD(wPCSrcD),
        .RegWriteD(wRegWriteD),
        .RegWriteVD(wRegWriteVD),

        .MemtoRegD(wMemtoRegD),

        .MemWriteD(wMemWriteD),
        .MemSrcD(wMemSrcD),
        .MemDataD(wMemDataD),
        .MemDataVD(wMemDataVD),
        .VecDataD(wVecDataD),

        .InstrSelD(wInstrSelD),
        .ALUControlD(wALUControlD),
        .BranchD(wBranchD),
        .ALUSrcD(wALUSrcD),
        // outputs for hazard unit and register_DE
        .RA1DH(wRA1D),
        .RA2DH(wRA2D),
        //data outputs for register_DE
        .RD1D(wRD1D),
        .RD2D(wRD2D),
        .VRD1D(wVRD1D),
        .VRD2D(wVRD2D),

        .WA3D(wWA3D),
        .ExtImmD(wExtImmD)
    );

    /* Pipeline Register between Decode-Execute */
    register_DE #(.N(N), .V(V), .R(R)) reg_DE (
        .clk(clk),
        .rst(rst),
        .en(!wStallE), /* neg enable */
        .clr(wFlushE),

        .PCSrcD(wPCSrcD),
        .RegWriteD(wRegWriteD),
        .RegWriteVD(wRegWriteVD),

        .MemtoRegD(wMemtoRegD),

        .MemWriteD(wMemWriteD),
        .MemSrcD(wMemSrcD),
        .MemDataD(wMemDataD),
        .MemDataVD(wMemDataVD),
        .VecDataD(wVecDataD),

        .InstrSelD(wInstrSelD),
        .ALUControlD(wALUControlD),
        .BranchD(wBranchD),
        .ALUSrcD(wALUSrcD),

        .RA1D(wRA1D),              // RA1DH
        .RA2D(wRA2D),              // RA2DH

        .RD1D(wRD1D),
        .RD2D(wRD2D),
        .VRD1D(wVRD1D),
        .VRD2D(wVRD2D),

        .WA3D(wWA3D),
        .ExtImmD(wExtImmD),

        /* outputs */
        .PCSrcE(wPCSrcE),
        .RegWriteE(wRegWriteE),
        .RegWriteVE(wRegWriteVEi),

        .MemtoRegE(wMemtoRegEi),

        .MemWriteE(wMemWriteE),
        .MemSrcE(wMemSrcEi),
        .MemDataE(wMemDataEi),
        .MemDataVE(wMemDataVEi),
        .VecDataE(wVecDataEi),

        .InstrSelE(wInstrSelE),
        .ALUControlE(wALUControlE),
        .BranchE(wBranchE),
        .ALUSrcE(wALUSrcE),

        .RA1E(wRA1Ei),
        .RA2E(wRA2Ei),

        .RD1E(wRD1E),
        .RD2E(wRD2E),
        .VRD1E(wVRD1E),
        .VRD2E(wVRD2E),

        .WA3E(wWA3Ei),
        .ExtImmE(wExtImmEi)
    );


    /* Execute stage */
    execute #(.N(N), .V(V), .R(R)) execute_stage (
        .rst(rst),

        .RD1E(wRD1E),
        .RD2E(wRD2E),
        .ExtImmEi(wExtImmEi),
        .VRD1E(wVRD1E),
        .VRD2E(wVRD2E),

        .WA3Ei(wWA3Ei),

        .PCSrcE(wPCSrcE),
        .RegWriteE(wRegWriteE),
        .RegWriteVEi(wRegWriteVEi),

        .MemtoRegEi(wMemtoRegEi),

        .MemWriteE(wMemWriteE),
        .MemSrcEi(wMemSrcEi),
        .MemDataEi(wMemDataEi),
        .MemDataVEi(wMemDataVEi),
        .VecDataEi(wVecDataEi),

        .InstrSelE(wInstrSelE),
        .ALUControlE(wALUControlE),
        .BranchE(wBranchE),
        .ALUSrcE(wALUSrcE),

        .ResultW(wResultW),
        .ResultVW(wResultVW),
        .ALUResultM(wALUResultM),
        .ALUResultVM(wALUResultVM),

        .ForwardAE(wForwardAE),
        .ForwardBE(wForwardBE),
        .ForwardAVE(wForwardAVE),
        .ForwardBVE(wForwardBVE),

        .RA1Ei(wRA1Ei),
        .RA2Ei(wRA2Ei),

        /* outputs */
        .WriteDataE(wWriteDataE),
        .ALUResultE(wALUResultE),

        .WriteDataVE(wWriteDataVE),
        .ALUResultVE(wALUResultVE),

        .WA3Eo(wWA3Eo),

        .ExtImmEo(wExtImmE),

        .BranchTakenE(wBranchTakenE),    // HU
        .PCSrcECU(wPCSrcECU),    // HU
        .RegWriteECU(wRegWriteECU),
        .MemWriteECU(wMemWriteECU),

        .RegWriteVEo(wRegWriteVEo),
        .MemtoRegEo(wMemtoRegEo),  // HU

        .MemSrcEo(wMemSrcEo),
        .MemDataEo(wMemDataEo),
        .MemDataVEo(wMemDataVEo),
        .VecDataEo(wVecDataEo),

        .RA1Eo(wRA1Eo),   // HU
        .RA2Eo(wRA2Eo)    // HU
    );


    /* Pipeline Register between Execute-Memory */
    register_EM #(.N(N), .V(V), .R(R)) reg_EM (
        .clk(clk),
        .rst(rst),
        .en(wStallM),       // StallM
        
        .PCSrcE(wPCSrcECU),
        .RegWriteE(wRegWriteECU),
        .RegWriteVE(wRegWriteVEo),
        
        .MemtoRegE(wMemtoRegEo),
        
        .MemWriteE(wMemWriteECU),
        .MemSrcE(wMemSrcEo),
        .MemDataE(wMemDataEo),
        .MemDataVE(wMemDataVEo),
        .VecDataE(wVecDataEo),
        
        .ALUResultE(wALUResultE),
        .WriteDataE(wWriteDataE),
        .ALUResultVE(wALUResultVE),
        .WriteDataVE(wWriteDataVE),
        
        .WA3E(wWA3Eo),
        
        /* outputs */
        .PCSrcM(wPCSrcMi),
        .RegWriteM(wRegWriteMi),
        .RegWriteVM(wRegWriteVMi),
        
        .MemtoRegM(wMemtoRegMi),
        
        .MemWriteM(wMemWriteM),
        .MemSrcM(wMemSrcM),
        .MemDataM(wMemDataM),
        .MemDataVM(wMemDataVM),
        .VecDataM(wVecDataM),
        
        .ALUResultM(wALUResultMi),
        .WriteDataM(wWriteDataM),

        .ALUResultVM(wALUResultVMi),
        .WriteDataVM(wWriteDataVM),
        
        .WA3M(WA3Mi)
    );


    /* Memory stage */
    mem #(.N(N), .V(N), .R(R)) memory_stage (
        .clk(clk),
        .rst(rst),

        .PCSrcMi(wPCSrcMi),
        .RegWriteMi(wRegWriteMi),
        .RegWriteVMi(wRegWriteVMi),

        .MemtoRegMi(wMemtoRegMi),

        .MemWriteM(wMemWriteM),
        .MemSrcM(wMemSrcM),
        .MemDataM(wMemDataM),
        .MemDataVM(wMemDataVM),
        .VecDataM(wVecDataM),

        .ALUResultMi(wALUResultMi),
        .WriteDataM(wWriteDataM),

        .ALUResultVMi(wALUResultVMi),
        .WriteDataVM(wWriteDataVM),

        .WA3Mi(WA3Mi),

        .MemReadData(ReadData),

        /* outputs */
        .PCSrcMo(wPCSrcMo),
        .RegWriteMo(wRegWriteMo),
        .RegWriteVMo(wRegWriteVMo),
        .MemtoRegMo(wMemtoRegMo),

        .ALUResultMo(wALUResultM),
        .ALUResultVMo(wALUResultVM),

        .ReadDataM(wReadDataM),
        .ReadDataVM(wReadDataVM),

        .WA3Mo(wWA3Mo),

        .BusyDA(wBusyDA),

        .MemRden(RdenData),
        .MemWren(WrenData),
        .MemAddress(AddressData),
        .MemByteena(ByteenaData),
        .MemWriteData(WriteData)
    );


    /* Pipeline Register between Memory-Writeback */
    register_MW #(.N(N), .V(V), .R(R)) reg_MW (
        .clk(clk),
        .rst(rst),
        .en(wStallW),                   // StallW
        
        .PCSrcM(wPCSrcMo),
        .RegWriteM(wRegWriteMo),
        .RegWriteVM(wRegWriteVMo),
        .MemtoRegM(wMemtoRegMo),

        .ALUResultM(wALUResultM),
        .ReadDataM(wReadDataM),
        .ALUResultVM(wALUResultVM),
        .ReadDataVM(wReadDataVM),
        
        .WA3M(wWA3Mo),
        
        /* outputs */
        .PCSrcW(wPCSrcWi),
        .RegWriteW(wRegWriteWi),
        .RegWriteVW(wRegWriteVWi),
        .MemtoRegW(wMemtoRegW),
        
        .ALUResultW(wALUResultW),
        .ReadDataW(wReadDataW),
        .ALUResultVW(wALUResultVW),
        .ReadDataVW(wReadDataVW),
        
        .WA3W(WA3Wi)
    );


    /* Writeback stage */
    writeback #(.N(N), .V(V), .R(R)) writeback_stage (
        .rst(rst),

        .PCSrcWi(wPCSrcWi),
        .RegWriteWi(wRegWriteWi),
        .RegWriteVWi(wRegWriteVWi),
        .MemtoRegW(wMemtoRegW),

        .ALUResultW(wALUResultW),
        .ReadDataW(wReadDataW),
        .ALUResultVM(wALUResultVW),
        .ReadDataVM(wReadDataVW),

        .WA3Mi(WA3Wi),

        /* outputs */
        .PCSrcWo(wPCSrcW),
        .RegWriteWo(wRegWriteW),
        .RegWriteVWo(wRegWriteVW),

        .ResultW(wResultW),
        .ResultVW(wResultVW),

        .WA3Wo(wWA3W)
    );


    /* Hazard Unit */
    hazard_unit # (.R(R)) eden_unit (
        .PCSrcD(wPCSrcD),
        .RA1D(wRA1D),
        .RA2D(wRA2D),

        .PCSrcE(wPCSrcECU),
        .MemtoRegE(wMemtoRegEo),
        .BranchTakenE(wBranchTakenE),
        .RA1E(wRA1Eo),
        .RA2E(wRA2Eo),
        .WA3E(wWA3Eo),

        .PCSrcM(wPCSrcMo),
        .RegWriteM(wRegWriteMo),
        .RegWriteVM(wRegWriteVMo),
        .WA3M(wWA3Mo),
        .BusyDA(wBusyDA),

        .PCSrcW(wPCSrcW),
        .RegWriteW(wRegWriteW),
        .RegWriteVW(wRegWriteVW),
        .WA3W(wWA3W),

        .StallF(wStallF),

        .StallD(wStallD),
        .FlushD(wFlushD),
        
        .StallE(wStallE),
        .FlushE(wFlushE),
        .ForwardAE(wForwardAE),
        .ForwardBE(wForwardBE),
        .ForwardAVE(wForwardAVE),
        .ForwardBVE(wForwardBVE),
        
        .StallM(wStallM),
        
        .StallW(wStallW)
    );


	/* Performance Monitor Unit */
	 
	 
endmodule
