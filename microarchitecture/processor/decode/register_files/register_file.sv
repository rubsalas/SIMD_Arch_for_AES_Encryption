/*
Register File v2 module
Date: 30/08/24
Test bench ran: 30/08/24
*/
module register_file # (parameter N = 32) (
		input  logic         clk,
		input  logic         rst,
		input  logic [4:0]    A1,     // RA1D / reg_read_addr_1
		input  logic [4:0]    A2,     // RA2D / reg_read_addr_2
		input  logic [4:0]    A3,     // WA3W / reg_write_dest address
		input  logic [N-1:0] WD3,     // ResultW / reg_write_data data
		input  logic [N-1:0] R15,     // PCPlus8D / reg_write_r15
		input  logic         WE3,     // RegWriteW / reg_write_en

		output logic [N-1:0] RD1,     // RD1 / reg_read_data_1
		output logic [N-1:0] RD2      // RD2 / reg_read_data_2 
	);

	/* As this is only scalar values */

	logic [N-1:0] reg_array [15:0];

	always @ (posedge clk or posedge rst) begin

		if(rst) begin  
			reg_array[0]  <= 32'h00000;  // zero
			reg_array[1]  <= 32'hDE000;  // sp <= ADDRESS POR DEFINIR
			reg_array[2]  <= 32'h0;      // lr
			reg_array[3]  <= 32'h0;      // cpsr
			reg_array[4]  <= 32'h0;      // r0
			reg_array[5]  <= 32'h0;      // r1
			reg_array[6]  <= 32'h0;      // r2
			reg_array[7]  <= 32'h0;      // r3
			reg_array[8]  <= 32'h0;      // e0
			reg_array[9]  <= 32'h0;      // e1
			reg_array[10] <= 32'h0;      // e2
			reg_array[11] <= 32'h0;      // e3
			reg_array[12] <= 32'h0;      // e4
			reg_array[13] <= 32'h0;      // e5
			reg_array[14] <= 32'h0;      // e6
			reg_array[15] <= 32'h0;      // pc       
		end
		else begin
			/* As this is only scalar values, checks A1 value */
			if (A1[4] == 1'b0) begin
				RD1 = (A1 == 0) ? 32'b0 : reg_array[A1]; // if reg == $zero -> return 0
			end
			else begin
				RD1 = 32'b11111111111111111111111111111111;
			end

			/* As this is only scalar values, checks A2 value */
			if (A2[4] == 1'b0) begin
				RD2 = (A2 == 0) ? 32'b0 : reg_array[A2]; // if reg == $zero -> return 0
			end
			else begin
				RD2 = 32'b11111111111111111111111111111111;
			end

			/* If writing on register A3 is allowed */
			if(WE3) begin
				reg_array[A3] = WD3; 
			end  
		end

		assign reg_array[15] = R15; /* Writes PCPlus8 on reg 15 always */
		
	end

endmodule
