module matrix_multiplier_4x4 (
    input clk,
    input rst,
    input start,
    input [7:0] A [0:3][0:3],  // 4x4 input matrix A
    input [7:0] B [0:3][0:3],  // 4x4 input matrix B
    output reg [15:0] C 
    [0:3][0:3], // 4x4 result matrix C = A x B
    output reg done
);

    integer i, j, k;
    reg [2:0] state;
    reg [15:0] temp [0:3][0:3];

    localparam IDLE = 0,
               LOAD = 1,
               MULT = 2,
               DONE = 3;

    reg [1:0] row, col;
    reg [2:0] step;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            row <= 0;
            col <= 0;
            step <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        done <= 0;
                        row <= 0;
                        col <= 0;
                        step <= 0;
                        for (i = 0; i < 4; i = i + 1)
                            for (j = 0; j < 4; j = j + 1)
                                temp[i][j] <= 0;
                        state <= MULT;
                    end
                end
                MULT: begin
                    temp[row][col] <= temp[row][col] + A[row][step] * B[step][col];
                    if (step == 3) begin
                        step <= 0;
                        if (col == 3) begin
                            col <= 0;
                            if (row == 3) begin
                                state <= DONE;
                            end else begin
                                row <= row + 1;
                            end
                        end else begin
                            col <= col + 1;
                        end
                    end else begin
                        step <= step + 1;
                    end
                end
                DONE: begin
                    for (i = 0; i < 4; i = i + 1)
                        for (j = 0; j < 4; j = j + 1)
                            C[i][j] <= temp[i][j];
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule