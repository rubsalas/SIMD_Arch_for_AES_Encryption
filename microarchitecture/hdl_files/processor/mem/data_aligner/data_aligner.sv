/*
Data aligner module 
Date: 17/09/2024
Test bench ran: 19/09/24
*/
module data_aligner # (parameter N = 32, parameter V = 256) (
	input  logic clk, reset,
	input  logic memtoRegM, // CS para hacer Lectura desde Memoria, sirve para Escalar y Vectorial
	input  logic memWriteM, // CS para hacer Escritura en la Memoria
	input  logic memSrcM,   // CS para operaciones escalares (32) [0] o vectoriales (256) [1]
	
	input  logic [31:0] address,	   // {Ai} Direccion de donde se leera o donde se escribira
	input  logic [15:0] scalarDataIn,  // {WD} Datos de 16 (!) bits para operaciones escalares
	input  logic [255:0] vectorDataIn, // {VWD} Datos de 256 bits para operaciones vectoriales

	output logic busy, // Indica si se esta procesando una operación (genera stalls en hazard unit)

	output logic [31:0] scalarDataOut,  // {RDo} Datos escaclares (32 bits) leidos de memoria
	output logic [255:0] vectorDataOut, // {VRD} Datos vectoriales (256 bits) leidos de memoria
	
	// ip_ram signals
	input  logic [255:0] readData,	// {RDi} Datos leidos desde la memoria de 256 bits

	output logic rden,				// Indica si se quiere leer de la memoria
	output logic wren,				// Indica si se quiere escribir en la memoria 
	output logic [13:0] ip_address, // {Ao} Direccion de memoria alineada a los 256 bits 
	output logic [31:0] byteena,	// Habilita los bytes especificos en la memoria
	output logic [255:0] writeData  // {WD} Datos de 256 bits por escribir en la memoria
);
	
	logic [1:0] count;
	logic ready;
	logic aligned;
	logic [N-1:0] shamt; 	 // Cantidad de bytes que se deben desplazar para alinear
	logic [N-1:0] prev_shamt;

	logic [V-1:0] wr_data_part1, wr_data_part2, 
				  rd_data_part1, rd_data_part2,
				  rd_data_scalar;

	/* Se calcula en funcion de los bits menos significativos del address */
	/* Verifica si los 5 bits menos significativos de la dirección son 0 */
	assign shamt = {27'd0, address[4:0]};
	/* Bit para saber si se encuentra alineado a 256 bits */
	assign aligned = (shamt == 0); /* 1 -> alineado | 0 -> no alineado */
	
	/* Se obtiene una direccion alineada de address[18:5] */
	/*
		if (count > 0) begin
			ip_address = address[18:5] + 14'd1;  // Siguiente bloque de 256 bits
		end else begin
			ip_address = address[18:5];  // Bloque actual de 256 bits
		end
	*/
	/* 
	 * Este operador condicional selecciona la dirección de la memoria 
	 * en función del valor de count, lo que permite leer o escribir en
	 * bloques de 256 bits de manera continua o dividida en dos ciclos,
	 * si es necesario. 
	 */
	assign ip_address = (count) ? address[18:5] + 14'd1 : address[18:5];	// align to 256 bits

	/*
	 * A veces los datos vectoriales que se quieren escribir no están alineados con los
	 * límites de 256 bits.
	 * Si la dirección de inicio está en la posición 16 de un bloque de 256 bits,
	 * esto significa que parte de los datos (los primeros 16 bytes, o 128 bits) caerán en el
	 * bloque actual de 256 bits. El resto de los datos (los otros 128 bits) deben escribirse
	 * en el siguiente bloque de 256 bits en la memoria.
	 */
	/*
	 * Este desplazamiento asegura que los primeros bytes del vector se alineen correctamente
	 * dentro del bloque actual de 256 bits.
	 */
	assign wr_data_part1 = vectorDataIn << shamt*8;
	/*
	 * Se desplaza el vector de entrada hacia la derecha por la cantidad restante (256 - shamt*8)
	 * para alinear el resto del vector dentro del siguiente bloque de 256 bits.
	 */
	assign wr_data_part2 = vectorDataIn >> 256 - shamt*8;

	/* Activa la escritura en memoria */
	assign wren = memWriteM;

	/* Los datos leídos se desplazan hacia la izquierda para alinear el bloque superior de 256 bits */
	assign rd_data_part2 = readData << 256 - prev_shamt*8;
	/*  */
	assign rd_data_scalar = readData >> prev_shamt*8; 

	/* Habilita la lectura */
	assign rden = memtoRegM;


	always_ff @ (posedge clk) 
	begin
		if (reset) begin
			count <= 2'b0;
		end
		else 
		begin
			/*
			 * El contador count ayuda a controlar cuándo una operación de lectura o escritura debe continuar
			 * en un ciclo adicional (para manejar datos no alineados). Este contador se incrementa mientras
			 * la operación no esté lista.
			 */
			count <= (~ready) ? count + 2'b1 : 2'b0;
			prev_shamt = shamt;

			/* Datos leidos se desplazan a la derecha para ajustar la alineacion siempre */
			rd_data_part1 <= readData >> prev_shamt*8;
		end
		
	end

	/* Write logic */
	always_comb 
	begin
		/*
		 * Datos no alineados:
		 * Si la operación es vectorial y los datos no están alineados, la lógica decide si escribir wr_data_part1
		 * o wr_data_part2, y ajusta los bits de byteena para indicar qué bytes se están escribiendo.
		 */
		if (memSrcM && ~aligned) 
		begin
			writeData = (count) ? wr_data_part2 : wr_data_part1;
			byteena = (count) ? 32'hFFFF_FFFF >> 32-shamt : 32'hFFFF_FFFF << shamt;
		end
		/*
		 * Datos alineados:
		 * Si los datos están alineados, se escribe directamente vectorDataIn con byteena activando cada uno de los bytes.
		 */
		else if (memSrcM && aligned)
		begin
			writeData = vectorDataIn;
			byteena = 32'hFFFF_FFFF;
		end
		else
		/*
		 * Escritura escalar:
		 * Si la operación es escalar, los 16 bits de scalarDataIn se empaquetan dentro de 256 bits
		 * y se alinean adecuadamente para la escritura.
		 */
		begin
			writeData = { 240'd0, scalarDataIn } << shamt*8;
			byteena = 32'd3 << shamt;
		end
	end

	// Read logic
	always_comb 
	begin
		/*
		 * Datos no alineados:
		 * Cuando los datos no están alineados, las partes leídas se combinan (rd_data_part1 y rd_data_part2)
		 * para formar un bloque coherente de 256 bits.
		 */
		if (memSrcM && ~aligned) 
		begin
			scalarDataOut = 32'd0;
			vectorDataOut = rd_data_part2 | rd_data_part1;
		end
		/*
		 * Datos alineados:
		 * Los datos alineados se leen directamente.
		 */
		else if (memSrcM && aligned)
		begin
			scalarDataOut = 32'd0;
			vectorDataOut = readData;
		end
		/*
		 * Lectura escalar:
		 * En una operación escalar, se extrae una palabra de 32 bits de rd_data_scalar.
		 */
		else
		begin
			scalarDataOut = rd_data_scalar[31:0];
			vectorDataOut = 256'd0;
		end
	end

	// busy, ready and count logic
	always_comb
	begin
		/*
		 *
		 */
		if (memWriteM)
		begin
			if (memSrcM)
				ready = (~aligned && count > 0) || aligned;
			else
				ready = 1'b1;
		end
		/*
		 *
		 */
		else if (memtoRegM)
		begin
			if (memSrcM && ~aligned) 
				ready = (count > 1);
			else
				ready = (count > 0);
		end
		/*
		 *
		 */
		else 
			ready = 1'b1;
	end

	assign busy = ~ready;
	
endmodule
