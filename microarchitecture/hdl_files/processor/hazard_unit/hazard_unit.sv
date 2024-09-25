/*
Hazard Unit v2 module
Data: 24/09/24
Test bench ran: XX/09/24
*/
module hazard_unit # (parameter R = 5) (
		input  logic PCSrcD,
		input  logic [R-1:0] RA1D,
		input  logic [R-1:0] RA2D,

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
		output logic [1:0] ForwardAE,
		output logic [1:0] ForwardBE,
		output logic [1:0] ForwardAVE,
		output logic [1:0] ForwardBVE,
        
        output logic StallM,
        
        output logic StallW
	);

    always_comb begin

        // Detectar forwarding desde la etapa M a la E para ForwardAE y ForwardBE
        if (RegWriteM && (WA3M != 5'b000)) begin
            if (WA3M == RA1E)
                ForwardAE = 2'b10;  // Forward desde M
            if (WA3M == RA2E)
                ForwardBE = 2'b10;  // Forward desde M
        end

        // Detectar forwarding desde la etapa W a la E para ForwardAE y ForwardBE
        if (RegWriteW && (WA3W != 5'b000)) begin
            if (WA3W == RA1E)
                ForwardAE = 2'b01;  // Forward desde W
            if (WA3W == RA2E)
                ForwardBE = 2'b01;  // Forward desde W
        end

		// Detectar forwarding desde la etapa M a la E para ForwardAVE y ForwardBVE (Registros vectoriales)
        if (RegWriteVM && (WA3M != 5'b000)) begin
            if (WA3M == RA1E)
                ForwardAVE = 2'b10;  // Forward desde MV
            if (WA3M == RA2E)
                ForwardBVE = 2'b10;  // Forward desde MV
        end

		// Detectar forwarding desde la etapa W a la E para ForwardAVE y ForwardBVE (Registros virtuales)
        if (RegWriteVW && (WA3W != 5'b000)) begin
            if (WA3W == RA1E)
                ForwardAVE = 2'b01;  // Forward desde la etapa W
            if (WA3W == RA2E)
                ForwardBVE = 2'b01;  // Forward desde la etapa W
        end

		// Detectar forwarding desde la etapa W a la E para ForwardAVE y ForwardBVE (Registros virtuales)
        if (RegWriteVW && (WA3W != 5'b000)) begin
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
        if (BusyDA) begin
            StallF = 1;
            StallD = 1;
            StallE = 1;
            StallM = 1;
            StallW = 1;
        end

    end
  
endmodule
