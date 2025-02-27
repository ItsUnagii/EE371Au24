//Aidan Lee, Aarin Wen
// 11/13/2024
// EE 371
// Lab 4

// Top level module to simulate bitCounter on the DE1_SoC board

// inputs:
// CLOCK_50 						-> clk 	(clock signal 	for bitCounter)
// SW[7:0] 							-> A 		(input data 	for bitCounter)
// ~KEY[0] (pressing KEY[0]) 	-> reset (reset signal 	for bitCounter)

// outputs:
// LEDR[9] 	<- done 		(bitCounter status signal; counting complete)
// HEX[0] 	<- results 	(bitCounter output; total 1's count of input A)

module DE1_SoC_task1 (
input logic [3:0] KEY,
input logic [9:0] SW,
input logic CLOCK_50,
output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
output logic [9:0] LEDR);

	// turn off unused HEX displays
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	// logic variable to store result
	logic [3:0] result;

	// parameters, 8-bit wide A, 4 bits to store results
	parameter A_WIDTH = 8;
	parameter RES_WIDTH = 4;
	
	// bitCounter instantiated with... 
	// parameters #(A_WIDTH, RES_WIDTH)
	// clk		<- CLOCK_50
	// A			<- SW[7:0]
	// reset		<- ~KEY[0] (pressing KEY[0])
	// done		-> LEDR[9]
	// result 	-> result (will display on HEX0 using seg7.sv)
	bitCounter #(A_WIDTH, RES_WIDTH) bitCounter_
	(.reset(~KEY[0]), .clk(CLOCK_50), .s(SW[9]), .A(SW[7:0]), .done(LEDR[9]), .result);

	// display result on 7-segment display HEX0
	// seg7 instantiated with results as input, HEX0 as output
	seg7 HEX0_result (.bcd(result), .leds(HEX0));
endmodule

// DE1_SoC_task1.sv testbench; runs same test cases as bitCounter.sv
// tests reset and s cases as well as A <= 8'b10101010, 8'b10000001, and 8'b0;
module DE1_SoC_task1_tb ();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic CLOCK_50;
	
	// instantiate DE1_SoC_task1 dut
	DE1_SoC_task1 dut (.*);
	
	// assign DE1_SoC variables to bitCounter counterparts
	logic clk, s, reset;
	logic [7:0] A;
	assign CLOCK_50 = clk;
	assign SW[7:0] = A;
	assign SW[9] = s;
	assign KEY[0] = ~reset;
	
	// initialize clock simulation
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// begin tests
	integer i; // int i for loops
	// begin tests
	initial begin
		// initialize values
		reset <= 1; s <= 0; A <= 8'b0; @(posedge clk);
		
		// release reset
		reset <= 0; @(posedge clk);
		
		// test if bit-count analysis begins without start signal (SHOULD NOT)
		// results & done should remain at 0
		A <= 8'b10101010; repeat (14) @(posedge clk);
		A <= 8'b00000000; @(posedge clk);
		
		// loop that uses bitCounter on bits 8'b00000001 to 8'b11111111 by incrementing
		// results should settle to how many 1's are in the 8b input; expect 1->8
		// done should have value '1' whenever results are settled
		// note: 8b'0 will be checked in next loop
		for (i = 0; i < 8; i = i + 1) begin
			// turn start signal off before loading in new data
			s <= 0; @(posedge clk);
				 
			// load in new A value
			A <= (8'b00000001 << i) | A; @(posedge clk);

			// count 1's and let 'result' and 'done' settle
			s <= 1; repeat (14) @(posedge clk);
		end
	
		// loop that uses left shifting to bit-count 8'b11111111 to 8'b0
		// results should settle to how many 1's are in the 8b input; expect 8->0
		// done should have value '1' whenever results are settled
		for (i = 8; i >= 0; i = i - 1) begin
			// turn start signal off before loading in new data
			s <= 0; @(posedge clk);
			
			// load in new A value
			A <= 8'b11111111 << (8-i); @(posedge clk);
			
			// count 1's and let 'result' and 'done' settle
			s <= 1; repeat (14) @(posedge clk);
		end
		$stop;	
		
	end
endmodule	