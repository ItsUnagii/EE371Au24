
// Aidan Lee, Aarin Wen
// 10/18/2024
// EE 371
// Lab 2

// FIFO control module with parameterized depth
// utilizes clock and reset signals
// input wr to write data, input read to read data
// outputs empty and full flags indicate FIFO status of empty or full
// output r_addr and w_addr represent read and write address pointers

module fifo_ctrl #(parameter ADDR_WIDTH=3)
                 (clk, reset, rd, wr, empty, full, w_addr, r_addr);
	
	input  logic clk, reset, rd, wr;
	output logic empty, full;
	output logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	
	// pointer declarations
	logic [ADDR_WIDTH-1:0] rd_ptr, rd_ptr_next;
	logic [ADDR_WIDTH-1:0] wr_ptr, wr_ptr_next;
	logic empty_next, full_next;
	
	// outputs (assign to pointer locations)
	assign w_addr = wr_ptr;
	assign r_addr = rd_ptr;
	
	// fifo controller logic
	always_ff @(posedge clk) begin
		if (reset)
			begin
				wr_ptr <= 0;
				rd_ptr <= 0;
				full   <= 0;
				empty  <= 1;
			end
		else
			begin
				wr_ptr <= wr_ptr_next;
				rd_ptr <= rd_ptr_next;
				full   <= full_next;
				empty  <= empty_next;
			end
	end  // always_ff
	
	// next state logic
	always_comb begin
		// always default to current values
		rd_ptr_next = rd_ptr;
		wr_ptr_next = wr_ptr;
		empty_next = empty;
		full_next = full;
		case ({rd, wr})
			2'b11:  // read and write
				begin
					rd_ptr_next = rd_ptr + 1'b1;
					wr_ptr_next = wr_ptr + 1'b1;
				end
			2'b10:  // read
				if (~empty)
					begin
						rd_ptr_next = rd_ptr + 1'b1;
						if (rd_ptr_next == wr_ptr)
							empty_next = 1;
						full_next = 0;
					end
			2'b01:  // write
				if (~full)
					begin
						wr_ptr_next = wr_ptr + 1'b1;
						empty_next = 0;
						if (wr_ptr_next == rd_ptr)
							full_next = 1;
					end
				else
					begin
						rd_ptr_next = rd_ptr + 1'b1;
						wr_ptr_next = wr_ptr + 1'b1;
					end
			2'b00: ; // no change, do nothing
		endcase
	end  // always_comb
	
endmodule  // fifo_ctrl

module fifo_ctrl_tb();
	
	logic clk, reset, rd, wr;
	logic empty, full;
	logic [2:0] w_addr, r_addr;
	
	// Clock logic
	parameter CLOCK_PERIOD = 5; // Increase clock frequency
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	fifo_ctrl dut (.*);
	
	initial begin
		reset <= 1; wr <= 0; rd <= 0; @(posedge clk);
												@(posedge clk);
		reset <= 0; @(posedge clk);
						@(posedge clk);
		
		// try to read with nothing
		rd <= 1; @(posedge clk);
		rd <= 0; @(posedge clk);
		
		// test repeated writes
		// also try to write when full (should override oldest value)
		repeat (9) begin
			wr <= 1; @(posedge clk);
			wr <= 0; @(posedge clk);
		end
		// test repeated reads
		// and see what happens when you go over (should do nothing)
		repeat (9) begin
			rd <= 1; @(posedge clk);
			rd <= 0; @(posedge clk);
		end
		
		$stop;
	end
endmodule