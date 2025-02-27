`timescale 1 ps / 1 ps

/***
*	Aidan Lee, Aarin Wen
*	10/18/2024
*	EE371
*	Lab 2
*
*	Top level module for Task 3, Lab 2
* 	A FIFO module that displays its contents using hex displays.
*
* 	takes in SW[7:0] for the data being written in
*	takes in KEY[3]  for writing in a value into the FIFO
*	takes in KEY[2]  for reading out a value from the FIFO
*	takes in KEY[0]  for resets
*	takes in CLOCK_50 for general clock timing
*
*	outputs LEDR[9] and LEDR[8] for visualizing full and empty
*	outputs HEX5 and HEX4 for displaying write value
*	outputs HEX1 and HEX0 for displaying the data that was read
*
***/

module Lab2Task3 (CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	input  logic CLOCK_50;
   input  logic [9:0] SW;
	input  logic [3:0] KEY;
	
	output logic [9:0] LEDR;    
   output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	// intermediate logic
   logic [7:0] dataIn;
   logic [7:0] dataOut;
   logic read, write;
	logic empty, full;
	logic reset;
	logic button;
	
	// assign controls to inputs
	assign dataIn = SW[7:0];
   assign reset = ~KEY[0];
	
	// shorten inputs of read and write
	buttonCheck shortenRead  (.clk(CLOCK_50), .reset(reset), .button(~KEY[3]), .out(read));
	buttonCheck shortenWrite (.clk(CLOCK_50), .reset(reset), .button(~KEY[2]), .out(write));
	
	// main fifo module
	FIFO #(3, 4) main (.clk(CLOCK_50), .reset(reset), .read(read), .write(write), 
							.inputBus(dataIn), .empty(empty), .full(full), .outputBus(dataOut));
	
	// logic for outputting the correct data to the hex display
	logic [7:0] hexOut;
	always_ff @(posedge CLOCK_50) begin
		if (reset)
			begin
				hexOut <= 0;
			end
		else if (read & ~empty)
			begin
				hexOut <= dataOut;
			end
		else
			begin
				hexOut <= hexOut;
			end
	end
	
	// calibrating hex and leds to display correct data
	seg7 hex5 ({{3'b0}, dataIn[7:4]}, HEX5);
   seg7 hex4 (dataIn[3:0], HEX4);
	
	seg7 hex1 ({{3'b0}, hexOut[7:4]}, HEX1);
	seg7 hex0 (hexOut[3:0], HEX0);
	
	assign LEDR[9] = full;
	assign LEDR[8] = empty;
	
	// unused values
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign LEDR[7:0] = 8'b0000000;

endmodule

module Lab2Task3_tb();
	
	logic CLOCK_50;
   logic [9:0] SW;
	logic [3:0] KEY;
	 
	logic [9:0] LEDR;    
   logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	logic clk;
	assign CLOCK_50 = clk;
	
	// Clock logic
	parameter CLOCK_PERIOD = 5; // Increase clock frequency
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	Lab2Task3 dut (.*);
	
	initial begin
		
		// reset everything
		KEY[0] <= 0; KEY[3] <= 1; KEY[2] <= 1; SW[7:0] <= 8'b0; @(posedge clk);
																				@(posedge clk);
		KEY[0] <= 1; @(posedge clk);
						@(posedge clk);
		
		// check reading before initializing anything returns nothing
		KEY[3] <= 0; @(posedge clk);
		KEY[3] <= 1; @(posedge clk);
		
		// write some number in
		KEY[2] <= 0; SW[7:0] <= 16'b1111; @(posedge clk);
		KEY[2] <= 1; @(posedge clk);
		
		@(posedge clk);
		
		// take that number out
		KEY[3] <= 0; @(posedge clk);
		KEY[3] <= 1; @(posedge clk);
		
		// reset
		KEY[0] <= 0; @(posedge clk);
						@(posedge clk);
		KEY[0] <= 1; @(posedge clk);
						@(posedge clk);
		
		// with an empty fifo, write a number of words over the maximum.
		// this implementation replaces the least recent entry when written while full
		for (int i = 0; i < 8; i++) begin
			SW[7:0] <= i; KEY[2] <= 0; @(posedge clk);
			KEY[2] <= 1;						@(posedge clk);
		end
			
		SW[7:0] <= 8'b1010; KEY[2] <= 0; @(posedge clk);
		KEY[2] <= 1;						@(posedge clk);
		
		// read and empty out the entire fifo
		KEY[2] <= 1; KEY[3] <= 0;
		for (int i = 0; i < 8; i++) begin
			SW[7:0] <= i; @(posedge clk);
		end
		
		// pull one more time to make sure it's empty
		@(posedge clk);
		KEY[3] <= 1; @(posedge clk);
		
		// add a value and reset to check if reset works
		KEY[2] <= 0; SW[7:0] <= 16'b1111; @(posedge clk);
		KEY[2] <= 1; @(posedge clk);
		KEY[0] <= 0; @(posedge clk);
						@(posedge clk);
		KEY[0] <= 0; @(posedge clk);
						@(posedge clk);
		
		$stop;
	end
endmodule