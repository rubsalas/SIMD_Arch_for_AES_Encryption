/*
Top module para el encriptador AES
Date: 25/09/24
*/
module AES_encryptor # (parameter N = 32, parameter V = 256, parameter R = 5) (
		input  logic clk,
		input  logic rst,	// switch for reset
		input  logic pwr,	// switch to power up
		input  logic dbg,	// switch to set debug mode
		input  logic stp,	// button for stepping while debug mode is on

		output logic out
	);

	timeunit 1ps;
    timeprecision 1ps;


	/* wires */
	logic enable;
	logic eclk;
	// from processor
	logic [N-1:0] PCF;				// [y] from processor to memory [y]
	logic RdenData;					// [y] from processor to memory [y]
	logic WrenData;					// [y] from processor to memory [y]
	logic [13:0] AddressData;		// [y] from processor to memory [y]
	logic [31:0] ByteenaData;		// [y] from processor to memory [y]
	logic [V-1:0] WriteData;		// [y] from processor to memory [y]

	// from memory
	logic [N-1:0] instruction;		// [y] from memory to processor [y]
	logic [V-1:0] ReadData;			// [n] from memory to processor [n]


	/* Inicio del Procesador al presionar un switch */
	always @ (negedge pwr) begin
		if (~pwr)
			enable = 1;
	end


	/* Inicio del clock al activar pwr */
	assign eclk = clk & enable;


	/* ASIP Processor */
	processor #(.N(N), .V(V), .R(R)) asip (
		.clk(eclk),
		.rst(rst),
		
		// Entrada de instrucción
		.Instr(instruction),            // RD desde la memoria de instrucciones
		// Entrada de datos leídos
		.ReadData(ReadData),           	// Datos leídos desde la memoria de datos

		// Salida de dir de instruccion
		.PC(PCF),                       // Dirección de la siguiente instrucción
		// Salida de dir datos o dato por escribir
		.RdenData(RdenData),           	// Señal de lectura de datos desde la memoria de datos
		.WrenData(WrenData),           	// Señal de escritura de datos hacia la memoria de datos
		.AddressData(AddressData),     	// Dirección de la memoria de datos
		.ByteenaData(ByteenaData),     	// Byte enable para la memoria de datos
		.WriteData(WriteData)          	// Datos de escritura hacia la memoria de datos
	);


	/* Data Memory */
	memory #(.N(N), .V(V)) data_memory (
		.clk(clk),

		// Entrada de instruccion
		.pc_address(PCF),        		// Dirección del PC hacia la memoria de instrucciones
		// Entradas de datos
		.rden_data(RdenData),          	// Señal de lectura de datos
		.wren_data(WrenData),          	// Señal de escritura de datos
		.address_data(AddressData),    	// Dirección de datos hacia la memoria de datos
		.byteena_data(ByteenaData),    	// Señal de byte enable desde el alineador de datos
		.write_data(WriteData),        	// Datos de escritura desde el alineador de datos

		// Salida de instruccion
		.instruction(instruction),      // Instrucción leída desde la memoria de instrucciones
		// Salida de datos
		.read_data(ReadData)           	// Datos leídos desde la memoria de datos
	);

	
	/* fpga output */
	assign out = pwr & stp & dbg;

endmodule
