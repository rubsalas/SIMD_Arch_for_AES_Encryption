/*
Register File Vector module
Date: 30/08/24
Test bench ran: 30/08/24
IMPLEMENTAR ESCRITURA Y LECTURA SERIAL DE 32 BITS A 256
*/
module register_file_vector # (parameter N = 256) (
		input  logic         clk,
		input  logic         rst,
		input  logic [4:0]   VA1,      // RA1D - same as scalar
		input  logic [4:0]   VA2,      // RA2D - same as scalar
		input  logic [4:0]   VA3,      // WA3W - same as scalar
		input  logic [N-1:0] VWD3,     // reg_write_data data
		input  logic         VWE3,     // reg_write_en

		output logic [N-1:0] VRD1,     // reg_read_data_1
		output logic [N-1:0] VRD2      // reg_read_data_2
	);

	logic [N-1:0] reg_array_vector [7:0];

	always @ (posedge clk or posedge rst) begin

		if(rst) begin
			reg_array_vector[0] <= 256'h0;
			reg_array_vector[1] <= 256'h0;
			reg_array_vector[2] <= 256'h0;
			reg_array_vector[3] <= 256'h0;
			reg_array_vector[4] <= 256'h0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005;
			reg_array_vector[5] <= 256'h0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003;
			reg_array_vector[6] <= 256'h0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002;
			reg_array_vector[7] <= 256'h0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001;
		end
		else begin
			/* If writing on register VA3 is allowed */
			if(VWE3) begin
				reg_array_vector[VA3[2:0]] <= VWD3;
			end
		end
	end

	always_comb begin
		/* As this is only vector values, checks VA1 value */
		if (VA1[4] == 1'b1) begin
			VRD1 = reg_array_vector[VA1[2:0]];
		end
		else begin
			VRD1 = 256'b11111111111111111111111111111111;
		end

		/* As this is only vector values, checks VA1 value */
		if (VA2[4] == 1'b1) begin
			VRD2 = reg_array_vector[VA2[2:0]];
		end
		else begin
			VRD2 = 256'b11111111111111111111111111111111;
		end
	end

endmodule
