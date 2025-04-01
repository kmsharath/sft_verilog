`timescale 1ns/1ps

module tb_dynamic_clock_gating();
    // Inputs
    reg clk;
    reg reset_n;
    reg activity;
    
    // Outputs
    wire gated_clk;
    
    // Instantiate the Unit Under Test (UUT)
    dynamic_clock_gating uut (
        .clk(clk),
        .reset_n(reset_n),
        .activity(activity),
        .gated_clk(gated_clk)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock (10ns period)
    end
    
    // Main test sequence
    initial begin
        // Initialize inputs
        reset_n = 0;
        activity = 0;
        
        // System reset
        #20;
        reset_n = 1;
        
        // Test 1: Verify clock gating when inactive
        $display("[%0t] Test 1: Clock gating when inactive", $time);
        activity = 0;
        #50;
        if (gated_clk !== 0)
            $error("Clock not gated when inactive");
        
        // Test 2: Verify clock enable when active
        $display("[%0t] Test 2: Clock enable when active", $time);
        activity = 1;
        #50;
        if (gated_clk !== clk)
            $error("Clock not enabled when active");
        
        // Test 3: Verify dynamic switching
        $display("[%0t] Test 3: Dynamic switching", $time);
        repeat (5) begin
            activity = ~activity;
            #30;
            // Verify gated_clk follows activity with 1 clock delay
            if (activity && (gated_clk !== clk))
                $error("Clock not enabled when activity high");
            if (!activity && (gated_clk !== 0))
                $error("Clock not gated when activity low");
        end
        
        // Test 4: Verify reset behavior
        $display("[%0t] Test 4: Reset behavior", $time);
        reset_n = 0;
        activity = 1; // Try to keep clock enabled during reset
        #20;
        if (gated_clk !== 0)
            $error("Clock not gated during reset");
        
        // Release reset and verify
        reset_n = 1;
        #10;
        if (gated_clk !== 0)
            $error("Clock not properly initialized after reset");
        
        // Final check
        activity = 1;
        #20;
        if (gated_clk !== clk)
            $error("Final enable check failed");
        
        $display("[%0t] All tests completed successfully", $time);
        $finish;
    end
    
    // Monitoring
    always @(posedge clk) begin
        $display("[%0t] CLK: %b, Activity: %b, Gated_CLK: %b", 
                $time, clk, activity, gated_clk);
    end
    
    // Waveform dumping (for visualization tools)
    initial begin
        $dumpfile("output/dynamic_clock_gating.vcd");
        $dumpvars(0, tb_dynamic_clock_gating);
    end
endmodule