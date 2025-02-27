// Aidan Lee, Aarin Wen
// 11/01/2024
// EE 371
// Lab 3
//
// Line drawer module intended for use with the VGA_framebuffer module given in lab.
//  
//
// utilizes clk input
//	input	 reset					resets the line drawer to start back at the initial coordinates and stops it from drawing
//										as long as the reset signal is high
// input  [9:0] x0, x1 			represents the x coordinates of the two endpoints of the line you want to draw
// input  [8:0] y0, y1			represents the y coordinates of the two endpoints of the line you want to draw
// output [9:0] x					represents the x pixel coordinate where the module should color in. Changes every two clock cycles		
// output [8:0] y					represents the y pixel coordinate where the module should color in. Changes every two clock cycles

module line_drawer(clk, reset, x0, y0, x1, y1, x, y);
	input logic clk, reset;
	
	// x and y coordinates for the start and end points of the line
	input logic [9:0] x0, x1; 
	input logic [8:0] y0, y1;
	
	// outputs cooresponding to the coordinate pair (x, y)
	output logic [9:0] x;
	output logic [8:0] y;
	
	// Bresenham Variables
	logic signed [11:0] error; 
	logic [9:0] delta_x;
	logic [8:0] delta_y;
	logic y_step;
	logic is_steep;
	// intermediate values for calculating delta of x and y
	logic signed [10:0] deltax_signed, abs_x;
	logic signed [9:0]  deltay_signed, abs_y;
	// x and y variables after flips and swaps
	logic [9:0] flip_x0, flip_x1, x0s, x1s;
	logic [8:0] flip_y0, flip_y1, y0s, y1s;
	
	
	// abs(x0-x1) and abs(y0-y1) for is_steep logic
	assign abs_x = (x0 > x1) ? (x0 - x1) : (x1 - x0);
	assign abs_y = (y0 > y1) ? (y0 - y1) : (y1 - y0);
	
	assign is_steep = (abs_y > abs_x) ? 1'b1 : 1'b0;
	
	// if steep, then swap x with y
	always_comb begin
		if (is_steep) begin
			flip_x0 = y0; flip_x1 = y1; flip_y0 = x0; flip_y1 = x1;
		end else begin
			flip_x0 = x0; flip_x1 = x1; flip_y0 = y0; flip_y1 = y1;
		end
	end
		
	// if x0 > x1, then swap x0 with x1 and y0 with y1
	always_comb begin
		if (flip_x0 > flip_x1) begin
			x0s = flip_x1; x1s = flip_x0; y0s = flip_y1; y1s = flip_y0;
		end
		else begin
			x0s = flip_x0; x1s = flip_x1; y0s = flip_y0; y1s = flip_y1;
		end
	end 
	
	

	// if y0 < y1, then y_step = 1 else y_step = − 1
	// determine which direction y_step should go in
	assign y_step = (y0s < y1s) ? 1'b1 : 1'b0;
	
	// find delta x and y (from bresenham's)
	// int delta_x = x1 − x0
	//	int delta_y = abs(y1 − y0)
	assign deltax_signed = is_steep ? (y1s - y0s) : (x1s - x0s);
	assign deltay_signed = is_steep ? (x1s - x0s) : (y1s - y0s);

	assign delta_y = (deltay_signed < 0) ? (-deltay_signed) : (deltay_signed);
	assign delta_x = (deltax_signed < 0) ? (-deltax_signed) : (deltax_signed);

	// 5 states to emulate c for loop
	enum logic [2:0] {s0, s1, s2, s3, s4} ps, ns;

	// comb logic for determining the next state to implement the bresenham for loop
	always_comb begin
		case (ps)
			// state 0: initial reset state, go immediately to initial point
			s0: ns = s1;
			// state 1: give 1 clock cycle for the first point to be drawn
			s1: ns = s2;
			// state 2: update error state: decide if finished or if should continue algo
			s2: begin
				if (is_steep) begin
					if (y < x1s) 
						ns = s3;
					else
						ns = s4;
				end else begin
					if (x < x1s)
						ns = s3;
					else
						ns = s4;
				end	
			end
			// state 3: update x and y values on this state; return back s2 to update the error
			s3: ns = s2;
			// state 4: finished case. dont move
			s4: ns = s4;

		endcase

	end

	// control states ff
	always_ff @(posedge clk) begin
		if (reset)
			ps <= s0;
		else
			ps <= ns;
	end
	
	
	// ff to control bresenham algorithm
	always_ff @(posedge clk) begin
		if (reset) begin
			x <= x0;
			y <= y0;
			error <= 'b0;
		end
		
		else if (ps == s1) begin
			// initial assignments for values.
			// draw first pixel
			if (is_steep) begin
				x <= y0s; y <= x0s;
			end
			else begin
				x <= x0s; y <= y0s;
			end

			error <= is_steep ? (-(delta_y)/2) : (-(delta_x/2));
		end
		
		else if (ps == s2) begin
			// Update error value in preparation for next y calculation
			error <= is_steep ? (error + delta_x) : (error + delta_y);
		end
		
		else if (ps == s3) begin
			// increment x or y (based on flip). Assign y its updated value
			if (is_steep)
				y <= y + 1'b1;
			else
				x <= x + 1'b1;
			
			// determine what direction y_step is in
			if (error > 0) begin
				if (is_steep) begin
					x <= y_step ? (x + 1'b1) : (x - 1'b1);
				end
				else begin
					y <= y_step ? (y + 1'b1) : (y - 1'b1);
				end

				error <= is_steep ? (error - delta_y) : (error - delta_x);
			end
		end
		// stop running logic at s4
	end 
endmodule

module line_drawer_tb();
	
   logic clk, reset;
	
	logic [9:0]	x0, x1; 
	logic [8:0] y0, y1;

	logic [9:0] x;
	logic [8:0] y;

   // Clock logic
   parameter CLOCK_PERIOD = 10; // Increase clock frequency
   initial begin
       clk <= 0;
       forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
   end

   line_drawer dut (.*);

   initial begin
		// initial reset state
		reset <= 1'b1; 
		x0 <= 10'b0; y0 <= 9'b0;
		x1 <= 10'b0; y1 <= 9'b0;
		repeat (5) @(posedge clk);
		
		// horizontal line, forwards
		x0 <= 10'b0; y0 <= 9'b0;
		x1 <= 10'd5; y1 <= 9'b0;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (20) begin @(posedge clk); end
		
		// horizontal line, backwards
		x0 <= 10'd5; y0 <= 9'b0;
		x1 <= 10'b0; y1 <= 9'b0;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (20) begin @(posedge clk); end
		
		// vertical line, forwards
		x0 <= 10'b0; y0 <= 9'b0;
		x1 <= 10'b0; y1 <= 9'd5;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (20) begin @(posedge clk); end
		
		// vertical line, backwards
		x0 <= 10'b0; y0 <= 9'd5;
		x1 <= 10'b0; y1 <= 9'b0;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (20) begin @(posedge clk); end
		
		// slope = 1, forwards
		x0 <= 10'b0; y0 <= 9'b0;
		x1 <= 10'd5; y1 <= 9'd5;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (20) begin @(posedge clk); end
		
		// slope = 1, backwards
		x0 <= 10'd5; y0 <= 9'd5;
		x1 <= 10'b0; y1 <= 9'b0;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (20) begin @(posedge clk); end
		
		// slope = -1, forwards
		x0 <= 10'b0; y0 <= 9'd5;
		x1 <= 10'd5; y1 <= 9'b0;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (20) begin @(posedge clk); end
		
		// slope = -1, backwards
		x0 <= 10'd5; y0 <= 9'b0;
		x1 <= 10'b0; y1 <= 9'd5;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (20) begin @(posedge clk); end
		
		// slope = 2, forwards
		x0 <= 10'b0; y0 <= 9'b0;
		x1 <= 10'd5; y1 <= 9'd10;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (30) begin @(posedge clk); end
		
		// slope = 2, backwards
		x0 <= 10'd5; y0 <= 9'd10;
		x1 <= 10'b0; y1 <= 9'b0;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (30) begin @(posedge clk); end
		
		// slope = 1/2, forwards
		x0 <= 10'b0; y0 <= 9'b0;
		x1 <= 10'd10; y1 <= 9'd5;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (30) begin @(posedge clk); end
		
		// slope = 1/2, backwards
		x0 <= 10'd10; y0 <= 9'd5;
		x1 <= 10'b0; y1 <= 9'b0;
		
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; 
		repeat (30) begin @(posedge clk); end
		
		$stop;
	end
endmodule

