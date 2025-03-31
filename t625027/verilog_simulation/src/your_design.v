module dual_port_sram #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,
    parameter MEM_DEPTH  = 1 << ADDR_WIDTH
)(
    input wire                  clk_a,
    input wire                  we_a,
    input wire [ADDR_WIDTH-1:0] addr_a,
    input wire [DATA_WIDTH-1:0] din_a,
    output reg [DATA_WIDTH-1:0] dout_a,

    input wire                  clk_b,
    input wire                  we_b,
    input wire [ADDR_WIDTH-1:0] addr_b,
    input wire [DATA_WIDTH-1:0] din_b,
    output reg [DATA_WIDTH-1:0] dout_b
);

    // Memory declaration
    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Port A
    always @(posedge clk_a) begin
        if (we_a)
            mem[addr_a] <= din_a;

        // Handle read-after-write coherency
        if (we_b && addr_b == addr_a && !we_a) begin
            // If Port B is writing to addr_a, and Port A is reading it
            dout_a <= din_b; // Forwarding
        end else begin
            dout_a <= mem[addr_a];
        end
    end

    // Port B
    always @(posedge clk_b) begin
        if (we_b)
            mem[addr_b] <= din_b;

        // Handle read-after-write coherency
        if (we_a && addr_a == addr_b && !we_b) begin
            dout_b <= din_a;
        end else begin
            dout_b <= mem[addr_b];
        end
    end

endmodule
