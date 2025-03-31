module ArithmeticUnit #(
parameter WIDTH = 8  // Parameterized operand width
)(
input  wire [WIDTH-1:0] a,
input  wire [WIDTH-1:0] b,
input  wire [1:0] op,  // 00: add, 01: subtract, 10: multiply
output reg  [2*WIDTH-1:0] result
);

always @(*) begin
    case (op)
        2'b00: result = a + b;            // Addition
        2'b01: result = a - b;            // Subtraction
        2'b10: result = a * b;            // Multiplication
        default: result = {2*WIDTH{1'b0}};
    endcase
end
endmodule 