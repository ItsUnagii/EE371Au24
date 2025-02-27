`timescale 1 ps / 1 ps

/***
*	Aidan Lee, Aarin Wen
*	10/18/2024
*	EE371
*	Lab 2
*
*	Clock divider that creates a slower clock for the counter module.
*	Based on the selected clock, slows down incoming clock signal to
*	a specified frequency.
*
* 	Takes in a clock signal
*	Outputs a slowed clock divided_clocks
*
***/

/* divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... 
  [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ... */

module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks = 0;

	// Increment the divided clock by 1 to create a slower clock
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule 

module clock_divider_tb();
	
   logic clock;
   logic [31:0] divided_clocks;

   // Clock logic
   parameter CLOCK_PERIOD = 5; // Increase clock frequency
   initial begin
       clock <= 0;
       forever #(CLOCK_PERIOD/2) clock <= ~clock; // Forever toggle the clock
   end

   clock_divider dut (.*);

   initial begin
	
		#100
	
		$stop;
	end
endmodule
