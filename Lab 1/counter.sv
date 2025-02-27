// Aidan Lee
// 10/04/2024
// EE 371
// Lab 1

// Counter that caps out from 0 to 25, and also updates hex display accordingly
// input inc represents the counter needing to be incremented by 1
// input dec represents the counter needing to be decremented by 1
// outputs all 6 FPGA HEX display

module counter(clk, reset, inc, dec, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

    input  logic clk, reset, inc, dec;
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    
    logic [4:0] count;
    
    logic [3:0] disp0, disp1;
    logic [1:0] disp2, disp3, disp4, disp5; 
    
    always_ff @(posedge clk) begin
        if (reset) begin
            count = 5'b0;
            disp0 = 4'b0;
            disp1 = 4'b1111;
            disp2 = 2'b0;
            disp3 = 2'b0;
            disp4 = 2'b0;
            disp5 = 2'b0;
        end
        
        // if full, sets HEXs 2-5 to FULL
		if(count == 5'd5) begin // switch 25 or 5 if demoing
			disp2 = 2'b11;
			disp3 = 2'b11;
			disp4 = 2'b11;
			disp5 = 2'b11;
		end
		else if(count == 5'b00000) begin // if 0, sets Hexs 1-5 to CLEAR
			disp1 = 4'b1111;
			disp2 = 2'b00;
			disp3 = 2'b00;
			disp4 = 2'b00;
			disp5 = 2'b00;
		end
		else begin // else sets hexs 2-5 to off
			if(disp1 == 4'b1111) 
				disp1 = 4'b0000;// if this digit is 'R', sets it to 0
			disp2 = 2'b01;
			disp3 = 2'b01;
			disp4 = 2'b01;
			disp5 = 2'b01;
		end
        
        if (inc) begin
			// increments count if not full
			if(count != 5'd5) begin // full if count == 25 or 5 (switch if demoing)
				count = count + 1'b1;
			    
				disp0 = disp0 + 1'b1;
				
				if (disp0 == 4'd10) begin
				 	disp1 = disp1 + 1'b1;
				 	disp0 = 4'b0000;
				end
			end
		end
		
		// creates the logic for when dec is true
		else if (dec) begin
			if(count != 5'd0) begin
				count = count - 1'b1;
				
				if (disp0 == 4'd0) begin 
					disp1 = disp1 - 1'b1;
					disp0 = 4'd10; 
				end
					
				disp0 = disp0 - 1'b1;
			end
		end
		
		
		// case statements start here
		// for HEX0:
		case(disp0)
		 4'b0000: HEX0 = ~(7'b1111110); // 0 
		 4'b0001: HEX0 = ~(7'b0110000); // 1 
		 4'b0010: HEX0 = ~(7'b1101101); // 2 
		 4'b0011: HEX0 = ~(7'b1111001); // 3 
		 4'b0100: HEX0 = ~(7'b0110011); // 4 
		 4'b0101: HEX0 = ~(7'b1011011); // 5 
		 4'b0110: HEX0 = ~(7'b1011111); // 6 
		 4'b0111: HEX0 = ~(7'b1110000); // 7 
		 4'b1000: HEX0 = ~(7'b1111111); // 8 
		 4'b1001: HEX0 = ~(7'b1111011); // 9
		 4'b1111: HEX0 = ~(7'b0000000); // nothing?
		 default: HEX0 = ~(7'b0000000); 
		endcase
		
		// case statement to set values for HEX1
		case(disp1)
		 4'b0000: HEX1 = ~(7'b1111110); // 0
		 4'b0001: HEX1 = ~(7'b0110000); // 1 
		 4'b0010: HEX1 = ~(7'b1101101); // 2 
		 4'b0011: HEX1 = ~(7'b1111001); // 3 
		 4'b0100: HEX1 = ~(7'b0110011); // 4 
		 4'b0101: HEX1 = ~(7'b1011011); // 5 
		 4'b0110: HEX1 = ~(7'b1011111); // 6 
		 4'b0111: HEX1 = ~(7'b1110000); // 7 
		 4'b1000: HEX1 = ~(7'b1111111); // 8 
		 4'b1001: HEX1 = ~(7'b1111011); // 9  
		 4'b1111: HEX1 = ~(7'b1000110); // CLEA'R'
		 default: HEX1 = ~(7'b0000000);
		endcase
		
		// case statement to set values for HEX2
		case(disp2)
		 2'b00: HEX2 = ~(7'b1110111); // CLE'A'R 
		 2'b11: HEX2 = ~(7'b0001110); // FUL'L'
		 default: HEX2 = ~(7'b0000000); 
		endcase
		
		// case statement to set values for HEX3
		case(disp3)
		 2'b00: HEX3 = ~(7'b1001111); // CL'E'AR 
		 2'b11: HEX3 = ~(7'b0001110); // FU'L'L
		 default: HEX3 = ~(7'b0000000); 
		endcase
		
		// case statement to set values for HEX4
		case(disp4)
		 2'b00: HEX4 = ~(7'b0001110); // C'L'EAR
		 2'b11: HEX4 = ~(7'b0111110); // F'U'LL
		 default: HEX4 = ~(7'b0000000); 
		endcase
		
		// case statement to set values for HEX5
		case(disp5)
		 2'b00: HEX5 = ~(7'b1001110); // 'C'LEAR
		 2'b11: HEX5 = ~(7'b1000111); // 'F'ULL
		 default: HEX5 = ~(7'b0000000); 
		endcase
    end

endmodule






module counter_testbench ();
  
  logic clk, reset;
  logic inc, dec;
  logic [4:0] out;

  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  counter dut (.clk, .reset, .inc, .dec, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);

  parameter CLOCK_PERIOD = 10;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

  integer i;
  initial begin
    reset <= 1; @(posedge clk);
    reset <= 0; @(posedge clk);
    inc <= 1;
    for (i = 1; i <= 26; i++) begin // increase to 26, should stop at 25
        @(posedge clk);
    end
    inc <= 0; dec <= 1;
    for (i = 1; i <= 26; i++) begin // same for decreases
        @(posedge clk);
    end
	@(posedge clk);
    inc <= 1; @(posedge clk);
    @(posedge clk);
    $stop();
  end
endmodule