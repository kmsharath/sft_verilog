module CachePrefetch #(parameter CACHE_SIZE = 16, BLOCK_SIZE = 4, ADDR_WIDTH = 8)(
    input clk, reset, read_enable,
    input [ADDR_WIDTH-1:0] addr,
    output reg hit,
    output reg [31:0] data_out
);
    reg [31:0] cache_mem [CACHE_SIZE-1:0];
    reg [ADDR_WIDTH-1:0] tag_array [CACHE_SIZE-1:0];
    reg valid [CACHE_SIZE-1:0];
    reg [ADDR_WIDTH-1:0] prefetch_addr;
    integer index,i, prefetch_index;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            //integer i;
            for (i = 0; i < CACHE_SIZE; i = i + 1) valid[i] <= 0;
            hit <= 0;
        end 
        else if (read_enable) begin
            index = addr % CACHE_SIZE;
            if (valid[index] && tag_array[index] == addr) begin
                hit <= 1;
                data_out <= cache_mem[index];
            end else begin
                hit <= 0;
                #5 cache_mem[index] <= {addr, addr}; // Fake Data
                tag_array[index] <= addr;
                valid[index] <= 1;

                // Prefetch Next Block
                prefetch_addr = addr + BLOCK_SIZE;
                prefetch_index = prefetch_addr % CACHE_SIZE;
                cache_mem[prefetch_index] <= {prefetch_addr, prefetch_addr}; 
                tag_array[prefetch_index] <= prefetch_addr;
                valid[prefetch_index] <= 1;
            end
        end
    end
endmodule
