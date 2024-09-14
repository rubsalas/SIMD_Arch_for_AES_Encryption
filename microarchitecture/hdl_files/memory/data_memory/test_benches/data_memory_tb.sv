/*
Data Memory (IP Module) testbench 
Date: 13/09/24
Approved
*/
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module data_memory_tb;

    // Testbench signals
    reg [13:0] address;
    reg clock;
    reg [7:0] data;
    reg wren;
    wire [7:0] q;
    integer i;

    // Instantiate the data_memory module
    data_memory uut (
        .address(address),
        .clock(clock),
        .data(data),
        .wren(wren),
        .q(q)
    );

    // Clock generation
    always #10 clock = ~clock;

    // Procedure to print the memory addresses from 0x0000 to 0x0020
    task print_memory_contents;
        begin
            $display("Memory content (addresses 0x0000 to 0x0020):");
            for (i = 0; i < 32; i = i + 1) begin
                address = i;
                #20; // Wait for the address to settle
                $display("Address %h: %h", address, q);
            end
        end
    endtask

    // Test sequence
    initial begin
        // Initialize signals
        clock = 0;
        wren = 0;
        data = 8'b00000000;
        address = 14'b00000000000000;

        $display("Starting memory tests...\n");

        // Wait for reset (if any) to pass
        #20;

        // Test 1: Write and Read Test
        $display("Test 1: Write and read back");
        address = 14'h0001;
        data = 8'hA5;
        wren = 1;
        #20;
        $display("Wrote %h to address %h with write enable = %b", data, address, wren);
        wren = 0;  // Disable write, now read
        #20;
        $display("Read %h from address %h with write enable = %b", q, address, wren);
        if (q == 8'hA5) 
            $display("Test 1 Passed: Read data matches written data at address %h", address);
        else 
            $display("Test 1 Failed: Expected A5, got %h at address %h", q, address);

        // Print first 32 memory locations
        print_memory_contents();

        // Test 2: Write to a different address and read back
        $display("Test 2: Write to different address and read back");
        address = 14'h0002;
        data = 8'h3C;
        wren = 1;
        #20;
        $display("Wrote %h to address %h with write enable = %b", data, address, wren);
        wren = 0;
        #20;
        $display("Read %h from address %h with write enable = %b", q, address, wren);
        if (q == 8'h3C)
            $display("Test 2 Passed: Read data matches written data at address %h", address);
        else
            $display("Test 2 Failed: Expected 3C, got %h at address %h", q, address);

        // Print first 32 memory locations
        print_memory_contents();

        // Test 3: Check previous address still holds its value
        $display("Test 3: Check previous write at address 0001");
        address = 14'h0001;
        #20;
        $display("Read %h from address %h with write enable = %b", q, address, wren);
        if (q == 8'hA5)
            $display("Test 3 Passed: Previous write retained at address %h", address);
        else
            $display("Test 3 Failed: Expected A5, got %h at address %h", q, address);

        // Print first 32 memory locations
        print_memory_contents();

        // Test 4: Write and immediately read back
        $display("Test 4: Immediate read after write");
        address = 14'h0003;
        data = 8'h7E;
        wren = 1;
        #20;
        $display("Wrote %h to address %h with write enable = %b", data, address, wren);
        wren = 0;
        #20;
        $display("Read %h from address %h with write enable = %b", q, address, wren);
        if (q == 8'h7E)
            $display("Test 4 Passed: Immediate read matches written data at address %h", address);
        else
            $display("Test 4 Failed: Expected 7E, got %h at address %h", q, address);

        // Print first 32 memory locations
        print_memory_contents();

        // End simulation
        $display("Memory tests completed.");
        #100;
        $finish;
    end

endmodule
