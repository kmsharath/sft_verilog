module two_stage_sync (
    input  wire clk_a,
    input  wire rst_a,
    input  wire signal_a,
    input  wire clk_b,
    input  wire rst_b,
    output reg  signal_b
);

    reg signal_a_ff;
    reg sync_1, sync_2;

    // Sending domain (clk_a)
    always @(posedge clk_a or posedge rst_a) begin
        if (rst_a)
            signal_a_ff <= 0;
        else
            signal_a_ff <= signal_a;
    end

    // Receiving domain (clk_b) with two-stage flip-flop synchronization
    always @(posedge clk_b or posedge rst_b) begin
        if (rst_b) begin
            sync_1 <= 0;
            sync_2 <= 0;
            signal_b <= 0;
        end else begin
            sync_1 <= signal_a_ff;  // First stage
            sync_2 <= sync_1;       // Second stage
            signal_b <= sync_2;
        end
    end

endmodule
