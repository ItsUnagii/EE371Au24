// Aidan Lee
// 10/04/2024
// EE 371
// Lab 1

// Top level module for lab 1

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, V_GPIO);
    input CLOCK_50;
    inout logic [35:0] V_GPIO;
    // ports 23-24 and 28-30 are inputs
    // ports 26-27 and 31-35 are outputs
    
    output logic [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    
    logic clk, reset;
    assign clk = CLOCK_50;
    assign reset = V_GPIO[23];
    
    assign V_GPIO[27] = V_GPIO[24];
    assign V_GPIO[31] = V_GPIO[28];

    logic a, b, exit, enter;
    logic inc, dec;
    assign a = V_GPIO[27];
    assign b = V_GPIO[31];
    
    logic [4:0] full_count;
    
    car_detect sensors (.clk, .reset, .a, .b, .exit, .enter);
    
    counter counting (.clk, .reset, .inc(enter), .dec(exit), .HEX0, .HEX1, 
                      .HEX2, .HEX3, .HEX4, .HEX5);
    
    // seven_segment digit0 (full_count[3:0], HEX0, 1); 
    // seven_segment digit1 (full_count[ 4 ], HEX1, full_count[ 4 ]);
    
endmodule