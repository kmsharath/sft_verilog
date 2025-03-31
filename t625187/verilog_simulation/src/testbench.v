`timescale 1ns / 1ps

module tb_pipelined_multiplier_3stage;
    
    // Testbench Signals
    reg clk;
    reg reset;
    reg [7:0] a, b;
    wire [15:0] product;
    
    // Instantiate the DUT (Device Under Test)
    pipelined_multiplier_3stage uut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .product(product)
    );
    
    // Clock Generation (10 ns period -> 100 MHz)
    always #5 clk = ~clk;
    
    
initial begin
        $dumpfile("output/tb_pipelined_multiplier_3stage.vcd");
        $dumpvars(0, tb_pipelined_multiplier_3stage);
    end
    // Test Procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        a = 0;
        b = 0;
        
        // Hold reset for a few clock cycles
        #10;
        reset = 0;
        
        // Apply test vectors
        #10; a = 8'd10; b = 8'd5;    // 10 * 5  = 50
        #10; a = 8'd3;  b = 8'd7;    // 3  * 7  = 21
        #10; a = 8'd15; b = 8'd15;   // 15 * 15 = 225
        #10; a = 8'd25; b = 8'd12;   // 25 * 12 = 300
        #10; a = 8'd8;  b = 8'd20;   // 8  * 20 = 160
        
        // Wait for pipeline to propagate results
        #50;
        
        // Finish simulation
        $finish;
    end
    
    // Monitor output
    initial begin
        $monitor("Time: %0t | a: %d, b: %d, product: %d", $time, a, b, product);
    end
    
endmodule
