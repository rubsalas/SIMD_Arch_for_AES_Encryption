/*
Test bench for instruction_memory v3 module.
Date: 29/08/24
Approved
*/
module instruction_memory_tb;

    parameter N = 32;

    logic [13:0] address;	    // from PC to A in instruction memory
    logic [N-1:0] instruction;	// from ALUResult to A in data memory

	/* ASIP Processor */
	instruction_memory #(.N(N)) uut (.address(address),
						             .instruction(instruction));

	// Initialize inputs
    initial begin
		$display("instruction_memory testbench:\n");

		address = 14'h0;      
        
        $monitor("Instruction Memory Signals:\n",
                 "address = %b (%d) ", address, address,
                 "instruction = %b (%h)\n\n", instruction, instruction);
    end

    initial	begin

        #200

		address = 14'd0;

        #100

        address = 14'd4;

        #100

        address = 14'd8;

        #100

        address = 14'd12;

        #100

        address = 14'd16;

        #100;

    end

    initial
	#1000 $finish;                                 

endmodule
