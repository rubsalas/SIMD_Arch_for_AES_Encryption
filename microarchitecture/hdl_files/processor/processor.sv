/*
Processor Module
Date: 19/09/24
Test bench ran: XX/09/24
*/
module processor # (parameter N = 32, parameter V = 256) (
        input  logic		 clk,
		input  logic		 rst,
		input  logic		 en,

        input  logic [N-1:0] Instr,       	// InstrF (RD from instruction memory) to register_FD [y]
        input  logic [N-1:0] ReadData, 	    // MemReadData (RD from data_memory) to data_aligner [n]

        output logic [N-1:0] PC,       	 	// PCF (Q from pc register) to instruction_memory [n]
        output logic [N-1:0] AddressData,	// to A from, data memory [n]
        output logic [N-1:0] ByteenaData,	// to A from, data memory [n]
        output logic [N-1:0] WriteData,  	// to WD (write_scalar_data) from data memory [n]
        output logic         RdenData,      // ScalarMemWrite from Data memory [n]
        output logic         WrenData,      // ScalarMemWrite from Data memory [n]
    );

    /* Fetch stage's wiring */


    /* Decode stage's wiring */
    logic [N-1:0] wInstrD;         // [y] sdata from rFD to D [n]
    logic [N-1:0] wPCPlus8D        // [y] sdata from F to D [n]


    /* Execute stage's wiring */
    logic [N-1:0] wExtImmE;         // [n] sdata to F [y]
    logic wBranchTakenE;            // [n] cs to F [y]

    /* Memory stage's wiring */


    /* Writeback stage's wiring */
    logic [N-1:0] wResultW;         // [n] sdata to F [y]
    logic wPCSrcW;                  // [n] cs to F [y]

    /* Hazard Unit's wiring */
    logic wStallF;                  // [y] cs to F [y]
    logic wStallD;                  // [y] cs to rFD [y]
    logic wFlushD;                  // [y] cs to rFD [y]


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
        .PCPlus8D(wPCPlus8D)
    );

    /* Pipeline Register between Fetch-Decode */
	register_FD # (.N(N)) reg_FD (
        .clk(clk),
        .rst(rst),
        .en(!wStallD), /* neg enable */
        .clr(wFlushD),
        .InstrF(Instr),
        .InstrD(wInstrD)
    );

    /* Decode stage */


    /* Execute stage */


    /* Memory stage */


    /* Writeback stage */



    /* Hazard Unit */
    hazard_unit haz_unit (
        .RA1E(/*RA1E*/),
        .RA2E(/*RA2E*/),
        .WA3M(/*WA3M*/),
        .WA3W(/*WA3W*/),
        .RA1D(/*RA1D*/),
        .RA2D(/*RA2D*/),
        .WA3E(/*WA3E*/),
        .RegWriteM(/*RegWriteM*/),
        .RegWriteW(/*RegWriteW*/),
        .MemtoRegE(/*MemtoRegE*/),
        .PCSrcD(/*PCSrcD*/),
        .PCSrcE(/*PCSrcE*/),
        .PCSrcM(/*PCSrcM*/),
        .PCSrcW(/*PCSrcW*/),
        .BranchTakenE(/*BranchTakenE*/),
        .Busy(/*Busy*/),
        .StallW(/*StallW*/),
        .StallM(/*StallM*/),
        .StallF(wStallF),
        .StallD(wStallD),
        .FlushD(wFlushD),
        .FlushE(/*FlushE*/),
        .ForwardAE(/*ForwardAE*/),
        .ForwardBE(/*ForwardBE*/)
    );


	/* Performance Counter Unit */
	 
	 
endmodule
