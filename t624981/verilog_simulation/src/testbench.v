module tb_ParityCheck;
    reg [7:0] data;
    reg parity;
    wire error;
    
    ParityChecker uut (
        .data_in(data),
        .parity_bit(parity),
        .error(error)
    );
    
    initial begin
        // Test case 1: No error
        data = 8'b10101010;
        parity = ^data; // Correct parity
        #10;
        $display("Data: %b, Parity: %b, Error: %b", data, parity, error);
        
        // Test case 2: Introduce an error
        data = 8'b10101011;
        parity = ^(8'b10101010); // Wrong parity
        #10;
        $display("Data: %b, Parity: %b, Error: %b", data, parity, error);
        
        $stop;
    end
    initial begin
        $dumpfile("output/tb_ParityCheck.vcd");
        $dumpvars(0, tb_ParityCheck);
    end

endmodule
