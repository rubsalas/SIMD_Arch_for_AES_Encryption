/*
PC Logic testbench 
Date: 20/03/24
*/

module pc_logic_tb;

    logic [4:0] Rd;
	logic		Branch;
	logic		RegW;
    logic		PCS;

    /* pc_logic instance */
    pc_logic uut (.Rd(Rd),
                  .Branch(Branch),
                  .RegW(RegW),
                  .PCS(PCS));

    initial begin
        $display("pc_logic testbench:\n");

        Rd <= 5'b0000;
        Branch <= 1'b0;
        RegW <= 1'b0;

    	$monitor("\nRd=%b (%d)\n", Rd, Rd,
                 "Branch=%b ", Branch,
                 "RegW=%b ", RegW,
                 "PCS=%b\n", PCS);
    end

    initial begin

        #100

        $display("\n\nRd not PC (1'b11111):\n");

        #50

        assert((PCS === 0))
        else $error("Failed @ Rd=%b, Branch=%b, RegW=%b", Rd, Branch, RegW);

        #50

        RegW <= 1'b0;
        Branch <= 1'b1;

        #50

        assert((PCS === 1))
        else $error("Failed @ Rd=%b, Branch=%b, RegW=%b", Rd, Branch, RegW);

        #50

        RegW <= 1'b1;
        Branch <= 1'b0;

        #50

        assert((PCS === 0))
        else $error("Failed @ Rd=%b, Branch=%b, RegW=%b", Rd, Branch, RegW);

        #50

        RegW <= 1'b1;
        Branch <= 1'b1;

        #50

        assert((PCS === 1))
        else $error("Failed @ Rd=%b, Branch=%b, RegW=%b", Rd, Branch, RegW);

        #50

        RegW <= 1'b0;
        Branch <= 1'b0;

        #100

        $display("Rd is PC (5'b01111):\n");
        Rd <= 5'b01111;

        #50

        assert((PCS === 0))
        else $error("Failed @ Rd=%b, Branch=%b, RegW=%b", Rd, Branch, RegW);

        #50

        RegW <= 1'b0;
        Branch <= 1'b1;

        #50

        assert((PCS === 1))
        else $error("Failed @ Rd=%b, Branch=%b, RegW=%b", Rd, Branch, RegW);

        #50

        RegW <= 1'b1;
        Branch <= 1'b0;

        #50

        assert((PCS === 1))
        else $error("Failed @ Rd=%b, Branch=%b, RegW=%b", Rd, Branch, RegW);

        #50

        RegW <= 1'b1;
        Branch <= 1'b1;

        #50

        assert((PCS === 1))
        else $error("Failed @ Rd=%b, Branch=%b, RegW=%b", Rd, Branch, RegW);

        #50

        #100;
    end

    initial
	#1500 $finish;
    
endmodule
