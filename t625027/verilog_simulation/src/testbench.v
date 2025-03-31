`timescale 1ns/1ps

module dual_port_sram_tb;
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 10;
    parameter MEM_DEPTH  = 1 << ADDR_WIDTH;

    reg clk_a, clk_b;
    reg we_a, we_b;
    reg [ADDR_WIDTH-1:0] addr_a, addr_b;
    reg [DATA_WIDTH-1:0] din_a, din_b;
    wire [DATA_WIDTH-1:0] dout_a, dout_b;

    // Instantiate the dual-port SRAM module
    dual_port_sram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk_a(clk_a),
        .we_a(we_a),
        .addr_a(addr_a),
        .din_a(din_a),
        .dout_a(dout_a),
        .clk_b(clk_b),
        .we_b(we_b),
        .addr_b(addr_b),
        .din_b(din_b),
        .dout_b(dout_b)
    );

    // Clock generation
    always #5 clk_a = ~clk_a;
    always #7 clk_b = ~clk_b;

initial begin
        $dumpfile("output/dual_port_sram_tb.vcd");
        $dumpvars(0, dual_port_sram_tb);
    end
    initial begin
        // Initialize signals
        clk_a = 0; clk_b = 0;
        we_a = 0; we_b = 0;
        addr_a = 0; addr_b = 0;
        din_a = 0; din_b = 0;

        // Write to Port A
        #10;
        we_a = 1; addr_a = 10; din_a = 32'hA5A5A5A5;
        #10;
        we_a = 0;

        // Read from Port A
        #10;
        addr_a = 10;
        #10;
        $display("Read from Port A: %h", dout_a);

        // Write to Port B at the same address as Port A
        #10;
        we_b = 1; addr_b = 10; din_b = 32'h5A5A5A5A;
        #20;
        we_b = 0;

        // Read from Port B
        #20;
        addr_b = 10;
        #20;
        $display("Read from Port B: %h", dout_b);

        // Test read-after-write forwarding
        #20;
        we_a = 1; addr_a = 20; din_a = 32'hDEADBEEF;
        we_b = 1; addr_b = 20; din_b = 32'hFEEDFACE;
        #20;
        we_a = 0; we_b = 0;

        addr_a = 20;
        addr_b = 20;
        #10;
        $display("Read from Port A after write conflict: %h", dout_a);
        $display("Read from Port B after write conflict: %h", dout_b);

        // End simulation
        #20;
        $finish;
    end
endmodule