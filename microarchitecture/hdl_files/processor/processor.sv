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
        input  logic [N-1:0] ReadData, 	    // MemReadData (RD from data_memory) to data_aligner [n]

        output logic [N-1:0] PC,       	 	// PCF (Q from pc register) to instruction_memory [y]
        output logic [N-1:0] AddressData,	// to A from, data memory [n]
        output logic [N-1:0] ByteenaData,	// to A from, data memory [n]
        output logic [N-1:0] WriteData,  	// to WD (write_scalar_data) from data memory [n]
        output logic         RdenData,      // ScalarMemWrite from Data memory [n]
        output logic         WrenData       // ScalarMemWrite from Data memory [n]
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

    logic [1:0] wInstrSelD;         // [y] cs f to rDE [n]
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
    
    logic [N-1:0] wALUResultM;      // [n] sdata to E [y]
    logic [V-1:0] wALUResultVM;     // [n] vdata to E [y]

    
    /* ***************************** Memory stage's wiring ***************************** */

    /* Writeback stage's wiring */
    // Control signals
    logic wPCSrcW;                  // [n] cs to F [y]
    logic wRegWriteW;               // [n] cs to D [y]
    logic wRegWriteVW;              // [n] cs to D [y]
    // Data
    logic [N-1:0] wResultW;         // [n] sdata to F [y], to E [y]
    logic [V-1:0] wResultVW;        // [n] vdata to F [y], to E [y]
    logic [R-1:0] wWA3W;            // [n] raddr to D [y]


    /* Hazard Unit's wiring */
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
        .clk(clk),
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
    register_EM #(.N(32), .V(256), .R(5)) reg_EM (
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
        .PCSrcM(),
        .RegWriteM(),
        .RegWriteVM(),
        
        .MemtoRegM(),
        
        .MemWriteM(),
        .MemSrcM(),
        .MemDataM(),
        .MemDataVM(),
        .VecDataM(),
        
        .ALUResultM(),
        .WriteDataM(),
        .ALUResultVM(),
        .WriteDataVM(),
        
        .WA3M()
    );


    /* Memory stage */


    /* Pipeline Register between Memory-Writeback */


    /* Writeback stage */



    /* Hazard Unit */
    hazard_unit eden_unit (
        .PCSrcD(wPCSrcD),
        .RA1D(wRA1D),
        .RA2D(wRA2D),

        .PCSrcE(wPCSrcECU),
        .MemtoRegE(wMemtoRegEo),
        .BranchTakenE(wBranchTakenE),
        .RA1E(wRA1Eo),
        .RA2E(wRA2Eo),
        .WA3E(wWA3Eo),

        .PCSrcM(),
        .RegWriteM(),
        .RegWriteVM(),
        .WA3M(),
        .BusyDA(),

        .PCSrcW(),
        .RegWriteW(),
        .RegWriteVW(),
        .WA3W(),

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
        
        .StallW()
    );


	/* Performance Counter Unit */
	 
	 
endmodule
