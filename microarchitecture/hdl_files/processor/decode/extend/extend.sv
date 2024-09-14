/*
Extend Module v3
Makes Zero Extention with updated instruction bitstream
Date: 29/08/24
Test bench ran: 30/08/24
*/
module extend # (parameter N = 32) (
	input  logic  [25:0]      A,
    input  logic   [1:0] ImmSrc,

	output logic [N-1:0] ExtImm
	);

	always @(*)
        casex (ImmSrc)

            /* Sign extension copying value of bit 15 */
            /* Immediate on I Instructions */
            2'b00 : begin
                ExtImm = {{16{A[15]}}, A[15:0]};
            end 

            /* Zero Extention 5 bits */
            /* Address on J Instructions */
            2'b01 : begin
                ExtImm = {6'b0, A[25:0]};
            end

            /* 2'b10 */

            /* Zero Extention 21 bits and right shift 3 bits*/
            /* Shamt on R Instructions */
            2'b11 : begin
                ExtImm = {24'b0, A[10:3]};
            end

			default : begin
				ExtImm = 24'b111111111111111111111111;
			end

		endcase

endmodule
