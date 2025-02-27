`timescale 1 ps / 1 ps

/***
*	Aidan Lee, Aarin Wen
*	10/18/2024
*	EE371
*	Lab 2
*
*	All purpose counter that increments from 00000 to 11111 (31) and loops
* 	Can be configured to have a different counting speed by changing
*	the clock divider
*
* 	Only takes in a clock signal and reset
*	Outputs an incrementing address
*
***/

module counter (clock, reset, addr);
	
	input logic clock, reset;
	output logic [4:0] addr;
	logic [4:0] address;

	logic [31:0] clk;
	logic SLOW_CLOCK;

	// clock divider
	/* divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... 
  	[23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ... */
	clock_divider divclock (.clock(clock), .divided_clocks(clk));
	// 24 is about ~1.5 increments per second
	assign SLOW_CLOCK = clk[2];
	// REMEMBER TO SET TO 2 OR 24 FOR MODELSIM OR DEMO RESPECTIVELY

	logic chosenClock;

	// set reset signal to faster clock so user doesn't have
	// to press reset weird for a long time if its running off of slow clock
	always_comb begin
		if (reset)
			chosenClock = clock;
		else
			chosenClock = SLOW_CLOCK;
	end
	
	// default value at reset is 0
	// increment the counter if not 11111 - else reset to 0
	always_ff @(posedge chosenClock)
		if (reset)
			address <= 0;
			
		else if (address == 5'b11111) 
			address <= 0;
			
		else
			address <= address + 5'b1;
	
	assign addr = address;
	
endmodule


module counter_tb();
	
   logic clock, reset;
   logic [4:0] addr;

   // Clock logic
   parameter CLOCK_PERIOD = 5; // Increase clock frequency
   initial begin
       clock <= 0;
       forever #(CLOCK_PERIOD/2) clock <= ~clock; // Forever toggle the clock
   end

   counter dut (.*);

   initial begin
	
		reset <= 1'b1; #20;
		reset <= 1'b0; #1000;
	
		$stop;
	end
endmodule
