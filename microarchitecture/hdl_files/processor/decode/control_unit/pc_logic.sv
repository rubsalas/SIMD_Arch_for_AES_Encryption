/*
PC Logic del Decoder del Control Unit
Logica basada del libro
Digital Design and Computer Architecture ARM Editon
de Sarah L. Harries & David Money Harries.

PCS = [ (Rd == 15) & RegW ] | Branch
Date: 14/09/24
*/
module pc_logic(
    input  logic [4:0] Rd,
    input  logic Branch,
    input  logic RegW,

    output logic PCS 
);

    always_comb begin 
    
        if (((Rd == 0'b01111) & RegW) | Branch)
            PCS = 1;
        else 
            PCS = 0;

    end

endmodule
