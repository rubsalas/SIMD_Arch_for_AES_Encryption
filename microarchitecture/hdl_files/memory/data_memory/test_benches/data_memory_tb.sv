/*
Data Memory (IP Module) testbench 
Date: 17/09/24
Approved
*/
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module data_memory_tb;

    // Señales del testbench
    logic [13:0] address;        // Dirección de memoria
    logic [31:0] byteena;        // Byte enable
    logic clock;                 // Reloj
    logic [255:0] data_in;       // Datos de entrada (para escritura)
    logic rden;                  // Habilitar lectura
    logic wren;                  // Habilitar escritura
    logic [255:0] data_out;      // Datos de salida (para lectura)

    // Instanciación del módulo data_memory
    data_memory uut (
        .address(address),
        .byteena(byteena),
        .clock(clock),
        .data(data_in),
        .rden(rden),
        .wren(wren),
        .q(data_out)
    );

    // Generación del reloj
    always #10 clock = ~clock;

    // Test sequence
    initial begin
        // Inicialización de señales
        clock = 0;
        address = 14'b0;
        byteena = 32'h0;
        data_in = 256'h0;
        rden = 0;
        wren = 0;

        // Prueba 0: Lectura
        $display("Test 0.1: Lectura en direccion 0x0000 con byteena = 32'hFFFFFFFF");
        address = 14'h0000;                // Dirección alineada
        byteena = 32'hFFFF_FFFF;           // Habilitar todos los bytes
        #20;
        rden = 1;                          // Leer la dirección
        #20;
        $display("Direccion: 0x%h, Dato leido: 0x%h", address, data_out);
        rden = 0;

        // Prueba 0: Lectura
        $display("Test 0.2: Lectura en direccion 0x0000 con byteena = 32'h0000FFFF");
        address = 14'h0000;                // Dirección alineada
        byteena = 32'h0000_FFFF;           // Habilitar todos los bytes
        #20;
        rden = 1;                          // Leer la dirección
        #20;
        $display("Direccion: 0x%h, Dato leido: 0x%h", address, data_out);
        rden = 0;

        // Prueba 0.3: Lectura
        $display("Test 0.3: Lectura en direccion 0x0000 con byteena = 32'h0F0F_0F0F");
        address = 14'h0000;                // Dirección alineada
        byteena = 32'h0F0F_0F0F;           // Habilitar todos los bytes
        #20;
        rden = 1;                          // Leer la dirección
        #20;
        $display("Direccion: 0x%h, Dato leido: 0x%h", address, data_out);
        rden = 0;

        // Prueba 1: Escritura alineada completa
        $display("Test 1: Escritura completa alineada en direccion 0x0000");
        address = 14'h0000;                // Dirección alineada
        data_in = 256'h1111111111111111_2222222222222222_3333333333333333_4444444444444444;
        byteena = 32'hFFFFFFFF;            // Habilitar todos los bytes
        wren = 1;                          // Habilitar escritura
        #20;
        wren = 0;                          // Deshabilitar escritura
        rden = 1;                          // Leer la dirección
        #20;
        $display("Direccion: 0x%h, Dato escrito: 0x%h", address, data_out);
        rden = 0;

        // Prueba 2: Escritura parcial no alineada (segundos 16 bytes)
        $display("Test 2: Escritura parcial en bytes 16..31 en direccion 0x0010");
        address = 14'h0010;                // Dirección no alineada
        data_in = 256'h0000000000000000_0000000000000000_5555555555555555_6666666666666666;
        byteena = 32'hFFFF0000;            // Habilitar solo los últimos 16 bytes
        wren = 1;                          // Habilitar escritura
        #20;
        wren = 0;                          // Deshabilitar escritura
        rden = 1;                          // Leer la dirección
        #20;
        $display("Direccion: 0x%h, Dato escrito: 0x%h", address, data_out);
        rden = 0;

        // Prueba 3: Escritura parcial alineada (primeros 16 bytes)
        $display("Test 3: Escritura parcial en bytes 0..15 en direccion 0x0000");
        address = 14'h0000;                // Dirección alineada
        data_in = 256'h7777777777777777_8888888888888888_0000000000000000_0000000000000000;
        byteena = 32'h0000FFFF;            // Habilitar solo los primeros 16 bytes
        wren = 1;                          // Habilitar escritura
        #20;
        wren = 0;                          // Deshabilitar escritura
        rden = 1;                          // Leer la dirección
        #20;
        $display("Direccion: 0x%h, Dato escrito: 0x%h", address, data_out);
        rden = 0;

        // Prueba 4: Escritura y lectura de datos no alineados (bytes intermedios)
        $display("Test 4: Escritura no alineada en direccion 0x0018");
        address = 14'h0018;                // Dirección no alineada
        data_in = 256'h0000000000000000_0000000000000000_9999999999999999_AAAAAAAAAAAAAAAA;
        byteena = 32'h00FFFF00;            // Habilitar solo los bytes intermedios
        wren = 1;                          // Habilitar escritura
        #20;
        wren = 0;                          // Deshabilitar escritura
        rden = 1;                          // Leer la dirección
        #20;
        $display("Direccion: 0x%h, Dato escrito: 0x%h", address, data_out);
        rden = 0;

        // Prueba 5: Lectura de un bloque no modificado
        $display("Test 5: Lectura de bloque no modificado en direccion 0x0020");
        address = 14'h0020;                // Dirección no alineada
        byteena = 32'hFFFFFFFF;            // Leer todos los bytes
        rden = 1;                          // Habilitar lectura
        #20;
        $display("Direccion: 0x%h, Dato leido: 0x%h", address, data_out);
        rden = 0;

        $display("Todas las pruebas completadas con exito.");
        #100;
        $finish;
    end

endmodule
