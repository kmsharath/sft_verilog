`timescale 1ns / 1ps

module acc_pipeline_tb;

    reg clk;
    reg reset;
    reg [15:0] vehicle_speed;
    reg [15:0] lead_vehicle_speed;
    reg [15:0] distance_to_lead;
    wire [7:0] throttle_out;
    wire [7:0] brake_out;

    // Instantiate the ACC pipeline module
    acc_pipeline uut (
        .clk(clk),
        .reset(reset),
        .vehicle_speed(vehicle_speed),
        .lead_vehicle_speed(lead_vehicle_speed),
        .distance_to_lead(distance_to_lead),
        .throttle_out(throttle_out),
        .brake_out(brake_out)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        vehicle_speed = 0;
        lead_vehicle_speed = 0;
        distance_to_lead = 0;
        
        // Apply reset
        #20;
        reset = 0;
        
        // Test Case 1: Normal cruising
        vehicle_speed = 60;
        lead_vehicle_speed = 60;
        distance_to_lead = 100;
        #50;
        
        // Test Case 2: Lead vehicle slows down, closer distance
        vehicle_speed = 60;
        lead_vehicle_speed = 50;
        distance_to_lead = 50;
        #50;
        
        // Test Case 3: Lead vehicle far away, need acceleration
        vehicle_speed = 50;
        lead_vehicle_speed = 70;
        distance_to_lead = 120;
        #50;
        
        // Test Case 4: Emergency braking required
        vehicle_speed = 80;
        lead_vehicle_speed = 50;
        distance_to_lead = 40;
        #50;

        // Test Case 5: Safe distance, no action needed
        vehicle_speed = 60;
        lead_vehicle_speed = 60;
        distance_to_lead = 90;
        #50;
        
        // Finish simulation
        $finish;
    end
initial begin
        $dumpfile("output/acc_pipeline_tb.vcd");
        $dumpvars(0, acc_pipeline_tb);
    end


endmodule
