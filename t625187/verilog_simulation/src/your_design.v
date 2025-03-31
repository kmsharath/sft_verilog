module pipelined_multiplier_3stage (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] product
);

    reg [7:0] a_reg1, b_reg1;
    reg [15:0] partial_result;
    reg [15:0] final_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            a_reg1        <= 8'd0;
            b_reg1        <= 8'd0;
            partial_result <= 16'd0;
            final_result  <= 16'd0;
            product       <= 16'd0;
        end else begin
            a_reg1 <= a;
            b_reg1 <= b;

            partial_result <= a_reg1 * b_reg1;

            final_result <= partial_result;
            product <= final_result;
        end
    end
endmodule
