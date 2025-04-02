`timescale 1ns / 1ps

module tb_matrix_multiplier_4x4;

    reg clk;
    reg rst;
    reg start;
    reg [7:0] A [0:3][0:3];
    reg [7:0] B [0:3][0:3];
    wire [15:0] C [0:3][0:3];
    wire done;

    // Instantiate the DUT
    matrix_multiplier_4x4 dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A),
        .B(B),
        .C(C),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    integer i, j;

    initial begin
        // Initialize clock, reset
        clk = 0;
        rst = 1;
        start = 0;

        // Wait then deassert reset
        #10;
        rst = 0;

        // Initialize matrices A and B
        // A = Identity matrix
        A[0][0] = 1; A[0][1] = 0; A[0][2] = 0; A[0][3] = 0;
        A[1][0] = 0; A[1][1] = 1; A[1][2] = 0; A[1][3] = 0;
        A[2][0] = 0; A[2][1] = 0; A[2][2] = 1; A[2][3] = 0;
        A[3][0] = 0; A[3][1] = 0; A[3][2] = 0; A[3][3] = 1;

        // B = Some values
        B[0][0] = 1; B[0][1] = 2; B[0][2] = 3; B[0][3] = 4;
        B[1][0] = 5; B[1][1] = 6; B[1][2] = 7; B[1][3] = 8;
        B[2][0] = 9; B[2][1] = 10; B[2][2] = 11; B[2][3] = 12;
        B[3][0] = 13; B[3][1] = 14; B[3][2] = 15; B[3][3] = 16;

        // Apply start
        #10;
        start = 1;
        #10;
        start = 0;

        // Wait for done signal
        wait(done);

        // Display output
        $display("Matrix C = A x B:");
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                $write("%0d\t", C[i][j]);
            end
            $write("\n");
        end

        $finish;
    end
 // Dump waveforms
 initial begin
        $dumpfile("output/tb_matrix_multiplier_4x4.vcd");
        $dumpvars(0, tb_matrix_multiplier_4x4);
end
endmodule