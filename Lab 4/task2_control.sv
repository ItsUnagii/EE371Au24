`timescale 1ns/1ns

// Aidan Lee, Aarin Wen
// 11/13/2024
// EE 371
// Lab 4
//
// Control module for the binary search task for Lab 4. Is in charge of managing states, bounds of the search
// area, etc.
//
// utilizes clk input
//	input	 reset					resets the search (clears the output) and waits for another start sigal
// input  [7:0] A					represents the desired value that you want to find inside the RAM
// input  start					starts the algorithm. Waits for this value to go to high before starting
// input  [7:0] data_out		the data at address to_check, received by the datapath module
// output found					goes high if the value A was found in the ram		
// output notfound				goes high at the end when finished if the value A was not found
// output done						goes high if algorithm is finished
// output to_check				tells the datapath module what address to find the value of next
// output [4:0] loc				represents the address location where the value is found

module task2_control (reset, clk, A, data_out, start, found, notfound, done, to_check, loc);

   input logic reset, clk, start;
	
   input logic [7:0] A;
	
	// Data_out - The data out of the RAM module after feeding it in an address
	input logic [7:0] data_out;
    
   output logic found, notfound, done;
	// The address to check: the middle address between the upper bound and lower bound. 5 bits to match the RAM module
   output logic [4:0] to_check;
	output logic [4:0] loc;

	// upper bounds and lower bounds of the binary search. added an extra bit so that it can hold 32
   logic [5:0] upper_bound, lower_bound;
   
   // next_bounds - Control signal that reports whether the upper or lower
   // bounds should be adjusted for the next search. 2 bits long so that 2'b11 can
   // signal to stop adjusting bounds
   logic [1:0] next_bounds;

   // control circuit
   logic [2:0] ps, ns;
	parameter S1 = 3'b000, S2 = 3'b001, S3 = 3'b010, S4 = 3'b011, S5 = 3'b100;

    // internal status signal to report the value was not found (INTERNAL ONLY)
    logic change_bounds;

    // state logic
    always_comb begin
        case (ps) 
            S1: if (start == 0) ns = S1; // initial state: wait until start signal
                else ns = S2;
            S2: ns = S3; // do algorithm for one clock cycle
            S3: if (data_out == A || notfound) ns = S5; // decide if algorithm should be repeated or if we are done
                else ns = S4;
            S4: ns = S2; // update bounds
            S5: if (start == 0) ns = S1; // done state
                else ns = S5;
        endcase
    end

    // state control ff
    always_ff @(posedge clk) begin
        if (reset)
            ps <= S1;    
        else
            ps <= ns;
    end

    // comb logic that assigns control and status signals - prepares what direction 
	 // next upper and lower bounds should go to if value not found
    always_comb begin
        done = 0; loc = 0; next_bounds = 2'b11;
        case (ps)
            S4: begin
                if (data_out > A) begin    
                    next_bounds = 0;
                end
                else if (data_out < A) begin
                    next_bounds = 1;
                end
            end
            S5: begin
                // edge case: if data not found, report 0
                if (!notfound)
                    loc = to_check;

                done = 1;
            end
				default: begin
					done = 0; loc = 0; next_bounds = 2'b11;
				end
        endcase
    end

    // clock logic to make upper and lower bounds assigned on correct clock cycle
    always_ff @(posedge clk) begin
			// default case
         if (reset || start == 0) begin 
            upper_bound <= 32;
            lower_bound <= 0;
         end
         // edge case: when value is at upper bound address 31
         else if (change_bounds) begin
            upper_bound <= 33;
            lower_bound <= 31;
         // adjust lower bounds (according to next_bounds)
         end else if (next_bounds == 2'b01) begin
            upper_bound <= upper_bound;
            lower_bound <= to_check + 1;
         // adjust upper bounds (according to next_bounds)
         end else if (next_bounds == 2'b00) begin
            upper_bound <= to_check + 1;
            lower_bound <= lower_bound;
         // otherwise, don't touch the bounds. usually for initial run, or when algo finishes
         end else begin
            upper_bound <= upper_bound;
            lower_bound <= lower_bound;
         end
    end
    
	 // calculation to determine whether to check the upper half or lower half for binary search
    assign to_check = ((upper_bound - lower_bound)/2) + lower_bound - 1;
    // reports that the correct value was found once finished running algorithm
    assign found = (data_out == A) && done;
    // signal to change bounds
    assign change_bounds = ((upper_bound == 32) && (lower_bound == 31));
    // signal to check that the value was not found (triggers at the end when finished)
    assign notfound = ((upper_bound - lower_bound) == 1) && (data_out != A);

endmodule

module control_tb ();
   
	logic reset, clk, start;
	
   logic [7:0] A;
	
	
	logic [7:0] data_out;
   
   logic found, notfound, done;
	
   logic [4:0] to_check;
	logic [4:0] loc;

   // Clock logic
   parameter CLOCK_PERIOD = 5; // Increase clock frequency
   initial begin
       clk <= 0;
       forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
   end

   task2_control dut (.*);

	initial begin
        
		  A <= 8'b00000000; start <= 1'b0; data_out <= 0;
        reset <= 1; @(posedge clk);
						  @(posedge clk);
        
		  // check not finding it (should try to go down in address
		  start <= 1'b1; reset <= 0; A <= 8'b00000000; data_out <= 8'd15;
		  repeat (8) @(posedge clk);
		  
		  reset <= 1; start <= 1'b0; @(posedge clk);
						  @(posedge clk);
        
		  // check finding it
		  start <= 1'b1; reset <= 0; A <= 8'b00000000; data_out <= 8'b0;
		  repeat (8) @(posedge clk);
		  

		  
		  $stop;
   end

endmodule