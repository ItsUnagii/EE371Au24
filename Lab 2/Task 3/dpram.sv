
// Aidan Lee, Aarin Wen
// 10/18/2024
// EE 371
// Lab 2

// Dual port ram module with specified data and address widths for use in the FIFO in task 3
// Asynchronous read port, synchronous write port

// utilizes clk input
// input  w_data 					represents the value about to be written into the ram
// input  w_en						determines if the data from w_data should be written into the ram
// input  w_addr and r_addr	determines where the data should be written or read from
// output r_data					represents the output value read out from the ram
 
module dpram #(parameter DATA_WIDTH=16, ADDR_WIDTH=3)
                (clk, w_data, w_en, w_addr, r_addr, r_data);

	input  logic clk, w_en;
	input  logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	input  logic [DATA_WIDTH-1:0] w_data;
	output logic [DATA_WIDTH-1:0] r_data;
	
	// array declaration (registers)
	logic [DATA_WIDTH-1:0] array_reg [0:(2**ADDR_WIDTH)-1];
	
	// write operation (synchronous)
	always_ff @(posedge clk)
	   if (w_en)
		   array_reg[w_addr] <= w_data;
	
	// read operation (asynchronous)
	assign r_data = array_reg[r_addr];
	
endmodule  // dpram

module dpram_tb();
	
	logic clk, w_en;
	logic [2:0]  w_addr, r_addr;
	logic [15:0] w_data, r_data;
	
	// Clock logic
	parameter CLOCK_PERIOD = 20; // Increase clock frequency
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	dpram dut (.*);
	
	initial begin
		// reset
		w_en <= 0; w_addr <= 3'b0; r_addr <= 3'b0; w_data <= 16'b0; @(posedge clk);
		
		// put something in write data. shouldn't immediately be read
		w_data <= 16'b1; @(posedge clk);
		
		// write in. read address should change
		w_en <= 1; @(posedge clk);
		
		// read a different address. should be different
		w_en <= 0; r_addr <= 3'b1; @(posedge clk);
		
		// check that its still there
		r_addr <= 3'b0; @(posedge clk);
		
		// check writing to different location
		w_en <= 1; w_addr <= 3'd5; r_addr <= 3'd5; w_data <= 16'd5; @(posedge clk);
		
		$stop;
	end
endmodule
