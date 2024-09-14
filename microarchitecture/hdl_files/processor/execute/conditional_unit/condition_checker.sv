/*
Condition Checker Module
Date: 13/09/24
Test bench ran: XX/09/24
*/
module condition_checker(
		input logic [2:0] Opcode,
        input logic [1:0] S,
		input logic [3:0] Flags,
		
		output logic CondEx
	);

	/* Flag assign */
	logic N_flag;
    logic Z_flag;
    logic C_flag;
    logic V_flag;
	assign N_flag = Flags[3];
    assign Z_flag = Flags[2];
    assign C_flag = Flags[1];
    assign V_flag = Flags[0];


	always_comb begin
        
        if (Opcode == 3'b110) begin
            case (S)
                /* EQ -> Equal */
                2'b00:    CondEx = Z_flag;

                /* NE -> Not equal */
                2'b01:    CondEx = ~Z_flag;

                /* GT -> Signed greater than */
                2'b10:    CondEx = ~Z_flag & ~(N_flag ^ V_flag);

                /* Always / unconditional */
                2'b11:    CondEx = 1;
            endcase
        end
		else begin
            /* undefined */
            CondEx = 1'b1;
        end

    end 

endmodule
