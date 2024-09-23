/*
Control Unit's Main Decoder v2.
Based on the pipeline's implementation from the book
Digital Design and Computer Architecture ARM Editon
by Sarah L. Harries & David Money Harries.

Date: 09/04/24
Test bench ran: XX/09/24
*/
module main_decoder(
        input  logic [5:0]   Opcode,        // Added
        input  logic [2:0]   Func,          // Added

        output logic         RegW,          // Added 
        output logic         RegWV,         // Added

        output logic         MemtoReg,      // Added

        output logic         MemW,          // Added
        output logic         MemSrc,        // Added
        output logic         MemData,       // Added
        output logic         MemDataV,       // Added
        output logic         VecData,       // Added

        output logic         Branch,        // Added
        output logic         ALUOp,         // Added
        output logic         ALUSrc,        // Added

        output logic [1:0]   RegSrc,        // Added
        output logic [1:0]   ImmSrc         // Added
    );

    always @ (*)
        casex (Opcode)

            /* Scalar Arithmetic Operations */
			6'b000000: begin
                /* sll => 011 & slr => 111 */
                if (Func[1:0] == 2'b11) begin
                    RegW     = 1'b1;
                    RegWV    = 1'b0;
                    MemtoReg = 1'b0;
                    MemW     = 1'b0;
                    MemSrc   = 1'bx;
                    MemData  = 1'bx;
                    MemDataV = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'b0;
                    ALUOp    = 1'b1;
                    ALUSrc   = 1'b1;
                    RegSrc   = 2'b0x; // 2'b0x;
                    ImmSrc   = 2'b11;
                end

                /* everything else doesn't need to extend the immediate */
                else begin
                    RegW     = 1'b1;
                    RegWV    = 1'b0;
                    MemtoReg = 1'b0;
                    MemW     = 1'b0;
                    MemSrc   = 1'bx;
                    MemData  = 1'bx;
                    MemDataV  = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'b0;
                    ALUOp    = 1'b1;
                    ALUSrc   = 1'b0;
                    RegSrc   = 2'b00; // 2'b0x;
                    ImmSrc   = 2'bxx;
                end
			end
			
			/* Vector Arithmetic Operations */
			6'b100000: begin
				RegW     = 1'b0;
                RegWV    = 1'b1;
                MemtoReg = 1'b1;
                MemW     = 1'b0;
                MemSrc   = 1'bx;
                MemData  = 1'bx;
                MemDataV = 1'bx;
                VecData  = 1'bx;
                Branch   = 1'b0;
                ALUOp    = 1'b1;
                ALUSrc   = 1'bx;
                RegSrc   = 2'b00; // 2'b0x;
                ImmSrc   = 2'bxx;
			end

			/* Scalar Immediate Arithmetic Operations */
			6'b0010xx: begin
				RegW     = 1'b1;
                RegWV    = 1'b0;
                MemtoReg = 1'b0;
                MemW     = 1'b0;
                MemSrc   = 1'bx;
                MemData  = 1'bx;
                MemDataV = 1'bx;
                VecData  = 1'bx;
                Branch   = 1'b0;
                ALUOp    = 1'b1;
                ALUSrc   = 1'b1;
                RegSrc   = 2'b0x; // 2'b0x;
                ImmSrc   = 2'b00;
			end

			/* Scalar memory access */
			6'b0110xx: begin
				/* str */
                if (Opcode[1:0] == 2'b00) begin
                    RegW     = 1'b0;
                    RegWV    = 1'b0;
                    MemtoReg = 1'bx;
                    MemW     = 1'b1;
                    MemSrc   = 1'b0;
                    MemData  = 1'b0;
                    MemDataV  = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'b0;
                    ALUOp    = 1'b0;
                    ALUSrc   = 1'b1;
                    RegSrc   = 2'b01; // 2'b0x;
                    ImmSrc   = 2'b00;
                end
                /* ldr */
                else if (Opcode[1:0] == 2'b01) begin
                    RegW     = 1'b1;
                    RegWV    = 1'b0;
                    MemtoReg = 1'b1;
                    MemW     = 1'b0;
                    MemSrc   = 1'b0;
                    MemData  = 1'bx;
                    MemDataV = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'b0;
                    ALUOp    = 1'b0;
                    ALUSrc   = 1'b1;
                    RegSrc   = 2'b0x; // 2'b0x;
                    ImmSrc   = 2'b00;
                end
                /* unimplemented */
                else begin
                    RegW     = 1'bx;
                    RegWV    = 1'bx;
                    MemtoReg = 1'bx;
                    MemW     = 1'bx;
                    MemSrc   = 1'bx;
                    MemData  = 1'bx;
                    MemDataV = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'bx;
                    ALUOp    = 1'bx;
                    ALUSrc   = 1'bx;
                    RegSrc   = 2'bxx; // 2'b0x;
                    ImmSrc   = 2'bxx;
                end
			end

			/* Vector Memory access */
			6'b1110xx: begin
				/* strv */
                if (Opcode[1:0] == 2'b00) begin
                    RegW     = 1'b0;
                    RegWV    = 1'b0;
                    MemtoReg = 1'bx;
                    MemW     = 1'b1;
                    MemSrc   = 1'b1;
                    MemData  = 1'bx;
                    MemDataV = 1'b0;
                    VecData  = 1'bx;
                    Branch   = 1'b0;
                    ALUOp    = 1'b0;
                    ALUSrc   = 1'b1;
                    RegSrc   = 2'b01; // 2'b0x;
                    ImmSrc   = 2'b00;
                end
                /* ldrv */
                else if (Opcode[1:0] == 2'b01) begin
                    RegW     = 1'b0;
                    RegWV    = 1'b1;
                    MemtoReg = 1'b1;
                    MemW     = 1'b0;
                    MemSrc   = 1'b1;
                    MemData  = 1'bx;
                    MemDataV = 1'bx;
                    VecData  = 1'b1;
                    Branch   = 1'b0;
                    ALUOp    = 1'b0;
                    ALUSrc   = 1'b1;
                    RegSrc   = 2'b0x; // 2'b0x;
                    ImmSrc   = 2'b00;
                end
                /* unimplemented */
                else begin
                    RegW     = 1'bx;
                    RegWV    = 1'bx;
                    MemtoReg = 1'bx;
                    MemW     = 1'bx;
                    MemSrc   = 1'bx;
                    MemData  = 1'bx;
                    MemDataV = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'bx;
                    ALUOp    = 1'bx;
                    ALUSrc   = 1'bx;
                    RegSrc   = 2'bxx; // 2'b0x;
                    ImmSrc   = 2'bxx;
                end
			end

			/* Scalar datapath */ /* Branches */
			6'b0011xx: begin
				/* beq */
                if (Opcode[1:0] == 2'b00) begin
                    RegW     = 1'b0;
                    RegWV    = 1'b0;
                    MemtoReg = 1'bx;
                    MemW     = 1'b0;
                    MemSrc   = 1'bx;
                    MemData  = 1'bx;
                    MemDataV = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'b1;
                    ALUOp    = 1'b1;
                    ALUSrc   = 1'b0;
                    RegSrc   = 2'b01; // 2'b0x;
                    ImmSrc   = 2'b00;
                end
                /* bgt */
                else if (Opcode[1:0] == 2'b01) begin
                    RegW     = 1'b0;
                    RegWV    = 1'b0;
                    MemtoReg = 1'bx;
                    MemW     = 1'b0;
                    MemSrc   = 1'bx;
                    MemData  = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'b1;
                    ALUOp    = 1'b1;
                    ALUSrc   = 1'b0;
                    RegSrc   = 2'b01; // 2'b0x;
                    ImmSrc   = 2'b00;
                end
                /* unimplemented */
                else begin
                    RegW     = 1'bx;
                    RegWV    = 1'bx;
                    MemtoReg = 1'bx;
                    MemW     = 1'bx;
                    MemSrc   = 1'bx;
                    MemData  = 1'bx;
                    MemDataV = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'bx;
                    ALUOp    = 1'bx;
                    ALUSrc   = 1'bx;
                    RegSrc   = 2'bxx; // 2'b0x;
                    ImmSrc   = 2'bxx;
                end
			end

            /* Branch J */
			6'b0001xx: begin
				/* b */
                if (Opcode[1:0] == 2'b00) begin
                    RegW     = 1'b0;
                    RegWV    = 1'b0;
                    MemtoReg = 1'bx;
                    MemW     = 1'b0;
                    MemSrc   = 1'bx;
                    MemData  = 1'bx;
                    MemDataV = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'b1;
                    ALUOp    = 1'b0;
                    ALUSrc   = 1'bx;
                    RegSrc   = 2'bxx; // 2'b0x;
                    ImmSrc   = 2'b01;
                end
            end

			/* Default */
            /* Datapath management  */
			3'b111: begin
				    RegW     = 1'bx;
                    RegWV    = 1'bx;
                    MemtoReg = 1'bx;
                    MemW     = 1'bx;
                    MemSrc   = 1'bx;
                    MemData  = 1'bx;
                    MemDataV = 1'bx;
                    VecData  = 1'bx;
                    Branch   = 1'bx;
                    ALUOp    = 1'bx;
                    ALUSrc   = 1'bx;
                    RegSrc   = 2'bxx; // 2'b0x;
                    ImmSrc   = 2'bxx;
			end
    
        endcase

endmodule
