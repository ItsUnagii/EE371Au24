`timescale 1 ps / 1 ps

/***
*	Aidan Lee, Aarin Wen
*	10/18/2024
*	EE371
*	Lab 2
*
*	Top level module for Task 2, Lab 2
* 	Dual port memory module that displays data using hex displays.
*	The write address and data can be toggled using the switches,
*	while the read address is constantly ticking on a counter.
*
* 	takes in SW[3:0] for the data being written in
* 	takes in SW[8:4] for the address the data is being written to
*	takes in KEY[3]  for enabling writing
*	takes in KEY[0]  for resets
*	takes in CLOCK_50 for general clock timing
*
*	outputs HEX5 and HEX4 for displaying write address
*	outputs HEX3 and HEX2 for displaying the read address
*	outputs HEX1 and HEX0 for displaying the data that was read
*
***/

module Lab2Task2 (CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

    input  logic CLOCK_50;
    input  logic [9:0] SW;
	 input  logic [3:0] KEY;
	 
	 output logic [9:0] LEDR;    
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    logic [3:0] dataIn;
    logic [3:0] dataOut;
    logic [4:0] wraddress;
    logic wren;
	 logic reset;

    // assigns controls to ram inputs
	 assign dataIn = SW[3:0];
    assign wraddress = SW[8:4];
    assign wren = ~KEY[3];
    assign reset = ~KEY[0];

	 logic [4:0] count;
	 counter incrementer (.clock(CLOCK_50), .reset(reset), .addr(count));
	 
    // instantiates the task 2 ram
	 ram32x4 task2ram (.clock(CLOCK_50), .data(dataIn), .rdaddress(count), .wraddress(wraddress), .wren(wren), .q(dataOut));
	 
    // address displayed on HEX5 and HEX4
    seg7 hex5 ({{3{1'b0}}, wraddress[4]}, HEX5);
    seg7 hex4 (wraddress[3:0], HEX4);
		
	 // display the counter on HEX3 and HEX2
	 seg7 hex3 ({{3{1'b0}}, count[4]}, HEX3);
	 seg7 hex2 (count[3:0], HEX2); 
    
	 // write data dataIn displayed on HEX1
    seg7 hex1 (dataIn, HEX1);

    // dataOut displayed on HEX0
    seg7 hex0 (dataOut, HEX0); 	

endmodule



module Lab2Task2_tb();
	
   logic CLOCK_50;
   logic [9:0] SW;
	logic [3:0] KEY;
	 
	logic [9:0] LEDR;    
   logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	logic clock;
	assign CLOCK_50 = clock;

   // Clock logic
   parameter CLOCK_PERIOD = 10; // Increase clock frequency
   initial begin
       clock <= 0;
       forever #(CLOCK_PERIOD/2) clock <= ~clock; // Forever toggle the clock
   end

   Lab2Task2 dut (.*);

   initial begin
		KEY[0] <= 0; @(posedge clock);
						 @(posedge clock);
		KEY[0] <= 1; @(posedge clock);
						 @(posedge clock);
		
		// Set everything to 0
		SW[8:4] <= 5'b00000; SW[3:0] <= 3'b000; KEY[3] <= 1; @(posedge clock);
		  
      // write to every address
      KEY[3] <= 0; @(posedge clock);

      // 000 through 111 from 00000 to 00111
      for (int i = 0; i < 8; i++) begin
          SW[8:4] <= i; SW[3:0] <= i; @(posedge clock);
      end

      // 000 through 111 from 01001 to 10000
      for (int i = 8; i < 16; i++) begin
          SW[8:4] <= i; SW[3:0] <= i; @(posedge clock);
      end

      // 000 through 111 from 10001 to 11000
      for (int i = 16; i < 24; i++) begin
          SW[8:4] <= i; SW[3:0] <= i; @(posedge clock);
      end

      // 000 through 110 from 11001 to 11111
      for (int i = 24; i < 32; i++) begin
          SW[8:4] <= i; SW[3:0] <= i; @(posedge clock);
      end

      // read every address (should be ascending)
      repeat (1000) @(posedge clock);

		$stop;
	end
endmodule
