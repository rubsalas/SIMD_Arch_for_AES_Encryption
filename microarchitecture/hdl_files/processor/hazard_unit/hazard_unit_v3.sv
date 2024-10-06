/*
Hazard Unit v3 module
Data: 01/10/24
Test bench ran: XX/09/24
*/
module hazard_unit_v3 # (parameter R = 5) (
		input  logic PCSrcD,
		input  logic [R-1:0] RA1D,      // to Match_12D_E
		input  logic [R-1:0] RA2D,      // to Match_12D_E

		input  logic PCSrcE,
		input  logic MemtoRegE,
		input  logic BranchTakenE,
		input  logic [R-1:0] RA1E,
		input  logic [R-1:0] RA2E,
		input  logic [R-1:0] WA3E,

		input  logic PCSrcM,
		input  logic RegWriteM,
		input  logic RegWriteVM,
		input  logic [R-1:0] WA3M,
		input  logic BusyDA,

		input  logic PCSrcW,
		input  logic RegWriteW,
		input  logic RegWriteVW,
		input  logic [R-1:0] WA3W,
		
		
		output logic StallF,

		output logic StallD,
		output logic FlushD,

		output logic StallE,
		output logic FlushE,
		output logic [1:0] ForwardAE,       /* Data Hazard solved with Forwarding */
		output logic [1:0] ForwardBE,       /* Data Hazard solved with Forwarding */
		output logic [1:0] ForwardAVE,      /* Data Hazard solved with Forwarding */
		output logic [1:0] ForwardBVE,      /* Data Hazard solved with Forwarding */
        
        output logic StallM,
        
        output logic StallW
	);


    logic AnyRegWriteM;
    logic AnyRegWriteW;

    logic Match_1E_M;
    logic Match_2E_M;
    logic Match_1E_W;
    logic Match_2E_W;

    logic Match_12D_E;
    logic LDRstall;

    logic PCWrPendingF;


    /* Any RegWrite signal in Memory stage, vector or scalar */
    assign AnyRegWriteM = (RegWriteM || RegWriteVM);
    /* Any RegWrite signal in Writeback stage, vector or scalar */
    assign AnyRegWriteW = (RegWriteW || RegWriteVW);

    /* Signals from datapath that indicate whether the source registers in
    the Execute stage match the destination registers in the Memory stage */
    assign Match_1E_M = (RA1E == WA3M);
    assign Match_2E_M = (RA2E == WA3M);

    /* Signals from datapath that indicate whether the source registers in
    the Execute stage match the destination registers in the Writeback stage */
    assign Match_1E_W = (RA1E == WA3W);
    assign Match_2E_W = (RA2E == WA3W);


    always_comb begin

        /* Forwarding to SrcAE */
        if (Match_1E_M && AnyRegWriteM) begin
            ForwardAE = 2'b10;  // SrcAE = ALUResultM
            ForwardAVE = 2'b10;  // SrcAE = ALUResultM
        end else if (Match_1E_W && AnyRegWriteW) begin
            ForwardAE = 2'b01;  // SrcAE = ResultW
            ForwardAVE = 2'b01;  // SrcAE = ResultW
        end else begin
            ForwardAE = 2'b00;  // SrcAE = RD from Regfile
            ForwardAVE = 2'b00;  // SrcAE = RD from Regfile
        end

        /* Forwarding to SrcBE */
        if (Match_2E_M && AnyRegWriteM) begin
            ForwardBE = 2'b10;  // SrcBE = ALUResultM
            ForwardBVE = 2'b10;  // SrcBE = ALUResultM
        end else if (Match_2E_W && AnyRegWriteW) begin
            ForwardBE = 2'b01;  // SrcBE = ResultW
            ForwardBVE = 2'b01;  // SrcBE = ResultW
        end else begin
            ForwardBE = 2'b00;  // SrcBE = RD from Regfile
            ForwardBVE = 2'b00;  // SrcBE = RD from Regfile
        end

    end

    /* Verifies if the destination register (WA3E) matches either the
    source operand of the instruction in the Decode stage (RA1D or RA2D) */
    assign Match_12D_E = (RA1D == WA3E) || (RA2D == WA3E);

    /* The MemtoReg signal is asserted for the ldr instruction because it
    does not finish reading data until the end of the Memory stage, so its
    results cannot be forwarded to the Execute stage of the next instruction */
    assign LDRstall = Match_12D_E && MemtoRegE;

    /* When a ldr stall occurs, StallD and StallF are asserted to force the
    Decode and Fetch stage pipeline registers to hold their old values */
    
    /* FlushE is also asserted to clear the contents of the Execute stage\
    pipeline register, introducing a bubble */


    /* Solving Control Hazards (branches) */

    /* A branch multiplexer is added before the PC register to select the branch
    destination from ExtImm, where the address comes from the branch instructions */
    /* The BranchTakenW signla controlling this multiplexer is asserted on branches
    whose condition is satisfied */

    /* When a branch is taken, the subsequent 2 instructions must be flushed from 
    the pipeline registers of the Decode and Execute stages */

    /* When a write to the PC is in the pipeline, the pipeline should be stalled
    until the write completes. This is done by stalling the Fetch stage */

    /* The stalling stage also requires flushing the next to prevent the instruction
    from being executed repeatedly. */

    /* PCWrPending is asserted when a PC write is in progress in D, E or M stage */
    assign PCWrPendingF = (PCSrcD || PCSrcE || PCSrcM);

    /* During this time, the Fetch stage is stalled and the Decode stage is flushed */
    assign StallD = LDRstall || BusyDA;
    assign StallF = LDRstall || PCWrPendingF || BusyDA;

    assign FlushE = LDRstall & ~BusyDA; 

    assign FlushD = PCWrPendingF || PCSrcW || BranchTakenE;


    /* Data Alignment */

    /* Waits for the Data Aligner to finish accesing memory if more than one
    cycle is needed */
    assign StallE = BusyDA;
    assign StallM = BusyDA;
    assign StallW = BusyDA;

  
endmodule
