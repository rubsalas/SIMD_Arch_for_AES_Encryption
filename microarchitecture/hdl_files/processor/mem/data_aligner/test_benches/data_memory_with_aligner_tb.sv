/*
Data Memory with Data Aligner testbench 
Date: 19/09/24
Approved
*/
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module data_memory_with_aligner_tb;

    // Señales
    logic clk;
    logic reset;
    logic MemtoRegM;
    logic MemWriteM;
    logic MemSrcM;
    logic [31:0] ALUResultM;
    logic [15:0] SWData; 
    logic [255:0] ALUResultVM;
    logic [255:0] MemReadData;
    
    logic Busy;
    logic [31:0] ReadDataM;
    logic [255:0] VRData;
    
    logic Rden;
    logic Wren;
    logic [13:0] MemAddress;
    logic [31:0] Byteena;
    logic [255:0] MemWriteData;
    
    // Instancia del módulo data_aligner
    data_aligner uut (
        .clk(clk),
        .reset(reset),
        .memtoRegM(MemtoRegM),
        .memWriteM(MemWriteM),
        .memSrcM(MemSrcM),
        .address(ALUResultM),
        .scalarDataIn(SWData),
        .vectorDataIn(ALUResultVM),
        .busy(Busy),
        .scalarDataOut(ReadDataM),
        .vectorDataOut(VRData),
        .readData(MemReadData),
        .rden(Rden),
        .wren(Wren),
        .ip_address(MemAddress),
        .byteena(Byteena),
        .writeData(MemWriteData)
    );

    // Instanciación del módulo data_memory
    data_memory ram (
        .address(MemAddress),   // Dirección de 14 bits
        .byteena(Byteena),      // Byte enable de 32 bits
        .clock(clk),            // Señal de reloj
        .data(MemWriteData),    // Datos de entrada de 256 bits
        .rden(Rden),            // Habilitar lectura
        .wren(Wren),            // Habilitar escritura
        .q(MemReadData)         // Datos de salida de 256 bits
    );

    // Generación del reloj
    always #10 clk = ~clk;

    // Test sequence
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        MemtoRegM = 0;
        MemWriteM = 0;
        MemSrcM = 0;
        ALUResultM = 32'b0;
        SWData = 16'b0;
        ALUResultVM = 256'b0;
        MemReadData = 256'b0;
        
        // Se desactiva el reset
        #20 reset = 0;
        #20;

        // ------------- Test 1: Lectura vectorial alineada --------------
        $display("\nTest 1: Lectura vectorial alineada en direccion 0x00000000");
        ALUResultM = 32'h00000000;  // Dirección alineada
        MemtoRegM = 1;
        MemSrcM = 1;  // Operación vectorial

        #20;
        // Data Aligner
        $display("MemtoRegM: %b, MemWriteM: %b, MemSrcM: %b", MemtoRegM, MemWriteM, MemSrcM);
        $display("ALUResultM (address): %h, SWData (scalarDataIn): %h", ALUResultM, SWData);
        $display("ALUResultVM (vectorDataIn): %h", ALUResultVM);
        $display("Busy: %b", Busy);
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        // Data Memory
        $display("MemWriteData (writeData): %h", MemWriteData);
        $display("Rden: %b, Wren: %b", Rden, Wren);
        $display("MemAddress (address): %h, Byteena: %b", MemAddress, Byteena);
        $display("MemReadData (readData): %h", MemReadData);
        /* Assert Test */
        assert(VRData == 256'hB1A8CAAEF6B7B15AF0A35825F0491A927DAA9514833D99D8ECFD3F11221B2569) 
        else $fatal("Test 1 fallo");
        MemtoRegM = 0;

        #20;

        // ------------- Test 2: Lectura vectorial no alineada --------------
        $display("\nTest 2: Lectura vectorial no alineada en direccion 0x00000001");
        ALUResultM = 32'h00000001;  // Dirección no alineada
        MemtoRegM = 1;
        MemSrcM = 1;  // Operación vectorial        

        // Verificacion que esta Busy trayendo la segunda parte del vector no alineado
        #20;
        $display("\nSHOULD BE BUSY");
        // Data Aligner
        $display("MemtoRegM: %b, MemWriteM: %b, MemSrcM: %b", MemtoRegM, MemWriteM, MemSrcM);
        $display("ALUResultM (address): %h, SWData (scalarDataIn): %h", ALUResultM, SWData);
        $display("ALUResultVM (vectorDataIn): %h", ALUResultVM);
        $display("Busy: %b", Busy);
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        // Data Memory
        $display("MemWriteData (writeData): %h", MemWriteData);
        $display("Rden: %b, Wren: %b", Rden, Wren);
        $display("MemAddress (address): %h, Byteena: %b", MemAddress, Byteena);
        $display("MemReadData (readData): %h", MemReadData);

        #20;
        $display("\nSHOULD BE READY");
        // Data Aligner
        $display("MemtoRegM: %b, MemWriteM: %b, MemSrcM: %b", MemtoRegM, MemWriteM, MemSrcM);
        $display("ALUResultM (address): %h, SWData (scalarDataIn): %h", ALUResultM, SWData);
        $display("ALUResultVM (vectorDataIn): %h", ALUResultVM);
        $display("Busy: %b", Busy);
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h [!]", ReadDataM, VRData);
        // Data Memory
        $display("MemWriteData (writeData): %h", MemWriteData);
        $display("Rden: %b, Wren: %b", Rden, Wren);
        $display("MemAddress (address): %h, Byteena: %b", MemAddress, Byteena);
        $display("MemReadData (readData): %h", MemReadData);
        /* Assert Test */
        assert(VRData == 256'hB4B1A8CAAEF6B7B15AF0A35825F0491A927DAA9514833D99D8ECFD3F11221B25) 
        else $fatal("Test 2 fallo");
        MemtoRegM = 0;

        #20;

        // ------------- Test 3: Lectura escalar alineada --------------
        $display("\nTest 3: Lectura escalar alineada en direccion 0x00000064");
        ALUResultM = 32'h00000040;  // Dirección alineada
        MemtoRegM = 1;
        MemSrcM = 0;  // Operación escalar
        #20;
        // Data Aligner
        $display("MemtoRegM: %b, MemWriteM: %b, MemSrcM: %b", MemtoRegM, MemWriteM, MemSrcM);
        $display("ALUResultM (address): %h, SWData (scalarDataIn): %h", ALUResultM, SWData);
        $display("ALUResultVM (vectorDataIn): %h", ALUResultVM);
        $display("Busy: %b", Busy);
        $display("ReadDataM (scalarDataOut): %h [!], VRData (vectorDataOut): %h", ReadDataM, VRData);
        // Data Memory
        $display("MemWriteData (writeData): %h", MemWriteData);
        $display("Rden: %b, Wren: %b", Rden, Wren);
        $display("MemAddress (address): %h, Byteena: %b", MemAddress, Byteena);
        $display("MemReadData (readData): %h", MemReadData);
        /* Assert Test */
        assert(ReadDataM == 32'h929EAF5E) 
        else $fatal("Test 3 fallo");
        MemtoRegM = 0;

        #20;

        // ------------- Test 4: Lectura escalar no alineada --------------
        $display("\nTest 4: Lectura escalar no alineada en direccion 0x00000010");
        ALUResultM = 32'h00000010;  // Dirección no alineada
        MemtoRegM = 1;
        MemSrcM = 0;  // Operación escalar
        #20;
        // Data Aligner
        $display("MemtoRegM: %b, MemWriteM: %b, MemSrcM: %b", MemtoRegM, MemWriteM, MemSrcM);
        $display("ALUResultM (address): %h, SWData (scalarDataIn): %h", ALUResultM, SWData);
        $display("ALUResultVM (vectorDataIn): %h", ALUResultVM);
        $display("Busy: %b", Busy);
        $display("ReadDataM (scalarDataOut): %h [!], VRData (vectorDataOut): %h", ReadDataM, VRData);
        // Data Memory
        $display("MemWriteData (writeData): %h", MemWriteData);
        $display("Rden: %b, Wren: %b", Rden, Wren);
        $display("MemAddress (address): %h, Byteena: %b", MemAddress, Byteena);
        $display("MemReadData (readData): %h", MemReadData);
        $display("ReadDataM: %h", ReadDataM);
        assert(ReadDataM == 32'hF0491A92) 
        else $fatal("Test 4 fallo");
        MemtoRegM = 0;

        #20;

        // ------------- Test 5: Escritura escalar alineada --------------
        $display("\nTest 5: Escritura escalar alineada en direccion 0x00000400");
        ALUResultM = 32'h00000400;  // Dirección 0x20 del .mif
        SWData = 16'hAAAA;
        MemWriteM = 1;
        MemSrcM = 0;  // Operación escalar
        #20;
        // Data Aligner
        MemtoRegM = 1; // For testing
        $display("MemtoRegM: %b, MemWriteM: %b, MemSrcM: %b", MemtoRegM, MemWriteM, MemSrcM);
        $display("ALUResultM (address): %h, SWData (scalarDataIn): %h", ALUResultM, SWData);
        $display("ALUResultVM (vectorDataIn): %h", ALUResultVM);
        $display("Busy: %b", Busy);
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        // Data Memory
        $display("MemWriteData (writeData): %h", MemWriteData);
        $display("Rden: %b, Wren: %b", Rden, Wren);
        $display("MemAddress (address): %h, Byteena: %b", MemAddress, Byteena);
        $display("MemReadData (readData): %h", MemReadData);
        /* Assert Test */
        assert(MemWriteData == 256'h000000000000000000000000000000000000000000000000000000000000AAAA) 
        else $fatal("Test 5 fallo");
        assert(Byteena == 32'h00000003) 
        else $fatal("Test 5 byteena fallo");
        MemWriteM = 0;
        MemtoRegM = 0;
        #20;
        // ------------- Test 5.1: Lectura vectorial alineada para revision --------------
        $display("\nTest 5.1: Lectura vectorial alineada en direccion 0x00000400 para revision");
        ALUResultM = 32'h00000400;  // Dirección alineada
        MemtoRegM = 1;
        MemSrcM = 1;  // Operación vectorial
        #20;
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        assert(VRData == 256'h000000000000000000000000000000000000000000000000000000000000AAAA) 
        else $fatal("Test 5 fallo escritura");
        MemtoRegM = 0;

        #20;

        // ------------- Test 6: Escritura escalar no alineada --------------
        $display("\nTest 6: Escritura escalar no alineada en direccion 0x000000402");
        ALUResultM = 32'h00000402;  // Dirección no alineada
        SWData = 16'hDEDE;
        MemWriteM = 1;
        MemSrcM = 0;  // Operación escalar
        #20;
        // Data Aligner
        MemtoRegM = 1; // For testing
        $display("MemtoRegM: %b, MemWriteM: %b, MemSrcM: %b", MemtoRegM, MemWriteM, MemSrcM);
        $display("ALUResultM (address): %h, SWData (scalarDataIn): %h", ALUResultM, SWData);
        $display("ALUResultVM (vectorDataIn): %h", ALUResultVM);
        $display("Busy: %b", Busy);
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        // Data Memory
        $display("MemWriteData (writeData): %h", MemWriteData);
        $display("Rden: %b, Wren: %b", Rden, Wren);
        $display("MemAddress (address): %h, Byteena: %b", MemAddress, Byteena);
        $display("MemReadData (readData): %h", MemReadData);
        $display("MemWriteData: %h, Byteena: %h, MemAddress: %h", MemWriteData, Byteena, MemAddress);
        /* Assert Test */
        assert(MemWriteData == 256'h00000000000000000000000000000000000000000000000000000000DEDE0000) 
        else $fatal("Test 6 fallo");
        assert(Byteena == 32'h0000000C) 
        else $fatal("Test 6 byteena fallo");
        MemWriteM = 0;
        MemtoRegM = 0;
        #20;
        // ------------- Test 6.1: Lectura vectorial alineada para revision --------------
        $display("\nTest 6.1: Lectura vectorial alineada en direccion 0x00000400 para revision");
        ALUResultM = 32'h00000400;  // Dirección alineada
        MemtoRegM = 1;
        MemSrcM = 1;  // Operación vectorial
        #20;
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        assert(VRData == 256'h00000000000000000000000000000000000000000000000000000000DEDEAAAA) 
        else $fatal("Test 6 fallo escritura");
        MemtoRegM = 0;

        #20;

        // ------------- Test 7: Escritura vectorial alineada --------------
        $display("\nTest 7: Escritura vectorial alineada en direccion 0x00000020");
        ALUResultM = 32'h00000020;  // Dirección alineada
        ALUResultVM = 256'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB_CCCCCCCCCCCCCCCC_DDDDDDDDDDDDDDDD;
        MemWriteM = 1;
        MemSrcM = 1;  // Operación vectorial
        #20;
        // Data Aligner
        MemtoRegM = 1; // For testing
        $display("MemtoRegM: %b, MemWriteM: %b, MemSrcM: %b", MemtoRegM, MemWriteM, MemSrcM);
        $display("ALUResultM (address): %h, SWData (scalarDataIn): %h", ALUResultM, SWData);
        $display("ALUResultVM (vectorDataIn): %h", ALUResultVM);
        $display("Busy: %b", Busy);
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        // Data Memory
        $display("MemWriteData (writeData): %h", MemWriteData);
        $display("Rden: %b, Wren: %b", Rden, Wren);
        $display("MemAddress (address): %h, Byteena: %b", MemAddress, Byteena);
        $display("MemReadData (readData): %h", MemReadData);
        $display("MemWriteData: %h, Byteena: %h, MemAddress: %h", MemWriteData, Byteena, MemAddress);
        /* Assert Test */
        assert(MemWriteData == 256'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB_CCCCCCCCCCCCCCCC_DDDDDDDDDDDDDDDD) 
        else $fatal("Test 7 fallo");
        assert(Byteena == 32'hFFFFFFFF) 
        else $fatal("Test 7 byteena fallo");
        MemWriteM = 0;
        MemtoRegM = 0;
        #20;
        // ------------- Test 7.1: Lectura vectorial alineada para revision --------------
        $display("\nTest 7.1: Lectura vectorial alineada en direccion 0x00000020 para revision");
        ALUResultM = 32'h00000020;  // Dirección alineada
        MemtoRegM = 1;
        MemSrcM = 1;  // Operación vectorial
        #20;
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        assert(VRData == 256'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB_CCCCCCCCCCCCCCCC_DDDDDDDDDDDDDDDD) 
        else $fatal("Test 7 fallo escritura");
        MemtoRegM = 0;

        #20;

        // ------------- Test 8: Escritura vectorial no alineada --------------
        $display("\nTest 8: Escritura vectorial no alineada en direccion 0x00000030");
        ALUResultM = 32'h00000070;  // Dirección no alineada
        ALUResultVM = 256'h1111111111111111_2222222222222222_3333333333333333_4444444444444444;
        MemWriteM = 1;
        MemSrcM = 1;  // Operación vectorial
        #20;
        // Verificacion que esta Busy escribiendo la segunda parte del vector no alineado
        $display("\nSHOULD BE BUSY");
        // Data Aligner
        $display("MemtoRegM: %b, MemWriteM: %b, MemSrcM: %b", MemtoRegM, MemWriteM, MemSrcM);
        $display("ALUResultM (address): %h, SWData (scalarDataIn): %h", ALUResultM, SWData);
        $display("ALUResultVM (vectorDataIn): %h", ALUResultVM);
        $display("Busy: %b", Busy);
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        // Data Memory
        $display("MemWriteData (writeData): %h", MemWriteData);
        $display("Rden: %b, Wren: %b", Rden, Wren);
        $display("MemAddress (address): %h, Byteena: %b", MemAddress, Byteena);
        $display("MemReadData (readData): %h", MemReadData);
        /* Assert Test */
        assert(MemWriteData == 256'h0000000000000000_0000000000000000_1111111111111111_2222222222222222) 
        else $fatal("Test 8 parte 1 fallo");
        assert(Byteena == 32'h0000FFFF) 
        else $fatal("Test 8 parte 1 byteena fallo");
        #20;
        // Deberia escribir la primera parte del vector no alineado y deja listo la escritura
        $display("\nSHOULD BE READY");
        // Data Aligner
        $display("MemtoRegM: %b, MemWriteM: %b, MemSrcM: %b", MemtoRegM, MemWriteM, MemSrcM);
        $display("ALUResultM (address): %h, SWData (scalarDataIn): %h", ALUResultM, SWData);
        $display("ALUResultVM (vectorDataIn): %h", ALUResultVM);
        $display("Busy: %b", Busy);
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h [!]", ReadDataM, VRData);
        // Data Memory
        $display("MemWriteData (writeData): %h", MemWriteData);
        $display("Rden: %b, Wren: %b", Rden, Wren);
        $display("MemAddress (address): %h, Byteena: %b", MemAddress, Byteena);
        $display("MemReadData (readData): %h", MemReadData);
        /* Assert Test */
        assert(MemWriteData == 256'h3333333333333333_4444444444444444_0000000000000000_0000000000000000) 
        else $fatal("Test 8 parte 2 fallo");
        assert(Byteena == 32'hFFFF0000) 
        else $fatal("Test 8 parte 2 byteena fallo");
        MemWriteM = 0;
        #20;
        // ------------- Test 8.1: Lectura vectorial alineada para revision --------------
        $display("\nTest 8.1: Lectura vectorial alineada en direccion 0x00000020 para revision");
        ALUResultM = 32'h00000060;  // Dirección alineada
        MemtoRegM = 1;
        MemSrcM = 1;  // Operación vectorial
        #20;
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        assert(VRData == 256'h3333333333333333_4444444444444444_404FC6056B1BD1DA721A055A7B69F816) 
        else $fatal("Test 8 fallo escritura en parte 1");
        MemtoRegM = 0;
        #20;
        // ------------- Test 8.1: Lectura vectorial alineada para revision --------------
        $display("\nTest 8.1: Lectura vectorial alineada en direccion 0x00000020 para revision");
        ALUResultM = 32'h00000080;  // Dirección alineada
        MemtoRegM = 1;
        MemSrcM = 1;  // Operación vectorial
        #20;
        $display("ReadDataM (scalarDataOut): %h, VRData (vectorDataOut): %h", ReadDataM, VRData);
        assert(VRData == 256'hD0D992D4B01F70B006E1CCC0C4DF1114_1111111111111111_2222222222222222) 
        else $fatal("Test 8 fallo escritura en parte 1");
        MemtoRegM = 0;

        #20;

        // Finalización
        $display("\nTests completados con exito.\n");
        #100;
        $finish;
    end

endmodule
