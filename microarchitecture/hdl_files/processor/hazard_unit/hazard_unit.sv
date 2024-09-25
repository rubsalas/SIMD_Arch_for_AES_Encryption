/*
Hazard Unit module
IMPLEMENTATION AWAITS
Data: 19/09/24
Test bench ran: XX/09/24
*/
module hazard_unit(
		input  logic PCSrcD,
		input  logic [2:0] RA1D,
		input  logic [2:0] RA2D,

		input  logic PCSrcE,
		input  logic MemtoRegE,
		input  logic BranchTakenE,
		input  logic [2:0] RA1E,
		input  logic [2:0] RA2E,
		input  logic [2:0] WA3E,
		input  logic [2:0] WA3M,
		input  logic [2:0] WA3W,

		input  logic RegWriteM,
		input  logic RegWriteW,
		input  logic RegWriteVM,
		input  logic RegWriteVW,
		input  logic MemtoRegE,

		input  logic PCSrcD,
		input  logic PCSrcE,
		input  logic PCSrcM,
		input  logic RegWriteM,
		input  logic RegWriteVM,
		input  logic [2:0] WA3M,
		input  logic BusyDA,

		input  logic PCSrcW,
		input  logic RegWriteW,
		input  logic RegWriteVW,
		input  logic [2:0] WA3W,
		
		
		output logic StallF,

		output logic StallD,
		output logic StallE,
		output logic StallM,
		output logic StallW,

		output logic FlushD,
		
		output logic StallE,
		output logic FlushE,

		output logic [1:0] ForwardAE,
		output logic [1:0] ForwardBE,
		output logic [1:0] ForwardAVE,
		output logic [1:0] ForwardBVE
	);

	// assign StallF = 1'b0;
	// assign StallD = 1'b0;
	// assign StallE = 1'b0;
	// assign StallM = 1'b0;
	// assign StallW = 1'b0;

	// assign FlushD = 1'b0;
	// assign FlushE = 1'b0;

	// assign ForwardAE = 2'b00;
	// assign ForwardBE = 2'b00;
	// assign ForwardAVE = 2'b00;
	// assign ForwardBVE = 2'b00;


        // Detectar forwarding desde la etapa M a la E para ForwardAE y ForwardBE
        if (RegWriteM && (WA3M != 3'b000)) begin
            if (WA3M == RA1E)
                ForwardAE = 2'b10;  // Forward desde M
            if (WA3M == RA2E)
                ForwardBE = 2'b10;  // Forward desde M
        end

        // Detectar forwarding desde la etapa W a la E para ForwardAE y ForwardBE
        if (RegWriteW && (WA3W != 3'b000)) begin
            if (WA3W == RA1E)
                ForwardAE = 2'b01;  // Forward desde W
            if (WA3W == RA2E)
                ForwardBE = 2'b01;  // Forward desde W
        end

		// Detectar forwarding desde la etapa M a la E para ForwardAVE y ForwardBVE (Registros vectoriales)
        if (RegWriteVM && (WA3M != 3'b000)) begin
            if (WA3M == RA1E)
                ForwardAVE = 2'b10;  // Forward desde MV
            if (WA3M == RA2E)
                ForwardBVE = 2'b10;  // Forward desde MV
        end

		// Detectar forwarding desde la etapa W a la E para ForwardAVE y ForwardBVE (Registros virtuales)
        if (RegWriteVW && (WA3W != 3'b000)) begin
            if (WA3W == RA1E)
                ForwardAVE = 2'b01;  // Forward desde la etapa W
            if (WA3W == RA2E)
                ForwardBVE = 2'b01;  // Forward desde la etapa W
        end

		// Detectar forwarding desde la etapa W a la E para ForwardAVE y ForwardBVE (Registros virtuales)
        if (RegWriteVW && (WA3W != 3'b000)) begin
            if (WA3W == RA1E)
                ForwardAVE = 2'b01;  // Forward desde la etapa W
            if (WA3W == RA2E)
                ForwardBVE = 2'b01;  // Forward desde la etapa W
        end

        // Detectar hazard de carga (stall si MemtoRegE está activo)
        if (MemtoRegE && ((RA1D == WA3E) || (RA2D == WA3E))) begin
            StallF = 1;
            StallD = 1;
            FlushE = 1;
        end

        // Flush por Branch Taken en la etapa E
        if (BranchTakenE || PCSrcE) begin
            FlushD = 1;  // Vaciar D si el branch se tomó o el PC cambió
            FlushE = 1;  // Vaciar E ya que las instrucciones son incorrectas
        end

        // Stalls y flushes adicionales basados en PCSrc en otras etapas
        if (PCSrcM || PCSrcW) begin
            FlushD = 1;  // Vaciar D si hay un cambio de PC en M o W
            FlushE = 1;  // Vaciar E también
        end

        // Stall por Busy
        if (Busy) begin
            StallF = 1;
            StallD = 1;
            StallE = 1;
            StallM = 1;
            StallW = 1;
        end
  
endmodule
