/*
Control Unit's ALU Decoder v2.
Based on the pipeline's implementation from the book
Digital Design and Computer Architecture ARM Editon
by Sarah L. Harries & David Money Harries.

Date: 14/09/24
*/
module alu_decoder(
        input  logic [5:0]     Opcode,
        input  logic [2:0]       Func,
        input  logic            ALUOp,

        output logic [2:0] ALUControl,
        output logic           ALUSel,
        output logic [1:0]  FlagWrite
    );

    /* All 1's so that flags are always writen if conditions are met */
    assign FlagWrite = 2'b11;

    always @ (*)
        if (ALUOp) begin

            casex (Opcode)

                /* Scalar datapath */ /* Scalar Arithmetic Operations */
                6'b000000: begin
                    casex (Func)

                        /* add */
                        3'b000 : begin
                            ALUControl = 3'b000;
                            ALUSel = 1'b0;
                        end

                        /* sub */
                        3'b001 : begin
                            ALUControl = 3'b001;
                            ALUSel = 1'b0;
                        end

                        /* mul */
                        3'b010 : begin
                            ALUControl = 3'b010;
                            ALUSel = 1'b0;
                        end

                        /* sll */
                        3'b011 : begin
                            ALUControl = 3'b011;
                            ALUSel = 1'b0;
                        end

                        /* slr */
                        3'b100 : begin
                            ALUControl = 3'b111;
                            ALUSel = 1'b0;
                        end

                        /* default */
                        default : begin 
                            ALUControl = 3'bxxx;
                            ALUSel = 1'bx;
                        end
                    
                    endcase
                end
                
                /* Vectorial datapath */ /* Vector Arithmetic Operations */
                6'b100000: begin
                    casex (Func)

                        /* addv */
                        3'b000 : begin
                            ALUControl = 3'b000;
                            ALUSel = 1'b0;
                        end

                        /* subv */
                        3'b001 : begin
                            ALUControl = 3'b001;
                            ALUSel = 1'b0;
                        end

                        /* mulv */
                        3'b010 : begin
                            ALUControl = 3'b010;
                            ALUSel = 1'b0;
                        end

                        /* unimplemented */
                        3'b011 : begin
                            ALUControl = 3'bxxx;
                            ALUSel = 1'bx;
                        end

                        /* unimplemented */
                        3'b111 : begin
                            ALUControl = 3'bxxx;
                            ALUSel = 1'bx;
                        end

                        /* default */
                        default : begin 
                            ALUControl = 3'bxxx;
                            ALUSel = 1'bx;
                        end
                    
                    endcase
                end

                /* Scalar datapath */ /* Scalar Immediate Arithmetic Operations */
                6'b001000: begin

                    /* addi */
                    ALUControl = 3'b000;
                    ALUSel = 1'b0;
                end

                6'b001001: begin

                    /* subi */
                        ALUControl = 3'b001;
                        ALUSel = 1'b0;
                end

                6'b001010: begin

                    /* muli */
                        ALUControl = 3'b010;
                        ALUSel = 1'b0;
                end

                /* Scalar datapath */ /* Branches */
                6'b000100: begin
                    ALUControl = 3'b001; // Branches use substraction for flag generation
                    ALUSel = 1'b0;
                end

                /* ... */

                /* default */
                default : begin 
                    ALUControl = 3'b000; // add
                    ALUSel = 1'b0; // no fp alu
                end
            
            endcase
            
        end
        else begin
            ALUControl = 3'b000; // add
            ALUSel = 1'b0; // no fp alu
        end

endmodule
