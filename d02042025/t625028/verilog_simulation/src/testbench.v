
`timescale 1ns/1ps

module two_stage_sync_tb;
    
    reg clk_a, rst_a, signal_a;
    reg clk_b, rst_b;
    wire signal_b;
    
    // Instantiate the DUT (Device Under Test)
    two_stage_sync dut (
        .clk_a(clk_a),
        .rst_a(rst_a),
        .signal_a(signal_a),
        .clk_b(clk_b),
        .rst_b(rst_b),
        .signal_b(signal_b)
    );
    
    // Clock generation
    always #5  clk_a = ~clk_a; // 10 ns period
    always #7  clk_b = ~clk_b; // 14 ns period (asynchronous to clk_a)
    initial begin
        $dumpfile("output/two_stage_sync_tb.vcd");
        $dumpvars(0, two_stage_sync_tb);
    end

    initial begin
        // Initialize signals
        clk_a = 0; clk_b = 0;
        rst_a = 1; rst_b = 1;
        signal_a = 0;
        
        // Apply reset
        #20 rst_a = 0;
        #20 rst_b = 0;
        
        // Apply test stimulus
        #30 signal_a = 1;  // Set signal_a high
        #20 signal_a = 0;  // Set signal_a low
        #40 signal_a = 1;  // Set signal_a high again
        #20 signal_a = 0;  // Set signal_a low again
        
        // Finish simulation
        #100 $finish;
    end
    
    // Monitor outputs
    initial begin
        $monitor("%t: signal_a=%b, signal_b=%b", $time, signal_a, signal_b);
    end
    
endmodule
