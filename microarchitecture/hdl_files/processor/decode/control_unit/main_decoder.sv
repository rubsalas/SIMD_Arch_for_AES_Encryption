/*
Control Unit's Main Decoder v2.
Based on the pipeline's implementation from the book
Digital Design and Computer Architecture ARM Editon
by Sarah L. Harries & David Money Harries.

Date: 09/04/24
*/
module main_decoder(
        input  logic [5:0]   Opcode,
        input  logic [2:0]     Func,

        output logic         Branch, //
        output logic [1:0]   RegSrc, //
        output logic         RegW,   //
        output logic         RegWV,  //
        output logic         ALUOp,  //
        output logic         MemW,   //
        output logic         MemSrc,  //
        output logic         MemtoReg, //
        output logic         ALUSrc, //
        output logic [1:0]   ImmSrc, //
        output logic [1:0]   MemData //
    );

    always @ (*)
        casex (Opcode)

            /* Scalar Arithmetic Operations */
			6'b000000: begin
                /* sll => 011 & slr => 111 */
                if (Func[1:0] == 2'b11) begin
                    Branch   = 1'b0;
                    RegSrc   = 2'b00; // 2'b0x;
                    RegW     = 1'b1;
                    RegWV    = 1'b0;
                    ALUOp    = 1'b1;
                    MemW     = 1'b0;
                    MemSrc    = 1'bx;
                    MemtoReg = 1'b0;
                    ALUSrc   = 1'b1;
                    ImmSrc   = 2'b11;
                    MemData  = 2'bxx;
                end

                /* everything else doesn't need to extend the immediate */
                else begin
                    Branch   = 1'b0;
                    RegSrc   = 2'b00; // 2'b0x;
                    RegW     = 1'b1;
                    RegWV    = 1'bx;
                    ALUOp    = 1'b1;
                    MemW     = 1'b0;
                    MemSrc    = 1'b0;
                    MemtoReg = 1'b0;
                    ALUSrc   = 1'b0;
                    ImmSrc   = 2'bxx;
                    MemData  = 2'bxx;
                end
			end
			
			/* Vectorial datapath */ /* Vector Arithmetic Operations */
			6'b100000: begin
				Branch   = 1'b0;
                RegSrc   = 2'b00; // 2'b0x;
                RegW     = 1'b0;
                RegWV    = 1'b1;
                ALUOp    = 1'b1;
                MemW     = 1'b0;
                MemSrc    = 1'bx;
                MemtoReg = 1'b1;
                ALUSrc   = 1'bx;
                ImmSrc   = 2'bxx;
                MemData  = 2'bxx;
			end

			/* Scalar datapath */ /* Scalar Immediate Arithmetic Operations */
			6'b0010xx: begin
				Branch   = 1'b0;
                RegSrc   = 2'b0x; // 2'b0x;
                RegW     = 1'b1;
                RegWV    = 1'b0;
                ALUOp    = 1'b1;
                MemW     = 1'b0;
                MemSrc    = 1'bx;
                MemtoReg = 1'b0;
                ALUSrc   = 1'b1;
                ImmSrc   = 2'b00;
                MemData  = 2'bxx;
			end

			/* Scalar datapath */ /* Scalar memory access */
			6'b0110xx: begin
				/* str */
                if (opcode[1:0] == 2'b00) begin
                    Branch   = 1'b0;
                    RegSrc   = 2'b01; // 2'b0x;
                    RegW     = 1'b0;
                    RegWV    = 1'b0;
                    ALUOp    = 1'b0;
                    MemW     = 1'b1; // Writes on memory
                    MemSrc    = 1'b0;
                    MemtoReg = 1'bx;
                    ALUSrc   = 1'b1;
                    ImmSrc   = 2'b00;
                    MemData  = 2'b0x;
                end
                /* ldr */
                else if (opcode[1:0] == 2'b01) begin
                    Branch   = 1'b0;
                    RegSrc   = 2'b0x; // 2'b0x;
                    RegW     = 1'b1;
                    RegWV    = 1'b0;
                    ALUOp    = 1'b0;
                    MemW     = 1'b0; // Writes on memory
                    MemSrc    = 1'b0;
                    MemtoReg = 1'b1;
                    ALUSrc   = 1'b1;
                    ImmSrc   = 2'b00;
                    MemData  = 2'bxx;
                end
                /* unimplemented */
                else begin
                    Branch   = 1'bx;
                    RegSrc   = 2'bxx; // 2'b0x;
                    RegW     = 1'bx;
                    RegWV    = 1'bx;
                    ALUOp    = 1'bx;
                    MemW     = 1'bx; // Writes on memory
                    MemSrc    = 1'bx;
                    MemtoReg = 1'bx;
                    ALUSrc   = 1'bx;
                    ImmSrc   = 2'bxx;
                    MemData  = 2'bxx;
                end
			end

			/* Vectorial datapath */ /* Vector Memory access */
			6'b1110xx: begin
				/* strv */
                if (opcode[1:0] == 2'b00) begin
                    Branch   = 1'b0;
                    RegSrc   = 2'b01; // 2'b0x;
                    RegW     = 1'b0;
                    RegWV    = 1'b0;
                    ALUOp    = 1'b0;
                    MemW     = 1'b1; // Writes on memory
                    MemSrc    = 1'b1;
                    MemtoReg = 1'bx;
                    ALUSrc   = 1'b1;
                    ImmSrc   = 2'b00;
                    MemData  = 2'b0x;
                end
                /* ldrv */
                else if (opcode[1:0] == 2'b01) begin
                    Branch   = 1'b0;
                    RegSrc   = 2'b0x; // 2'b0x;
                    RegW     = 1'b0;
                    RegWV     = 1'b1;
                    ALUOp    = 1'b0;
                    MemW     = 1'b0; // Writes on memory
                    MemSrc     = 1'b1;
                    MemtoReg = 1'b1;
                    ALUSrc   = 1'b1;
                    ImmSrc   = 2'b00;
                    MemData  = 2'bxx;
                end
                /* unimplemented */
                else begin
                    Branch   = 1'bx;
                    RegSrc   = 2'bxx; // 2'b0x;
                    RegW     = 1'bx;
                    RegWV    = 1'bx;
                    ALUOp    = 1'bx;
                    MemW     = 1'bx; // Writes on memory
                    MemSrc    = 1'bx;
                    MemtoReg = 1'bx;
                    ALUSrc   = 1'bx;
                    ImmSrc   = 2'bxx;
                    MemData  = 2'bxx;
                end
			end

			/* Scalar datapath */ /* Branches */
			6'b0011xx: begin
				/* beq */
                if (opcode[1:0] == 2'b00) begin
                    Branch   = 1'b1;
                    RegSrc   = 2'b01; // 2'b0x;
                    RegW     = 1'b0;
                    RegWV    = 1'b0;
                    ALUOp    = 1'b1;
                    MemW     = 1'b0; // Writes on memory
                    MemSrc    = 1'bx;
                    MemtoReg = 1'bx;
                    ALUSrc   = 1'b0;
                    ImmSrc   = 2'b00;
                    MemData  = 2'bxx;
                end
                /* bgt */
                else if (opcode[1:0] == 2'b01) begin
                    Branch   = 1'b1;
                    RegSrc   = 2'b01; // 2'b0x;
                    RegW     = 1'b0;
                    RegWV    = 1'b0;
                    ALUOp    = 1'b1;
                    MemW     = 1'b0; // Writes on memory
                    MemSrc    = 1'bx;
                    MemtoReg = 1'bx;
                    ALUSrc   = 1'b0;
                    ImmSrc   = 2'b00;
                    MemData  = 2'bxx;
                end
                /* unimplemented */
                else begin
                    Branch   = 1'bx;
                    RegSrc   = 2'bxx; // 2'b0x;
                    RegW     = 1'bx;
                    RegWV    = 1'bx;
                    ALUOp    = 1'bx;
                    MemW     = 1'bx; // Writes on memory
                    MemSrc    = 1'bx;
                    MemtoReg = 1'bx;
                    ALUSrc   = 1'bx;
                    ImmSrc   = 2'bxx;
                    MemData  = 2'bxx;
                end
			end

            /* Scalar datapath */ /* Branch J */
			6'b0001xx: begin
				/* b */
                if (opcode[1:0] == 2'b00) begin
                    Branch   = 1'b1;
                    RegSrc   = 2'b00; // 2'b0x;
                    RegW     = 1'b0;
                    RegWV    = 1'b0;
                    ALUOp    = 1'b0;
                    MemW     = 1'b0; // Writes on memory
                    MemSrc    = 1'bx;
                    MemtoReg = 1'b0;
                    ALUSrc   = 1'b0;
                    ImmSrc   = 2'bxx;
                    MemData  = 2'bxx;
                end
            end

			/* Default */
            /* Datapath management  */
			3'b111: begin
				Branch   = 1'bx;
                RegSrc   = 2'bxx; // 2'b0x;
                RegW     = 1'bx;
                RegWV    = 1'bx;
                ALUOp    = 1'bx;
                MemW     = 1'bx; // Writes on memory
                MemSrc    = 1'bx;
                MemtoReg = 1'bx;
                ALUSrc   = 1'bx;
                ImmSrc   = 2'bxx;
                MemData  = 2'bxx;
			end
    
        endcase

endmodule
