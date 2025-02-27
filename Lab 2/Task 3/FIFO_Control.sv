`timescale 1 ps / 1 ps

// Aidan Lee, Aarin Wen
// 10/18/2024
// EE 371
// Lab 2

// FIFO control module with parameterized depth
// utilizes clock and reset signals
// input write to write data, input read to read data
// output wr_en indicates when writing is enabled
// outputs empty and full flags indicate FIFO status of empty or full
// output readAddr and writeAddr represent read and write address pointers

module FIFO_Control #(
							 parameter depth = 4
							 )(
								input logic clk, reset,
								input logic read, write,
							  output logic wr_en,
							  output logic empty, full,
							  output logic [depth-1:0] readAddr, writeAddr
							  );
	
	
	/* 	Define_Variables_Here		*/
	logic almost_empty, almost_full;
	
	// Empty, Neither, Full
	enum {E, N, F} ps, ns; 
	
	
	/*		Combinational_Logic_Here	*/
	// almost_empty if readAddr is directly before writeAddr including looping
	assign almost_empty 	=  ((readAddr == ((2**depth) - 1)) 	&& (writeAddr == 0)) |
								   (readAddr == (writeAddr-1));
	
	// almost_full if writeAddr is directly before readAddr including looping
	assign almost_full 	=  ((writeAddr == ((2**depth) - 1)) && (readAddr == 0)) |
								   (writeAddr == (writeAddr-1));
									
	// Enable write if given write signal and not full	
	assign wr_en = write && ~full; 
									
	/*		Sequential_Logic_Here		*/	
	// State logic of FIFO Empty, Neutral, and Full 
	// utilizing inputs write, read, almost_full, and almost_empty, 
	// pretty straight forward and readable logic
	always_comb begin
		case (ps)
			E: if (write && ~read) ns = N;
				else ns = E;
	
			N: if (write && ~read && almost_full) ns = F;
				else if (~write && read && almost_empty) ns = E;
				else ns = N;
				
			F: if (read && ~write) ns = N;
				else ns = F;
		endcase
	end
	
	// synchronous logic
	always_ff @(posedge clk) begin
		// reset data
		if(reset) begin
			 readAddr <= '0;
			writeAddr <= '0;
				 empty <= 1'b1;
				  full <= 1'b0;
				  ps 	 <= E;
		end else begin
			// update to next state
			ps <= ns;
			
			// update flags based on state
			empty <= (ps == E);
			full <= (ps == F);
			
			// increment addresses including looping
			if (write && !full) writeAddr <= (writeAddr+1)%(2**depth);
			if (read && !empty) readAddr <= (readAddr+1)%(2**depth);
		end
	end

endmodule 