/***
*	Aidan Lee, Aarin Wen
*	10/18/2024
*	EE371
*	Lab 2
*
*	A general all-purpose module that shortens a high input
*	into one clock cycle. Used for user input button presses
*	not inputting a billion times when you hold the button
*
*	takes in button	for the extended input to shorten
*	takes in reset		for resets
*	takes in clk		for clock timing
*
*	outputs out			for the single cycle signal output
*
***/

module buttonCheck(clk, reset, button, out);
   input logic clk, reset, button;
   output logic out;

   enum { idle, pressed, held } currState, nextState; 
   logic pulse; 

   always_comb begin
		case (currState)
			idle:
				if (button)
					nextState = pressed;
				else
					nextState = idle;
			pressed:
				if (button)
					nextState = held;
				else 
					nextState = idle;
			held:
				if (button)
					nextState = held;
				else
					nextState = idle;
		endcase
	end

   always_ff @(posedge clk) begin
      if (reset)
			currState <= idle;
		else
			currState <= nextState;
		  
		if (currState == pressed)
			pulse <= 1;
      else
         pulse <= 0;
   end

   assign out = pulse;

endmodule

module buttonCheck_tb();
	
	logic clk, reset, button;
   logic out;
	
	// Clock logic
	parameter CLOCK_PERIOD = 5; // Increase clock frequency
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	buttonCheck dut (.*);
	
	initial begin
		// initial reset
		reset <= 1; @(posedge clk);
						@(posedge clk);
		reset <= 0; @(posedge clk);
						@(posedge clk);
						
		// check singular button
		button <= 1; @(posedge clk);
		button <= 0; @(posedge clk);
		
		// check massive hold
		button <= 1; @(posedge clk);
						 @(posedge clk);
						 @(posedge clk);
						 @(posedge clk);
						 @(posedge clk);
						 @(posedge clk);
		button <= 0; @(posedge clk);
		
		$stop;
	end
endmodule