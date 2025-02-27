//Aidan Lee, Aarin Wen
// 11/13/2024
// EE 371
// Lab 4

// Main bitCounter module
// Counts the number of 1's in input A and outputs total as 'result' and a 'done' signal

// Parameters: A_WIDTH (width of input A) and RES_WIDTH (width of result)

// inputs: 
// 1'b wide: reset, clk, s (start signal), 
// A_WIDTH wide: A (data input)

// outputs: 
// 1'b wide: done (counting complete)
// RES_WIDTH wide: result (total count of 1's in A)

module bitCounter #(parameter A_WIDTH = 8, RES_WIDTH = 4) ( 
input logic reset, clk, s,
input logic [A_WIDTH-1:0] A,
output logic done,
output logic [RES_WIDTH-1:0] result);
	
	// logic for control signals and updated A value
	logic incr_result, rshift_A, load_A, reset_result, done_;
	logic [A_WIDTH-1:0] A_new;
	
	// initialize datapath
	// all inputs and outputs instantiated with their respective matching variables
	bitCounter_datapath		#(A_WIDTH, RES_WIDTH)	datapath
	(.clk, .incr_result, .rshift_A, .load_A, .reset_result, .done_, .A, .done, .A_new, .result);
	
	// initialize controller
	// all inputs and outputs besides A instantiated with their respective matching variables
	// input 'A' is instantiated with 'A_new' which is the updated A value from the datapath
	bitCounter_controller	#(A_WIDTH, RES_WIDTH)	controller 
	(.reset, .clk, .s, .A(A_new), .incr_result, .rshift_A, .load_A, .reset_result, .done_);
	
endmodule

////////////////////////////////////////////////////////////////////////

// bitCounter datapath module
// Contains all datapath elements and data operations of bitCounter, 
// also outputs updated A value for controller

// Parameters: A_WIDTH (width of input A) and RES_WIDTH (width of result)

// inputs:
// 1'b wide: clk, 
//				 incr_result, rshift_a, load_A, reset_result, done_ (signals from controller)
// A_WIDTH wide: A (input data)

// outputs:
// 1'b wide: done (count complete status signal)
// A_WIDTH wide: A_new (updated A value for controller)
// RES_WIDTH wide: result (total 1's in A)

module bitCounter_datapath #(parameter A_WIDTH = 8, RES_WIDTH = 4) ( 
input logic clk, incr_result, rshift_A, load_A, reset_result, done_,
input logic [A_WIDTH-1:0] A,
output logic done,
output logic [A_WIDTH-1:0] A_new,
output logic [RES_WIDTH-1:0] result);
	
	// always_ff block to synchronously manipulate and move data
	always_ff @(posedge clk) begin
		done <= done_; 	// store 'done'
		
		if (incr_result) 	// increment result
			result <= result + 1'b1; 
			
		if (rshift_A) 		// right shift A by 1
			A_new <= A_new >> 1'b1;
			
		if (load_A) 		// load A
			A_new <= A;
			
		if (reset_result) // set result = 0
			result <= 0;
	end
	
endmodule

////////////////////////////////////////////////////////////////////////

// bitCounter controller module
// Contains all controller elements of bitCounter including FSM,
// also takes in and utilizes updated A value from datapath output
// also contains logic and operatiosn to output correct control signals

// Parameters: A_WIDTH (width of input A) and RES_WIDTH (width of result)

// inputs:
// 1'b wide: reset, clk, s (start signal)
// A_WIDTH wide: A (input data)

// outputs:
// 1'b wide: 	incr_result, 	(increment results)
//					rshift_A, 		(right shift A by 1 bit)
//					load_A, 			(load new A value)
//					reset_result, 	(reset result value to 0)
//					done_ 			(count complete signal)


module bitCounter_controller #(parameter A_WIDTH = 8, RES_WIDTH = 4) ( 
input logic reset, clk, s,
input logic [A_WIDTH-1:0] A,
output logic incr_result, rshift_A, load_A, reset_result, done_);
	
	// present and next states S1 S2 S3
	enum {S1, S2, S3} ps, ns; // S1 = initialization, S2 = analyzing, S3 = finished
	
	// FSM state-to-state logic
	always_comb begin
		case (ps)
			S1: ns = s ? S2: S1; 			// ns to S2 if s, 	S1 OW
			S2: ns = (A == 0) ? S3: S2; 	// ns to S3 if A==0, S2 OW
			S3: ns = s ? S3: S1; 			// ns to S3 if s, 	S1 OW
		endcase
	end
	
	// combinational logic for output control signals
	always_comb begin
		// increment signal if in S2, A != 0 and rightmost bit == 1
		incr_result 	= (ps == S2) & (ns == S2) & (A[0] == 1);
		// right shift signal if ps is S2 (data analyzing and unfinished)
		rshift_A 		= ps == S2;
		// load signal if data analyzing hasnt started yet & no start signal 
		load_A 			= (ps == S1) & (~s);
		// reset result signal if data analyzing for current data hasnt started
		reset_result	= ps == S1;
		// send done signal if data analyzing is complete
		done_				= ps == S3;
	end
	
	// ps <= ns unless reset, then ps resets to S1
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S1;
		else
			ps <= ns;
	end
	
endmodule

////TESTBENCHES//////////////////////////////////////////////////////////////

// main testbench
// tests reset and s cases as well as A <= 8'b10101010, 8'b10000001, and 8'b0;
module bitCounter_tb(); 
	// variables and parameters
	parameter A_WIDTH = 8;
	parameter RES_WIDTH = 4; 
	logic reset, clk, s, done;
	logic [A_WIDTH-1:0] A;
	logic [RES_WIDTH-1:0] result;
	
	// create bitCounter dut
	bitCounter #(A_WIDTH, RES_WIDTH) dut (.*);
	
	// initialize clock simulation
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	integer i; // int i for loops
	// begin tests
	initial begin
		// initialize values
		reset <= 1; s <= 0; A <= 8'b0; @(posedge clk);
		
		// release reset
		reset <= 0; @(posedge clk);
		
		// test if bit-count analysis begins without start signal (SHOULD NOT)
		// results & done should remain at 0
		A <= 8'b10101010; repeat (14) @(posedge clk);
		A <= 8'b00000000; @(posedge clk);
		
		// loop that uses bitCounter on bits 8'b00000001 to 8'b11111111 by incrementing
		// results should settle to how many 1's are in the 8b input; expect 1->8
		// done should have value '1' whenever results are settled
		// note: 8b'0 will be checked in next loop
		for (i = 0; i < 8; i = i + 1) begin
			// turn start signal off before loading in new data
			s <= 0; @(posedge clk);
				 
			// load in new A value
			A <= (8'b00000001 << i) | A; @(posedge clk);

			// count 1's and let 'result' and 'done' settle
			s <= 1; repeat (14) @(posedge clk);
		end
	
		// loop that uses left shifting to bit-count 8'b11111111 to 8'b0
		// results should settle to how many 1's are in the 8b input; expect 8->0
		// done should have value '1' whenever results are settled
		for (i = 8; i >= 0; i = i - 1) begin
			// turn start signal off before loading in new data
			s <= 0; @(posedge clk);
			
			// load in new A value
			A <= 8'b11111111 << (8-i); @(posedge clk);
			
			// count 1's and let 'result' and 'done' settle
			s <= 1; repeat (14) @(posedge clk);
		end
		$stop;

	end
endmodule

// datapath testbench
module bitCounter_datapath_tb(); 
	// variables and parameters
	parameter A_WIDTH = 8;
	parameter RES_WIDTH = 4; 
	logic clk, incr_result, rshift_A, load_A, reset_result, done_;
	logic [A_WIDTH-1:0] A;
	
	logic done;
	logic [A_WIDTH-1:0] A_new;
	logic [RES_WIDTH-1:0] result;
	
	// create bitCounter dut
	bitCounter_datapath #(A_WIDTH, RES_WIDTH) dut2 (.*);
	
	// initialize clock simulation
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		// initialize values
		incr_result <= 0;
		rshift_A <= 0;
		load_A <= 0;
		reset_result <= 1;
		done_ <= 0;
		
		// test load_A, new data A = 8'b10101010 should load in.
		A <= 8'b10101010; 
		load_A <= 1;@(posedge clk);
		load_A <= 0;@(posedge clk);
		
		// test incrementing, result should increment from decimal 0 to 8
		reset_result <= 0;
		incr_result <= 1; repeat (8) @(posedge clk);
		incr_result <= 0; @(posedge clk);
		
		// test reset_result, result should go to 0
		reset_result <= 1; @(posedge clk);
		reset_result <= 0; @(posedge clk);
		
		// test right shift A, A_new should now equal 8'b01010101
		rshift_A <= 1; @(posedge clk);
		rshift_A <= 0; @(posedge clk);
		
		// test loading in new value A
		A <= 8'b11110000; 
		load_A <= 1;@(posedge clk);
		load_A <= 0;@(posedge clk);
		
		// test that done stores and outputs done_ (output from controller)
		done_ <= 1; @(posedge clk);
		done_ <= 0; @(posedge clk);
		
		$stop;

	end
endmodule


// Controller testbench
module bitCounter_controller_tb(); 
    // parameters
    parameter A_WIDTH = 8;
    parameter RES_WIDTH = 4;
    
    // signals for inputs and outputs
    logic reset, clk, s;
    logic [A_WIDTH-1:0] A;
	 
    logic incr_result, rshift_A, load_A, reset_result, done_;
    
    // instantiate the controller
    bitCounter_controller #(A_WIDTH, RES_WIDTH) dut3 (.*);

    // initialize clock simulation
    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    // test sequence
	initial begin
		 // initialize inputs
		 reset <= 1; 
		 s <= 0; 
		 A <= 8'b0; 
		 @(posedge clk);
		 
		 // Release reset, enter S1
		 // Expect: reset_result = 1, all other signals = 0
		 reset <= 0; @(posedge clk);

		 // Test S1 to S2 transition with s = 1
		 s <= 1; A <= 8'b01010101; @(posedge clk);
		 // Expect: load_A = 1, all other signals = 0

		 // Test S2 state behavior with non-zero A (data analyzing)
		 s <= 0; repeat(2) @(posedge clk);
		 // Expect: 
		 // rshift_A = 1 
		 // incr_result = 1 since least significant bit of A is 1
		 // all other signals = 0

		 // Test S2 to S3 transition when A == 0
		 A <= 8'b0; @(posedge clk);
		 // Expect: done_ = 1 (indicates counting is complete), all other signals = 0

		 // Test S3 to S1 transition when s is toggled
		 s <= 1; @(posedge clk);
		 // Expect: 
		 // done_ remains 1 if in S3, indicating analyzing is complete
		 // done_ returns to 0 upon resetting back to S1 given s = 0
		 s <= 0; @(posedge clk);
		 
		 // test if loading in new value works
		 A <= 8'b11110000;
		 s <= 1; @(posedge clk); 
		 s <= 0; repeat(2) @(posedge clk);

		$stop;
	 end
endmodule

