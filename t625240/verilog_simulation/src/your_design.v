module pipelined_alu #(
    parameter WIDTH = 16
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire [WIDTH-1:0]      a,
    input  wire [WIDTH-1:0]      b,
    input  wire [3:0]            op,         // 4-bit opcode
    output reg  [WIDTH-1:0]      result,
    output reg                   overflow,
    output reg                   underflow,
    output reg                   invalid_op,
    output reg                   is_equal,
    output reg                   is_less
);

    reg [WIDTH:0] extended;  // For detecting overflow

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result     <= 0;
            overflow   <= 0;
            underflow  <= 0;
            invalid_op <= 0;
            is_equal   <= 0;
            is_less    <= 0;
        end else begin
            // Reset exception flags
            overflow   <= 0;
            underflow  <= 0;
            invalid_op <= 0;
            is_equal   <= 0;
            is_less    <= 0;

            case (op)
                4'b0000: begin // ADD
                    extended  = a + b;
                    result    <= extended[WIDTH-1:0];
                    overflow  <= extended[WIDTH];
                end
                4'b0001: begin // SUB
                    extended  = a - b;
                    result    <= extended[WIDTH-1:0];
                    underflow <= (a < b);
                end
                4'b0010: result <= a & b;         // AND
                4'b0011: result <= a | b;         // OR
                4'b0100: result <= a ^ b;         // XOR
                4'b0101: result <= ~a;            // NOT (on a)
                4'b0110: result <= a << 1;        // Shift Left
                4'b0111: result <= a >> 1;        // Shift Right
                4'b1000: is_equal <= (a == b);    // Compare Equal
                4'b1001: is_less  <= (a < b);     // Compare Less Than
                default: begin
                    result     <= 0;
                    invalid_op <= 1;
                end
            endcase
        end
    end

endmodule