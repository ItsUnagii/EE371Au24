// Aidan Lee
// 10/04/2024
// EE 371
// Lab 1

// FSM module that tracks if a car is entering or exiting by using two detectors
// input a represents the signal furthest from the lot being triggered
// input b represents the signal closest from the lot being triggered
// outputs "exit" and "enter" represent whether a car has entered or exited

module car_detect(clk, reset, a, b, exit, enter);    
    input  logic clk, reset, a, b;
    output logic exit, enter;
    
    // Explanation of states:
    // A: both sensors unblocked
    // B: sensor A blocked, sensor B unblocked
    // C: both blocked
    // D: B blocked, A unblocked
    enum {A, B, C, D} ps, ns;
    
    always_comb begin
        case (ps)
            A: if (a)       ns = B;  // 00 -> 10
               else if (b)  ns = D;  // 00 -> 01
               else         ns = A;  // 00 -> 00

            B: if (~a)      ns = A;  // 10 -> 00
               else if (b)  ns = C;  // 10 -> 11
               else         ns = B;  // 10 -> 10

            C: if (~a)      ns = D;  // 11 -> 01
               else if (~b) ns = B;  // 11 -> 10
               else         ns = C;  // 11 -> 11

            D: if (a)       ns = C;  // 01 -> 11
               else if (~b) ns = A;  // 01 -> 00
               else         ns = D;  // 01 -> 01
        endcase
    end
    
    assign enter = (ps == D) & (ns == A);  // 01 -> 00
    assign exit  = (ps == B) & (ns == A);  // 10 -> 00
    
    always_ff @(posedge clk) begin
        if (reset) ps <= A;  // ps -> 00
        else       ps <= ns;
    end
    

endmodule

module car_detect_testbench ();
  
  logic clk, reset;
  logic a, b;
  logic exit, enter;

  car_detect dut (.clk, .reset, .a, .b, .exit, .enter);

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
  end

  initial begin
    reset <= 1;         @(posedge clk);
    reset <= 0;         @(posedge clk);
    // test entering
    a <= 0;   b <= 0;   @(posedge clk);
    a <= 1;             @(posedge clk);
              b <= 1;   @(posedge clk);
    a <= 0;             @(posedge clk);
              b <= 0;   @(posedge clk); // enter should equal 1
    // test exiting
              b <= 1;   @(posedge clk);
    a <= 1;             @(posedge clk);
              b <= 0;   @(posedge clk);
    a <= 0;             @(posedge clk); // exit should equal 1
    
	 @(posedge clk);
	 reset <= 1;         @(posedge clk);
    reset <= 0;         @(posedge clk);
	 @(posedge clk);
    $stop();
  end
endmodule