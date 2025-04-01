module dynamic_clock_gating (
    input wire clk,          // Main clock input
    input wire reset_n,      // Active-low reset
    input wire activity,     // Activity signal (1 = active, 0 = idle)
    output wire gated_clk     // Gated clock output
);

    reg enable;              // Clock enable register

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            enable <= 1'b0;
            
        end else begin
            // Update enable based on activity signal
            enable <= activity;       
        end
    end
assign gated_clk=(enable)?clk:0;
endmodule