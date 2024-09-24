/*
Conditional Logic testbench 
Date: 17/09/24
Approved
*/  
module data_aligner_tb;

    logic clk;
    logic rst;
    logic memtoRegM;
    logic memWriteM;
    logic memSrcM;
    logic [31:0] address;
    logic [15:0] scalarDataIn; 
    logic [255:0] vectorDataIn;
    logic [255:0] readData;
    
    logic busy;
    logic [31:0] scalarDataOut;
    logic [255:0] vectorDataOut;
    
    logic rden;
    logic wren;
    logic [13:0] ip_address;
    logic [31:0] byteena;
    logic [255:0] writeData;
    
    // Instancia del módulo data_aligner
    data_aligner uut (
        .clk(clk),
        .rst(rst),
        .memtoRegM(memtoRegM),
        .memWriteM(memWriteM),
        .memSrcM(memSrcM),
        .address(address),
        .scalarDataIn(scalarDataIn),
        .vectorDataIn(vectorDataIn),
        .busy(busy),
        .scalarDataOut(scalarDataOut),
        .vectorDataOut(vectorDataOut),
        .readData(readData),
        .rden(rden),
        .wren(wren),
        .ip_address(ip_address),
        .byteena(byteena),
        .writeData(writeData)
    );

    // Generación del reloj
    always #10 clk = ~clk;

    // Test sequence
    initial begin
        // Inicialización
        clk = 0;
        rst = 1;
        memtoRegM = 0;
        memWriteM = 0;
        memSrcM = 0;
        address = 32'b0;
        scalarDataIn = 16'b0;
        vectorDataIn = 256'b0;
        readData = 256'b0;
        
        // Se desactiva el rst
        #20 rst = 0;

        // ------------- Test 1: Escritura escalar alineada --------------
        $display("Test 1: Escritura escalar alineada en direccion 0x00000000");
        address = 32'h00000000;  // Alineado a 256 bits
        scalarDataIn = 16'h1234;
        memWriteM = 1;
        memSrcM = 0;  // Operación escalar
        #20;
        $display("writeData: %h, byteena: %h", writeData, byteena);
        assert(writeData == 256'h00000000000000000000000000000000000000000000000000000000_00001234) 
        else $fatal("Test 1 fallo");
        assert(byteena == 32'h00000003) 
        else $fatal("Test 1 byteena fallo");
        memWriteM = 0;

        // ------------- Test 2: Escritura escalar no alineada --------------
        $display("Test 2: Escritura escalar no alineada en direccion 0x00000010");
        address = 32'h00000010;  // No alineado
        scalarDataIn = 16'h5678;
        memWriteM = 1;
        memSrcM = 0;  // Operación escalar
        #20;
        $display("writeData: %h, byteena: %h", writeData, byteena);
        assert(writeData == 256'h0000000000000000000000000000567800000000000000000000000000000000) 
        else $fatal("Test 2 fallo");
        assert(byteena == 32'h00030000) 
        else $fatal("Test 2 byteena fallo");
        memWriteM = 0;

        // ------------- Test 3: Escritura vectorial alineada --------------
        $display("Test 3: Escritura vectorial alineada en direccion 0x00000000");
        address = 32'h00000000;  // Alineado
        vectorDataIn = 256'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB_CCCCCCCCCCCCCCCC_DDDDDDDDDDDDDDDD;
        memWriteM = 1;
        memSrcM = 1;  // Operación vectorial
        #20;
        $display("writeData: %h, byteena: %h", writeData, byteena);
        assert(writeData == 256'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB_CCCCCCCCCCCCCCCC_DDDDDDDDDDDDDDDD) 
        else $fatal("Test 3 fallo");
        assert(byteena == 32'hFFFFFFFF) 
        else $fatal("Test 3 byteena fallo");
        memWriteM = 0;

        // ------------- Test 4: Escritura vectorial no alineada --------------
        $display("Test 4: Escritura vectorial no alineada en direccion 0x00000010");
        address = 32'h00000010;  // No alineado
        vectorDataIn = 256'h1111111111111111_2222222222222222_3333333333333333_4444444444444444;
        memWriteM = 1;
        memSrcM = 1;  // Operación vectorial
        #20;
        $display("writeData (parte 1): %h, byteena (parte 1): %h", writeData, byteena);
        // Verificación de los datos para las dos partes
        assert(writeData == 256'h0000000000000000_0000000000000000_1111111111111111_2222222222222222) 
        else $fatal("Test 4 parte 1 fallo");
        assert(byteena == 32'h0000ffff) 
        else $fatal("Test 4 parte 1 byteena fallo");
        #20;
        $display("writeData (parte 2): %h, byteena (parte 2): %h", writeData, byteena);
        assert(writeData == 256'h3333333333333333_4444444444444444_0000000000000000_0000000000000000) 
        else $fatal("Test 4 parte 2 fallo");
        assert(byteena == 32'hffff0000) 
        else $fatal("Test 4 parte 2 byteena fallo");
        memWriteM = 0;

        // ------------- Test 5: Lectura escalar alineada --------------
        $display("Test 5: Lectura escalar alineada en direccion 0x00000000");
        address = 32'h00000000;  // Alineado
        memtoRegM = 1;
        memSrcM = 0;  // Operación escalar
        readData = 256'h0000000000000000000000000000000000000000000000000000000000001234;
        #20;
        $display("scalarDataOut: %h", scalarDataOut);
        assert(scalarDataOut == 32'h1234) 
        else $fatal("Test 5 fallo");
        memtoRegM = 0;

        // ------------- Test 6: Lectura escalar no alineada --------------
        $display("Test 6: Lectura escalar no alineada en direccion 0x00000010");
        address = 32'h00000010;  // No alineado
        memtoRegM = 1;
        readData = 256'h00000000000000000000000000005678_00000000000000000000000000000000;
        #20;
        $display("scalarDataOut: %h", scalarDataOut);
        assert(scalarDataOut == 32'h5678) 
        else $fatal("Test 6 fallo");
        memtoRegM = 0;

        // ------------- Test 7: Lectura vectorial alineada --------------
        $display("Test 7: Lectura vectorial alineada en direccion 0x00000000");
        address = 32'h00000000;  // Alineado
        memtoRegM = 1;
        memSrcM = 1;  // Operación vectorial
        readData = 256'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB_CCCCCCCCCCCCCCCC_DDDDDDDDDDDDDDDD;
        #20;
        $display("vectorDataOut: %h", vectorDataOut);
        assert(vectorDataOut == 256'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB_CCCCCCCCCCCCCCCC_DDDDDDDDDDDDDDDD) 
        else $fatal("Test 7 fallo");
        memtoRegM = 0;

        // ------------- Test 8: Lectura vectorial no alineada --------------
        $display("Test 8: Lectura vectorial no alineada en direccion 0x00000010");
        address = 32'h00000010;  // No alineado
        memtoRegM = 1;
        readData = 256'h0000000000000000_1111111111111111_2222222222222222_3333333333333333;
        #20;
        $display("vectorDataOut: %h", vectorDataOut);
        // Verificación de la combinación de las partes
        assert(vectorDataOut == 256'h2222222222222222_3333333333333333_0000000000000000_1111111111111111) 
        else $fatal("Test 8 fallo");
        memtoRegM = 0;

        // Finalización
        $display("Tests completados con exito.");
        #100;
        $finish;
    end

endmodule
