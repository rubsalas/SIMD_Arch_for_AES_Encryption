/*
Full Adder module
Date: 31/08/24
Test bench ran: 31/08/24
*/
module full_adder(
    input  logic A,         // Bit A
    input  logic B,         // Bit B
    input  logic C_in,      // Carry In
    output logic R,        // Resultado (Suma)
    output logic C_out     // Carry Out
);

    assign R = A ^ B ^ C_in;              // Suma bit a bit con carry in
    assign C_out = (A & B) | (A & C_in) | (B & C_in); // Calculo de carry out

endmodule
