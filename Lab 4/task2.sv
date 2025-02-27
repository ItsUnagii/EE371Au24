`timescale 1ns/1ns

// Aidan Lee, Aarin Wen
// 11/13/2024
// EE 371
// Lab 4
//
// Binary search module that returns the address loc in a sorted ascending 32x8 ram module if a value A is found.
// Seaches the middle most value of the array. If not found, the module decides whether to search
// the upper or lower half depending on if the value found at the middle is higher or lower than the
// the desired value. Needs RAM to be sorted ascending to work.
//
// utilizes clk input
//	input	 reset					resets the search (clears the output) and waits for another start sigal
// input  [7:0] A					represents the value that you want to find inside the
// input  start					represents the y coordinates of the two endpoints of the line you want to draw
// output found					goes high if the value A was found in the ram		
// output notfound				goes high at the end when finished if the value A was not found
// output done						goes high if algorithm is finished
// output [4:0] loc				represents the address location where the value is found

module task2 (reset, clk, A, start, found, notfound, done, loc);

   input logic reset, clk, start;
   input logic [7:0] A;
    
   output logic found, notfound, done;
   output logic [4:0] loc;
	
	// intermediate values to talk between datapath and control
	logic [4:0] to_check;
	logic [7:0] data_out;
	
   task2_datapath d_unit (.*);
	task2_control  c_unit (.*);
	 

endmodule

module task2_tb ();
   logic reset, clk;
	logic [7:0] A;
	logic [4:0] loc;
	logic start, found, notfound, done;

    // Clock logic
    parameter CLOCK_PERIOD = 5; // Increase clock frequency
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
    end

    task2 dut (.*);

    initial begin
        A <= 8'b00000000; start <= 1'b0;
        reset <= 1; @(posedge clk);
						  @(posedge clk);
        
		  // test very end
		  start <= 1'b1; reset <= 0; A <= 8'b00000000;
		  repeat (16) @(posedge clk);
		  
		  
		  reset <= 1; @(posedge clk); // check if reset works
		  start <= 1'b0; @(posedge clk);
						  
		  // test lowest value of binary search that takes the longest time
		  start <= 1'b1; reset <= 0; A <= 8'b00000001;
		  repeat (16) @(posedge clk);
		  
		  start <= 1'b0;
		  reset <= 1; @(posedge clk);
						  @(posedge clk);
        
		  // test highest value (edge case)
		  start <= 1'b1; reset <= 0; A <= 8'd31;
		  repeat (24) @(posedge clk);
		  
		  start <= 1'b0;
		  reset <= 1; @(posedge clk);
						  @(posedge clk);
		  
		  // test highest value of binary search that takes the longest time
		  start <= 1'b1; reset <= 0; A <= 8'd30;
		  repeat (16) @(posedge clk);
		  
		  start <= 1'b0;
		  reset <= 1; @(posedge clk);
						  @(posedge clk);
						  
		  // test a value of binary search in the middle that takes the longest time
		  // to test that going up and down works
		  start <= 1'b1; reset <= 0; A <= 8'd16;
		  repeat (16) @(posedge clk);
		  
		  start <= 1'b0;
		  reset <= 1; @(posedge clk);
						  @(posedge clk);
						  
		  // test finding the value immediately
		  start <= 1'b1; reset <= 0; A <= 8'd15;
		  repeat (16) @(posedge clk);
		  
		  start <= 1'b0;
		  reset <= 1; @(posedge clk);
						  @(posedge clk);
		  
		  // test value not in array
		  start <= 1'b1; reset <= 0; A <= 8'b11111111; 
		  repeat (24) @(posedge clk);
		  start <= 1'b0; @(posedge clk); @(posedge clk);
		  
		  $stop;
    end

endmodule