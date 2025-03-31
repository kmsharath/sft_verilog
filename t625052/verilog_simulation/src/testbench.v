module tb_ArithmeticUnit;

  // Testbench Parameters
  parameter WIDTH = 8;

  // Testbench Signals
  reg [WIDTH-1:0] a, b;
  reg [1:0] op;
  wire [2*WIDTH-1:0] result;

  // Instantiate the ArithmeticUnit
  ArithmeticUnit #(
    .WIDTH(WIDTH)
  ) uut (
    .a(a),
    .b(b),
    .op(op),
    .result(result)
  );

  // Generate a clock signal (if needed, can be omitted for this combinational design)
  // reg clk;
  // initial clk = 0;
  // always #5 clk = ~clk;  // Clock period 10 time units (for sequential logic)

  // Test stimulus
  initial begin
    // Dump waveforms to a VCD file for simulation
    $dumpfile("output/ArithmeticUnit.vcd");
    $dumpvars(0, tb_ArithmeticUnit);

    // Test case 1: Addition
    a = 8'b00001111; b = 8'b00000001; op = 2'b00;
    #10; // Wait for 10 time units

    // Test case 2: Subtraction
    a = 8'b00001111; b = 8'b00000001; op = 2'b01;
    #10; // Wait for 10 time units

    // Test case 3: Multiplication
    a = 8'b00000011; b = 8'b00000010; op = 2'b10;
    #10; // Wait for 10 time units

    // Test case 4: Default case (invalid op)
    a = 8'b00001111; b = 8'b00000001; op = 2'b11;
    #10; // Wait for 10 time units

    // Finish the simulation
    $finish;
  end

endmodule
