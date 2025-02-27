`timescale 1ns/1ns

// Aidan Lee, Aarin Wen
// 11/13/2024
// EE 371
// Lab 4
//
// Datapath module for the binary search task for Lab 4. Is in charge of storing memory,
// and telling the control module what value is at every address it looks for.
//
// utilizes clk input
// input to_check					tells the datapath module what address to find the value of next
// output [7:0] data_out		represents the address location where the value is found

module task2_datapath (to_check, clk, data_out);

	input logic [4:0] to_check;
	input logic clk;
	output logic [7:0] data_out;
	
	// 32x8 ram module, instantiated using the built in methods taught in lab 2
	// takes in a 5bit address to check the value currently in that address to find the desired value
	// takes in a clock input
	// takes in data (doesn't matter. never reading)
	// takes in wren as a write enable (which is always 0, never going to matter)
	// outputs 8bit data_out to reveal what's in the ram at the given address
   ram32x8 ram (.address(to_check), .clock(clk), .data(1'b1), .wren(1'b0), .q(data_out));

endmodule

module datapath_tb ();
   
	logic [4:0] to_check;
	logic clk;
	logic [7:0] data_out;

   // Clock logic
   parameter CLOCK_PERIOD = 5; // Increase clock frequency
   initial begin
       clk <= 0;
       forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
   end

   task2_datapath dut (.*);

   initial begin
		
		// check whats in every address
		for (int i = 0; i < 32; i++) begin
			to_check = i;
			@(posedge clk);
		end;
      $stop;
    end

endmodule