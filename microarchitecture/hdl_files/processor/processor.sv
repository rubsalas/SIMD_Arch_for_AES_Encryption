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

    /* Fetch stage's wiring */
    logic [N-1:0] wPCPlus4F;         // [y] sdata from F to D [y]


    /* Decode stage's wiring */
    logic [N-1:0] wInstrD;          // [y] sdata from rFD to D [y]
    //
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


    /* Execute stage's wiring */
    logic [N-1:0] wExtImmE;         // [n] sdata to F [y]
    logic wBranchTakenE;            // [n] cs to F [y]

    /* Memory stage's wiring */


    /* Writeback stage's wiring */
    // Control signals
    logic wPCSrcW;                  // [n] cs to F [y]
    logic wRegWriteW;               // [n] cs to D [y]
    logic wRegWriteVW;              // [n] cs to D [y]
    // Data
    logic [N-1:0] wResultW;         // [n] sdata to F [y]
    logic [V-1:0] wResultVW;        // [n] vdata to F [y]
    logic [R-1:0] WA3W;             // [n] raddr to D [y]

    /* Hazard Unit's wiring */
    logic wStallF;                  // [y] cs to F [y]
    logic wStallD;                  // [y] cs to rFD [y]
    logic wStallE;                  // [y] cs to rDE [y]
    logic wFlushD;                  // [y] cs to rFD [y]
    logic wFlushE;                  // [y] cs to rDE [y]


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
        .WA3W(WA3W),
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


        .PCSrcE(),
        .RegWriteE(),
        .RegWriteVE(),

        .MemtoRegE(),

        .MemWriteE(),
        .MemSrcE(),
        .MemDataE(),
        .MemDataVE(),
        .VecDataE(),

        .InstrSelE(),
        .ALUControlE(),
        .BranchE(),
        .ALUSrcE(),

        .RA1E(),
        .RA2E(),

        .RD1E(),
        .RD2E(),
        .VRD1E(),
        .VRD2E(),

        .WA3E(),
        .ExtImmE()
    );


    /* Execute stage */


    /* Pipeline Register between Execute-Memory */


    /* Memory stage */


    /* Pipeline Register between Memory-Writeback */


    /* Writeback stage */



    /* Hazard Unit */
    hazard_unit haz_unit (
        .RA1D(wRA1D),
        .RA2D(wRA2D),
        .RA1E(/*RA1E*/),
        .RA2E(/*RA2E*/),
        .WA3E(/*WA3E*/),
        .WA3M(/*WA3M*/),
        .WA3W(/*WA3W*/),
        .RegWriteM(/*RegWriteM*/),
        .RegWriteW(/*RegWriteW*/),
        .MemtoRegE(/*MemtoRegE*/),
        .PCSrcD(wPCSrcD),
        .PCSrcE(/*PCSrcE*/),
        .PCSrcM(/*PCSrcM*/),
        .PCSrcW(/*PCSrcW*/),
        .BranchTakenE(/*BranchTakenE*/),
        .Busy(/*Busy*/),

        .StallF(wStallF),
        .StallD(wStallD),
        .StallE(wStallE),
        .StallM(/*StallM*/),
        .StallW(/*StallW*/),
        .FlushD(wFlushD),
        .FlushE(wFlushE),
        .ForwardAE(/*ForwardAE*/),
        .ForwardBE(/*ForwardBE*/)
    );


	/* Performance Counter Unit */
	 
	 
endmodule
