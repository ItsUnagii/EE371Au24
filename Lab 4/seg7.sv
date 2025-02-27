// Aidan Lee, Aarin Wen
// 10/18/2024
// EE 371
// Lab 2

// Converts decimal number to 7-segment display in HEX
// input bcd represents decimal number up to 15 (4 bits)
// output leds represents binary output for 7-seg display (7 bits)

module seg7 (bcd, leds);
	input logic [3:0] bcd;
	output logic [6:0] leds;
	
	// decimal to 7-seg block
	always_comb begin
		case (bcd)
			// Light:			 6543210
			4'b0000: leds = 7'b1000000; // 0
			4'b0001: leds = 7'b1111001; // 1
			4'b0010: leds = 7'b0100100; // 2
			4'b0011: leds = 7'b0110000; // 3
			4'b0100: leds = 7'b0011001; // 4
			4'b0101: leds = 7'b0010010; // 5
			4'b0110: leds = 7'b0000010; // 6
			4'b0111: leds = 7'b1111000; // 7
			4'b1000: leds = 7'b0000000; // 8
			4'b1001: leds = 7'b0010000; // 9
			4'b1010: leds = 7'b0001000; // A
			4'b1011: leds = 7'b0000011; // B
			4'b1100: leds = 7'b1000110; // C
			4'b1101: leds = 7'b0100001; // D
			4'b1110: leds = 7'b0000110; // E
			4'b1111: leds = 7'b0001110; // F
			default: leds = 7'bX;
		endcase
	end
endmodule

// seg7 testbench:
module seg7_testbench();
	logic [3:0] bcd;
	logic [6:0] leds;
	
	//dut instantiation
	seg7 dut (bcd, leds);
	
	int i;
	initial begin
		// increment inputs 0 to 15, expect outputs 0 to F
		for (i = 0; i <= 15; i++) begin
			bcd = i; #50;
		end
		
		// decrement inputs 15 to 0, expect outputs F to 0
		for (i = 15; i >= 0; i--) begin
			bcd = i; #50;
		end
		
		$stop;
	end 
	
endmodule  