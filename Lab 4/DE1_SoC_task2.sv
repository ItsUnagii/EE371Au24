`timescale 1ns/1ns

// Aidan Lee, Aarin Wen
// 11/13/2024
// EE 371
// Lab 4
//
// Binary search module that returns the address loc in SW[7:0] sorted ascending 32x8 ram module if SW[7:0] value SW[7:0] is found.
// Seaches the middle most value of the array. If not found, the module decides whether to search
// the upper or lower half depending on if the value found at the middle is higher or lower than the
// the desired value. Needs RAM to be sorted ascending to work.
//
// utilizes clk input
//	input	 reset					resets the search (clears the output) and waits for another SW[9] sigal
// input  [7:0] A					represents the value that you want to find inside the
// input  start					represents the y coordinates of the two endpoints of the line you want to draw
// output found					goes high if the value SW[7:0] was found in the ram		
// output final_notfound		goes high if the value SW[7:0] was not found
// output done						goes high if algorithm is finished
// output [4:0] loc				represents the address location where the value is found

module De1SoC (CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);

    input  logic CLOCK_50;
    input  logic [3:0] KEY;
    input  logic [9:0] SW;
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0] LEDR;

    logic clk, reset, done, found, notfound;
	 logic [4:0] loc;
	 logic [7:0] result;
	 	
	 logic start;
    
    assign reset = ~KEY[0]; // reset on KEY0
	 assign start = SW[9]; // start on SW9
	 assign LEDR[9] = found; // 9 lights up if found
	 assign LEDR[8] = notfound; // 8 lights up if not found
	 assign LEDR[1] = done; // 1 indicates finished
	 assign LEDR[0] = reset; // 0 indicates currently in reset
	 
    assign clk = CLOCK_50;
	
	// main binary search algorithm
	//
	// takes in clock and reset
	// takes in SW[7:0] as the value to look for in binary search
	// takes in SW[9] to indicate that the algorithm should SW[9] running
	// gives out found and notfound depending on if the value was found in ram
	// gives out done when finished looking for value
	// gives out loc which is the address where the desired value SW[7:0] is stored
	task2 taskDisp2 (reset, clk, SW[7:0], start, found, notfound, done, loc); // SW[7:0] to specify A
	seg7 disp1 ({3'b0, loc[4]}, HEX1);
	seg7 disp0 (loc[3:0], HEX0); 
	
	// none of the other hexes are used for this task
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	// kill all other leds
	assign LEDR[7:2] = 6'b000000;
	
endmodule

module De1SoC_tb ();
    logic CLOCK_50;
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 logic [9:0] LEDR;
	 
	 logic clk;
	 assign CLOCK_50 = clk;

    // Clock logic
    parameter CLOCK_PERIOD = 5; // Increase clock frequency
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
    end

    De1SoC dut (.*);

    initial begin
        SW[7:0] <= 8'b00000000; SW[9] <= 1'b0;
        KEY[0] <= 0; @(posedge clk);
						  @(posedge clk);
        
		  // test very end
		  SW[9] <= 1'b1; KEY[0] <= 1; SW[7:0] <= 8'b00000000;
		  repeat (16) @(posedge clk);
		  
		  
		  KEY[0] <= 0; @(posedge clk); // check if reset works
		  SW[9] <= 1'b0; @(posedge clk);
						  
		  // test lowest value of binary search that takes the longest time
		  SW[9] <= 1'b1; KEY[0] <= 1; SW[7:0] <= 8'b00000001;
		  repeat (16) @(posedge clk);
		  
		  SW[9] <= 1'b0;
		  KEY[0] <= 0; @(posedge clk);
						  @(posedge clk);
        
		  // test highest value (edge case)
		  SW[9] <= 1'b1; KEY[0] <= 1; SW[7:0] <= 8'd31;
		  repeat (24) @(posedge clk);
		  
		  SW[9] <= 1'b0;
		  KEY[0] <= 0; @(posedge clk);
						  @(posedge clk);
		  
		  // test highest value of binary search that takes the longest time
		  SW[9] <= 1'b1; KEY[0] <= 1; SW[7:0] <= 8'd30;
		  repeat (16) @(posedge clk);
		  
		  SW[9] <= 1'b0;
		  KEY[0] <= 0; @(posedge clk);
						  @(posedge clk);
						  
		  // test SW[7:0] value of binary search in the middle that takes the longest time
		  // to test that going up and down works
		  SW[9] <= 1'b1; KEY[0] <= 1; SW[7:0] <= 8'd16;
		  repeat (16) @(posedge clk);
		  
		  SW[9] <= 1'b0;
		  KEY[0] <= 0; @(posedge clk);
						  @(posedge clk);
						  
		  // test finding the value immediately
		  SW[9] <= 1'b1; KEY[0] <= 1; SW[7:0] <= 8'd15;
		  repeat (16) @(posedge clk);
		  
		  SW[9] <= 1'b0;
		  KEY[0] <= 0; @(posedge clk);
						  @(posedge clk);
		  
		  // test value not in array
		  SW[9] <= 1'b1; KEY[0] <= 1; SW[7:0] <= 8'b11111111; 
		  repeat (24) @(posedge clk);
		  SW[9] <= 1'b0; @(posedge clk); @(posedge clk);
		  
		  $stop;
    end

endmodule