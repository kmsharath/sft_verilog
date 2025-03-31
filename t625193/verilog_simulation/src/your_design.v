module acc_pipeline (
    input clk,
    input reset,
    input [15:0] vehicle_speed,
    input [15:0] lead_vehicle_speed,
    input [15:0] distance_to_lead,
    output reg [7:0] throttle_out,
    output reg [7:0] brake_out
);

    // Stage 1: Sensor Input Registers
    reg [15:0] s1_vehicle_speed, s1_lead_speed, s1_distance;

    // Stage 2: Relative Speed & Distance Evaluation
    reg signed [15:0] s2_rel_speed;
    reg [15:0] s2_distance;

    // Stage 3: Control Decision Logic
    reg s3_brake_cmd;
    reg s3_throttle_cmd;

    // Stage 4: Output Signal Generation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all pipeline registers
            s1_vehicle_speed <= 0; s1_lead_speed <= 0; s1_distance <= 0;
            s2_rel_speed <= 0; s2_distance <= 0;
            s3_brake_cmd <= 0; s3_throttle_cmd <= 0;
            throttle_out <= 0; brake_out <= 0;
        end else begin
            // Stage 1: Sensor data latch
            s1_vehicle_speed <= vehicle_speed;
            s1_lead_speed <= lead_vehicle_speed;
            s1_distance <= distance_to_lead;

            // Stage 2: Relative speed calc
            s2_rel_speed <= $signed(s1_vehicle_speed) - $signed(s1_lead_speed);
            s2_distance <= s1_distance;

            // Stage 3: Predictive Control Logic
            if (s2_distance < 60 && s2_rel_speed > 10) begin
                s3_brake_cmd <= 1;
                s3_throttle_cmd <= 0;
            end else if (s2_distance > 110 && s2_rel_speed < -10) begin
                s3_brake_cmd <= 0;
                s3_throttle_cmd <= 1;
            end else begin
                s3_brake_cmd <= 0;
                s3_throttle_cmd <= 0;
            end

            // Stage 4: Actuator signal output
            if (s3_brake_cmd) begin
                brake_out <= 8'd255;
                throttle_out <= 8'd0;
            end else if (s3_throttle_cmd) begin
                throttle_out <= 8'd180;
                brake_out <= 8'd0;
            end else begin
                throttle_out <= 8'd100; // cruising value
                brake_out <= 8'd0;
            end
        end
    end
endmodule