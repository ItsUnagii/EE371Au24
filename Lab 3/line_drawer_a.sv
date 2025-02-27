//module line_drawer(
//    input logic clk, reset,
//    input logic [9:0] x0, x1,
//    input logic [8:0] y0, y1,
//    output logic [9:0] x,
//    output logic [8:0] y
//);
//
//    // Internal registers to store the current coordinates and parameters
//    logic [9:0] current_x, end_x;
//    logic [8:0] current_y, end_y;
//    logic signed [11:0] error;
//    logic signed [11:0] dx, dy;
//    logic signed [11:0] y_step;
//    logic signed [11:0] abs_dy;
//    
//    // Output assignments
//    assign x = current_x;
//    assign y = current_y;
//
//    // State machine to control the drawing
//    typedef enum logic [1:0] {IDLE, INIT, DRAW, DONE} state_t;
//    state_t state, next_state;
//
//    always_ff @(posedge clk or posedge reset) begin
//        if (reset) begin
//            // Reset all signals to their initial state
//            state <= IDLE;
//            current_x <= 10'b0;
//            current_y <= 9'b0;
//            error <= 12'b0;
//            dx <= 12'b0;
//            dy <= 12'b0;
//            y_step <= 12'b0;
//            abs_dy <= 12'b0;
//            end_x <= 10'b0;
//            end_y <= 9'b0;
//        end else begin
//            state <= next_state;
//
//            if (state == INIT) begin
//                current_x <= x0;
//                current_y <= y0;
//                end_x <= x1;
//                end_y <= y1;
//                dx <= x1 - x0;
//                dy <= y1 - y0;
//                abs_dy <= (dy < 0) ? -dy : dy;
//                error <= (x1 - x0) - abs_dy;
//
//                y_step <= (dy < 0) ? -1 : 1;
//            end
//            else if (state == DRAW) begin
//                if (current_x != end_x) begin
//                    // Move the x-coordinate
//                    current_x <= current_x + 1;
//                    // Adjust the error and y-coordinate if necessary
//                    if (error < 0) begin
//                        current_y <= current_y + y_step;
//                        error <= error + (dx - abs_dy);
//                    end
//                    error <= error - abs_dy;
//                end
//            end
//        end
//    end
//
//    // Next state logic
//    always_comb begin
//        case (state)
//            IDLE: next_state = (reset) ? IDLE : INIT;
//            INIT: next_state = DRAW;
//            DRAW: next_state = (current_x == end_x) ? DONE : DRAW;
//            DONE: next_state = DONE;
//            default: next_state = IDLE;
//        endcase
//    end
//
//endmodule
//
//
////	input logic clk, reset,
////	
////	// x and y coordinates for the start and end points of the line
////	input logic [9:0]	x0, x1, 
////	input logic [8:0] y0, y1,
////
////	//outputs cooresponding to the coordinate pair (x, y)
////	output logic [9:0] x,
////	output logic [8:0] y 
////	);
////	
////	logic signed [11:0] error, dx, dy;
////	logic isSteep;
////	logic signed [10:0] ystep;
////	logic signed [10:0] tx0, tx1, ty0, ty1,  tdx, tdy, absdx, absdy, nextX, nextY;
////	
////	// creates states 
////	enum {checkSteep, checkBackwards, startDraw, isDrawing} ps, ns;
////	
////	// calculates the absolute values based on input to calculate if line is steep
////	always_comb begin
////		dx = x1 - x0;
////		dy = y1 - y0;
////		
////		absdx = dx[11] ? -dx[10:0] : dx[10:0];
////		absdy = dy[11] ? -dy[10:0] : dy[10:0];
////	
////		isSteep = (absdy > absdx);
////	end
////	
////	always_ff @(posedge clk) begin
////		if(reset) begin
////			error <= 0;
////			
////			nextX <= 0;
////			nextY <= 0;
////			
////			ns <= checkSteep;
////		end
////		else begin
////		
////			// if inputs are steep, swaps x and y
////			if(ps == checkSteep) begin
////				if(isSteep) begin
////					tx0 <= y0;
////					tx1 <= y1;
////					ty0 <= x0;
////					ty1 <= x1;
////				end
////				else begin
////					tx0 <= x0;
////					tx1 <= x1;
////					ty0 <= y0;
////					ty1 <= y1;
////				end
////				
////				ns <= checkBackwards;
////			end
////			
////			// if x0 > x1, then it swaps x1 and x0, y1 and y0
////			if(ps == checkBackwards) begin
////				if(tx0 > tx1) begin
////					tx0 <= tx1;
////					ty0 <= ty1;
////					tx1 <= tx0;
////					ty1 <= ty0;
////				end
////				
////				ns <= startDraw;
////			end
////			
////			// calculates new dx and dy after checking steep and backwards
////			// sets error and ystep
////			if(ps == startDraw) begin
////				if(ty0 < ty1) begin
////					ystep <= 1;
////					tdy <= ty1 - ty0;
////				end
////				else begin
////					ystep <= -1;
////					tdy <= ty0 - ty1;
////				end
////				
////				tdx <= tx1 - tx0;
////				error <= -((tx1 - tx0) / 2);		
////					
////				nextX <= tx0;
////				nextY <= ty0;
////				
////				ns <= isDrawing;
////			end
////			
////			// loops through from x0 to x1, drawing each pixel
////			if(ps == isDrawing) begin
////				// done condition
////				if(nextX == tx1 + 1) begin
////					ns <= checkSteep;
////					
////				end else begin
////				
////					if(isSteep) begin
////						x <= nextY;
////						y <= nextX;
////					end
////					else begin
////						x <= nextX;
////						y <= nextY;	
////					end
////				
////					nextX <= nextX + 1;
////					
////					if((error + tdy) >= 0) begin
////						error <= error + tdy - tdx;
////						nextY <= nextY + ystep;
////					end else begin 
////						error <= error + tdy;
////					end
////				end
////			end
////		
////		// always updates state
////		ps <= ns;
////		
////		end
////		
////	end
//	
//	//	/*
////	 * You'll need to create some registers to keep track of things
////	 * such as error and direction
////	 * Example: */
////	logic signed [11:0] error;
////	logic is_steep;
////	logic [9:0] flip_x0, flip_x1, x0_t, x1_t;
////	logic [8:0] flip_y0, flip_y1, y0_t, y1_t;
////	
////	assign abs_diff_x = (x0 > x1) ? (x0 - x1) : (x1 - x0);
////	assign abs_diff_y = (y0 > y1) ? (y0 - y1) : (y1 - y0);
////	
////	assign is_steep = (abs_diff_y > abs_diff_x) ? 1'b1 : 1'b0;
////	
////	always_comb begin
////		if (is_steep == 1'b1) begin
////			flip_x0 = y0; flip_x1 = y1; flip_y0 = x0; flip_y1 = x1;
////		end
////		// Keep original values if not steep
////		else begin
////			flip_x0 = x0; flip_x1 = x1; flip_y0 = y0; flip_y1 = y1;
////		end
////	end
////	
////	always_comb begin
////		if (flip_x0 > flip_x1) begin
////			x0_t = flip_x1; x1_t = flip_x0; y0_t = flip_y1; y1_t = flip_y0;
////		end
////		else begin
////			x0_t = flip_x0; x1_t = flip_x1; y0_t = flip_y0; y1_t = flip_y1;
////		end
////	end 
////	
////	assign delta_x = x1 - x0; // delta_x = x1 − x0
////	assign delta_y = (y1 > y0) ? y1 - y0 : y0 - y1; // delta_y = abs(y1 - y0)
////	
////	always_ff @(posedge clk) begin
////		error <= is_steep ? (-(delta_y)/2) : (-(delta_x/2));
////	end
//	
//	
//     
//// endmodule
//
//module line_drawer_testbench ();
//	logic clk, reset;
//	logic [10:0]	x0, y0, x1, y1;
//	logic [10:0]	x, y;
//	logic done;
//	
//	line_drawer dut (.*);
//
//	parameter CLOCK_PERIOD = 300;
//	initial begin
//		clk <= 0;
//		forever #(CLOCK_PERIOD/2) clk <= ~clk;
//	end
//
//	integer i;
//	initial begin
//		
//	reset <= 1; 
//	x0 <= 11'd0; y0 <= 11'd0; x1 <= 11'd100;  y1  <= 11'd20; @(posedge clk);
//	reset <= 0;
//	
//	for (i = 0; i < 100; i++) begin
//		@(posedge clk);
//	end
//
//	$stop();
//	end
//endmodule 
