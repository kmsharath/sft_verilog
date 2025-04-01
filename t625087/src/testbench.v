`timescale 1ns / 1ps

module tb_CachePrefetch();
    parameter CACHE_SIZE = 16;
    parameter BLOCK_SIZE = 4;
    parameter ADDR_WIDTH = 8;

    reg clk, reset, read_enable;
    reg [ADDR_WIDTH-1:0] addr;
    wire hit;
    wire [31:0] data_out;
    integer i,j;
    // Instantiate the DUT
    CachePrefetch #(
        .CACHE_SIZE(CACHE_SIZE),
        .BLOCK_SIZE(BLOCK_SIZE),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .read_enable(read_enable),
        .addr(addr),
        .hit(hit),
        .data_out(data_out)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
initial begin
        $dumpfile("output/ tb_CachePrefetch.vcd");
        $dumpvars(0,  tb_CachePrefetch);
    end


    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        read_enable = 0;
        addr = 0;
        #20;

        // Release reset
        reset = 0;
        #10;

        // Test 1: Cache miss followed by prefetch
        $display("Test 1: Cache miss and prefetch");
        read_enable = 1;
        addr = 8'h10;
        #10;
        if (hit === 0) $display("PASS: Cache miss for addr=0x%0h", addr);
        else $display("FAIL: Expected miss for addr=0x%0h", addr);
        #10;

        // Test 2: Cache hit (same address)
        $display("Test 2: Cache hit (same address)");
        addr = 8'h10;
        #10;
        if (hit === 1) $display("PASS: Cache hit for addr=0x%0h", addr);
        else $display("FAIL: Expected hit for addr=0x%0h", addr);
        #10;

        // Test 3: Verify prefetched block (addr + BLOCK_SIZE)
        $display("Test 3: Prefetch verification");
        addr = 8'h14; // 0x10 + BLOCK_SIZE (4)
        #10;
        if (hit === 1) $display("PASS: Prefetch hit for addr=0x%0h", addr);
        else $display("FAIL: Prefetch miss for addr=0x%0h", addr);
        #10;

        // Test 4: Random address test
        $display("Test 4: Random address test");
        for (i = 0; i < 5; i++) begin
            addr = $urandom_range(0, 255); // Random 8-bit address
            #10;
            if (hit === 0) $display("PASS: Miss for random addr=0x%0h", addr);
            else $display("FAIL: Unexpected hit for addr=0x%0h", addr);
            #10;
        end

        // Test 5: Reset behavior
        $display("Test 5: Reset test");
        reset = 1;
        #10;
        if (hit === 0) $display("PASS: Cache invalidated after reset");
        else $display("FAIL: Reset did not invalidate cache");
        #10;

        $display("All tests completed.");
        $finish;
    end

    // Monitor for debug
    always @(posedge clk) begin
        $display("Time=%0t: addr=0x%0h, hit=%b, data_out=0x%0h",
            $time, addr, hit, data_out);
    end
endmodule