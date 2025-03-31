module ParityChecker (
    input  wire [7:0] data_in,
    input  wire       parity_bit,
    output wire       error
);
    
    // Compute even parity
    wire computed_parity;
    assign computed_parity = ^data_in; // XOR all bits
    
    // Compare with received parity bit
    assign error = (computed_parity != parity_bit);
    
endmodule

module ParityGenerator (
    input  wire [7:0] data_in,
    output wire       parity_bit
);
    
    // Generate even parity
    assign parity_bit = ^data_in; // XOR all bits
    
endmodule
