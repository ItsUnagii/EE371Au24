module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = SW;
	
	logic [9:0] x0, x1, x;
	logic [8:0] y0, y1, y;
	logic frame_start;
	logic pixel_color;
	
	
	//////// DOUBLE_FRAME_BUFFER ////////
	logic dfb_en;
	assign dfb_en = 1'b0;
	/////////////////////////////////////
	
	VGA_framebuffer fb(.clk(CLOCK_50), .rst(1'b0), .x, .y,
				.pixel_color, .pixel_write(1'b1), .dfb_en, .frame_start,
				.VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS,
				.VGA_BLANK_N, .VGA_SYNC_N);
	
	// draw lines between (x0, y0) and (x1, y1)
	line_drawer lines (.clk(CLOCK_50), .reset(1'b0),
				.x0, .y0, .x1, .y1, .x, .y);
	
	assign pixel_color = 1'b1;
	
	// COMMENT AND UNCOMMENT EACH OF THESE FOR LAB DEMO 1
	// horizontal line
	assign x0 = 160;
	assign y0 = 240;
	assign x1 = 480;
	assign y1 = 240;
	
//	// vertical line
//	assign x0 = 320;
//	assign y0 = 120;
//	assign x1 = 320;
//	assign y1 = 360;
//	
//	// slope of 1
//	assign x0 = 240;
//	assign y0 = 240;
//	assign x1 = 480;
//	assign y1 = 480;
//	
//	// slope of -1
//	assign x0 = 240;
//	assign y0 = 480;
//	assign x1 = 480;
//	assign y1 = 240;
//	
//	// slope of 2
//	assign x0 = 0;
//	assign y0 = 0;
//	assign x1 = 240;
//	assign y1 = 480;
//	
//	// slope of 0.5
//	assign x0 = 0;
//	assign y0 = 0;
//	assign x1 = 480;
//	assign y1 = 240;
	
endmodule
