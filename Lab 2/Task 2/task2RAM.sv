`timescale 1 ps / 1 ps

/***
*	Aidan Lee, Aarin Wen
*	10/18/2024
*	EE371
*	Lab 2
*
*	RAM module for Task 2, Lab 2
* 	builds a 32x3 memory file using a memory array
*
* 	input 5 bit address	 		 for reads and writes
*	input 3 bit data	 	 		 for data that is going to be written
* 	input 1 bit clock				 for clock
*	input 1 bit wren				 for enabling write (WRite ENable)
*
* 	outputs 3 bit q, 				 for data out
*
***/


module task2RAM (clock, address, data, wren, q);

	input  logic [4:0] address;
	input  logic clock;
	input  logic [2:0] data;
	input  logic wren;
	output logic [2:0] q;
	
   logic [2:0] memory_array [31:0];
    
	// array that tracks if a space in memory was written to
   logic [31:0] written_flag;

   // Logic controlling whether to read or write from memory. Because memory addresses
   // have a default value of XXX and not 0, we need some special logic to determine what to output.
   always_ff @(posedge clock) begin
       // If write is enabled, write the value to the specified memory address. Also mark in written_flag that this
       // address has had memory written before.
       if (wren) begin
           memory_array[address] <= data;
           written_flag[address] <= 1'b1; 
       end
        
       // If write is enabled and memory has not been written to that address before, output the write data
       if (written_flag[address] !== 1'b1 && wren) // 
           q <= data;
       
		 // If write disabled and address empty, return 000 as a default (instead of x's)
       else if (written_flag[address] !== 1'b1 && wren == 1'b0)
           q <= 3'b000;
        
		 // else output the value stored at address
       else 
           q <= memory_array[address];
   end
endmodule 





module Lab2Task2fake_tb();
	
   logic [4:0] addr;
   logic [2:0] data;
   logic clock;
   logic wren;

   // Output logic
   logic [2:0] q;

   // Clock logic
   parameter CLOCK_PERIOD = 5; // Increase clock frequency
   initial begin
       clock <= 0;
       forever #(CLOCK_PERIOD/2) clock <= ~clock; // Forever toggle the clock
   end

   task2RAM dut (.clock(clock), .address(addr), .data(data), .wren(wren), .q(q));

   initial begin

		// Set everything to 0
		addr <= 5'b00000; data <= 3'b000; wren <= 0; @(posedge clock);
        
		// enable write and write value 111 to address 00000
      wren <= 1; data <= 3'b111; @(posedge clock);
        
		// switch data to 000 and disable writing
		// expected value of q is 111
      data <= 3'b000; wren <= 0;@(posedge clock);
      
		// switch to a different address and see whats in there
		// expected value of q is 000
		addr <= 5'b11111; @(posedge clock);
        
		// go back to to address 00000 
		// expected value of q should still be 111
      addr <= 5'b00000; @(posedge clock);
      
		#20;
      @(posedge clock);
        
		  
      // write to every address
      wren <= 1;

      // 000 through 111 from 00000 to 00111
      for (int i = 0; i < 8; i++) begin
          addr <= i; data <= i; @(posedge clock);
      end

      // 000 through 111 from 01001 to 10000
      for (int i = 9; i < 16; i++) begin
          addr <= i; data <= i; @(posedge clock);
      end

      // 000 through 111 from 10001 to 11000
      for (int i = 17; i < 24; i++) begin
          addr <= i; data <= i; @(posedge clock);
      end

      // 000 through 110 from 11001 to 11111
      for (int i = 25; i < 31; i++) begin
          addr <= i; data <= i; @(posedge clock);
      end

      // read every address (should be ascending)
      wren <= 0; data <= 0;
      for (int i = 0; i < 31; i++) begin
          addr <= i; @(posedge clock);
      end

      #20;

		$stop;
	end
endmodule
