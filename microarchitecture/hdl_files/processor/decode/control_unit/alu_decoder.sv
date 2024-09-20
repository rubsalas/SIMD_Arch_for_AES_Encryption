/*
Control Unit's ALU Decoder v2.
Based on the pipeline's implementation from the book
Digital Design and Computer Architecture ARM Editon
by Sarah L. Harries & David Money Harries.

Date: 14/09/24
Test bench ran: XX/09/24
*/
module alu_decoder(
        input  logic [5:0]     Opcode,
        input  logic [2:0]       Func,
        input  logic            ALUOp,

        output logic [2:0] ALUControl,
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
                        end

                        /* sub */
                        3'b001 : begin
                            ALUControl = 3'b001;
                        end

                        /* mul */
                        3'b010 : begin
                            ALUControl = 3'b010;
                        end

                        /* sll */
                        3'b011 : begin
                            ALUControl = 3'b011;
                        end

                        /* slr */
                        3'b111 : begin
                            ALUControl = 3'b111;
                        end

                        /* xor */
                        3'b101 : begin
                            ALUControl = 3'b101;
                        end

                        /* default */
                        default : begin 
                            ALUControl = 3'bxxx;
                        end
                    
                    endcase
                end
                
                /* Vectorial datapath */ /* Vector Arithmetic Operations */
                6'b100000: begin
                    casex (Func)

                        /* addv */
                        3'b000 : begin
                            ALUControl = 3'b000;
                        end

                        /* subv */
                        3'b001 : begin
                            ALUControl = 3'b001;
                        end

                        /* mulv */
                        3'b010 : begin
                            ALUControl = 3'b010;
                        end

                        /* unimplemented */
                        3'b101 : begin
                            ALUControl = 3'b101;
                        end

                        /* unimplemented */
                        3'b111 : begin
                            ALUControl = 3'bxxx;
                        end

                        /* default */
                        default : begin 
                            ALUControl = 3'bxxx;
                        end
                    
                    endcase
                end

                /* Scalar datapath */ /* Scalar Immediate Arithmetic Operations */
                6'b001000: begin

                    /* addi */
                    ALUControl = 3'b000;
                end

                6'b001001: begin

                    /* subi */
                    ALUControl = 3'b001;
                end

                6'b001010: begin

                    /* muli */
                    ALUControl = 3'b010;
                end

                /* Scalar datapath */ /* Branches */
                6'b000100: begin
                    ALUControl = 3'b001; // Branches use substraction for flag generation
                end

                /* ... */

                /* default */
                default : begin 
                    ALUControl = 3'b000; // add
                end
            
            endcase
            
        end
        else begin
            ALUControl = 3'b000; // add
        end

endmodule
