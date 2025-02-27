`timescale 1 ps / 1 ps

// Aidan Lee, Aarin Wen
// 10/18/2024
// EE 371
// Lab 2

// Full FIFO module with parameterized depth and width
// utilizes clock and reset signals
// input read 							returns the least recent value in outputBus when high
// input write 						adds the value contained in inputBus into the FIFO when high
// outputs empty and full flags	indicate FIFO status of empty or full
// output outputBus					contains the value returned by the FIFO if popped out

module FIFO #(
				  parameter depth = 3,
				  parameter width = 16
				  )(
					 input logic clk, reset,
					 input logic read, write,
					 input logic [width-1:0] inputBus,
					output logic empty, full,
					output logic [width-1:0] outputBus
				   );
					
	/* 	Define_Variables_Here		*/
	// addresses are same size as the depth (represents address width)
	logic [depth-1:0] writeAddr, readAddr;
	logic wr_en;
	
	// enable write only when fifo isn't full
	// or reading & writing at the same time
	assign wr_en = write; // & (~full | read);
	
	/*			Instantiate_Your_Dual-Port_RAM_Here			*/
	dpram #(.DATA_WIDTH(width), .ADDR_WIDTH(depth)) register (.clk(clk), .w_data(inputBus), .w_en(wr_en), 
																				.w_addr(writeAddr), .r_addr(readAddr), .r_data(outputBus));

	
	
	/*			FIFO-Control_Module			*/				
	fifo_ctrl #(depth) FC (.clk, .reset, .rd(read), .wr(write), .empty, .full, .w_addr(writeAddr), .r_addr(readAddr));
	
endmodule 

module FIFO_tb();
	
	parameter depth = 3, width = 16; // 16x8
	
	logic clk, reset;
	logic read, write;
	logic [width-1:0] inputBus;
	logic empty, full;
	logic [width-1:0] outputBus;
	
	FIFO #(depth, width) dut (.*);
	
	parameter CLK_Period = 100;
	
	initial begin
		clk <= 1'b0;
		forever #(CLK_Period/2) clk <= ~clk;
	end
	
	initial begin
		// reset everything
		reset <= 1; read <= 0; write <= 0; inputBus <= 16'b0; @(posedge clk);
																				@(posedge clk);
		reset <= 0; @(posedge clk);
						@(posedge clk);
		
		// check reading before initializing anything returns nothing
		read <= 1; @(posedge clk);
		read <= 0; @(posedge clk);
		
		// write some number in
		write <= 1; inputBus <= 16'b1111; @(posedge clk);
		write <= 0; @(posedge clk);
		
		@(posedge clk);
		
		// take that number out
		read <= 1; @(posedge clk);
		read <= 0; @(posedge clk);
		
		// reset
		reset <= 1; @(posedge clk);
						@(posedge clk);
		reset <= 0; @(posedge clk);
						@(posedge clk);
		
		// with an empty fifo, write a number of words over the maximum.
		// this implementation replaces the least recent entry when written while full
		for (int i = 0; i < 32; i++) begin
			inputBus <= i; write <= 1; @(posedge clk);
			write <= 0;						@(posedge clk);
		end
		
		// read and empty out the entire fifo
		write <= 0; read <= 1;
		for (int i = 0; i < 8; i++) begin
			inputBus <= i; @(posedge clk);
		end
		
		// pull one more time to make sure it's empty
		@(posedge clk);
		read <= 0; @(posedge clk);
		
		// add a value and reset to check if reset works
		write <= 1; inputBus <= 16'b1111; @(posedge clk);
		write <= 0; @(posedge clk);
		reset <= 1; @(posedge clk);
						@(posedge clk);
		reset <= 0; @(posedge clk);
						@(posedge clk);
		
		$stop;
	end
	
endmodule 