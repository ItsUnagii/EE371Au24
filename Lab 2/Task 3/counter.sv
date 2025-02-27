// This module creates a counter that increments from 00000 to 11111 (31). Upon
// reaching 31 the counter will loop back to 0. The counter itself is based upon
// the clock cycle input, however in here it can be slowed down using a clock divider
// to a configurable frequency. Takes in a clock signal, reset, and outputs the
// incrementing address.
module counter (clock, reset, addr);
	
	input logic clock, reset;
	output logic [4:0] addr;
	logic [4:0] address;

	logic [31:0] clk;
	logic SLOW_CLOCK;

	// Clock divider module. Adjust as needed.
	/* divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... 
  	[23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ... */
	clock_divider divclock (.clock(clock), .divided_clocks(clk));
	// Set to 24 for about 1.5 increments per second
	assign SLOW_CLOCK = clk[2];

	logic chosenClock;

	// To ensure that reset functionality behavior occurs as expected, tie the reset signal to the faster clock
	// so that the user doesn't have to hold down reset for a long time if the clock is slow.
	always_comb begin
		if (reset)
			chosenClock = clock;
		else
			chosenClock = SLOW_CLOCK;
	end
	
	// Default value during reset is 0.
	// Increment the counter if it is not 11111. If it is, reset back to 0.
	always_ff @(posedge chosenClock)
		if (reset)
			address <= 0;
			
		else if (address == 5'b11111) 
			address <= 0;
			
		else
			address <= address + 1;
	
	// Assign this address value to the output
	assign addr = address;
	
endmodule
