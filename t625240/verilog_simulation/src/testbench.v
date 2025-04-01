module tb_pipelined_alu;

    parameter WIDTH = 16;

    reg  clk, rst;
    reg  [WIDTH-1:0] a, b;
    reg  [3:0] op;
    wire [WIDTH-1:0] result;
    wire overflow, underflow, invalid_op, is_equal, is_less;

    // DUT instance
    pipelined_alu #(.WIDTH(WIDTH)) dut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .overflow(overflow),
        .underflow(underflow),
        .invalid_op(invalid_op),
        .is_equal(is_equal),
        .is_less(is_less)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("output/tb_pipelined_alu.vcd");
        $dumpvars(0, tb_pipelined_alu);

        // Initialize
        clk = 0;
        rst = 1;
        a = 0;
        b = 0;
        op = 0;
        #10;

        rst = 0;

        // ADD
        a = 100; b = 200; op = 4'b0000;
        #10 $display("ADD: %0d + %0d = %0d, Overflow: %b", a, b, result, overflow);

        // SUB
        a = 50; b = 80; op = 4'b0001;
        #10 $display("SUB: %0d - %0d = %0d, Underflow: %b", a, b, result, underflow);

        // AND
        a = 16'hFF00; b = 16'h0F0F; op = 4'b0010;
        #10 $display("AND: %h & %h = %h", a, b, result);

        // OR
        a = 16'hA5A5; b = 16'h5A5A; op = 4'b0011;
        #10 $display("OR : %h | %h = %h", a, b, result);

        // XOR
        a = 16'hAAAA; b = 16'hFFFF; op = 4'b0100;
        #10 $display("XOR: %h ^ %h = %h", a, b, result);

        // NOT
        a = 16'hF0F0; op = 4'b0101;
        #10 $display("NOT: ~%h = %h", a, result);

        // Shift Left
        a = 16'h0001; op = 4'b0110;
        #10 $display("SHL: %h << 1 = %h", a, result);

        // Shift Right
        a = 16'h8000; op = 4'b0111;
        #10 $display("SHR: %h >> 1 = %h", a, result);

        // Compare Equal
        a = 1234; b = 1234; op = 4'b1000;
        #10 $display("CMP EQ: %0d == %0d? %b", a, b, is_equal);

        // Compare Less Than
        a = 10; b = 50; op = 4'b1001;
        #10 $display("CMP LT: %0d < %0d? %b", a, b, is_less);

        // Invalid Op
        op = 4'b1111;
        #10 $display("Invalid Op Test: Invalid Flag = %b", invalid_op);

        $finish;
    end

endmodule