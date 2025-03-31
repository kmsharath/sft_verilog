`timescale 1ns / 1ps

module ALU_tb;
    // Parameter for ALU width
    parameter WIDTH = 8;
    
    // Testbench signals
    logic [WIDTH-1:0] A, B;
    logic [2:0] ALU_Sel;
    logic [WIDTH-1:0] ALU_Out;
    logic Zero;
    
    // Instantiate the ALU module
    ALU #(WIDTH) uut (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Out),
        .Zero(Zero)
    );
    
    // Test procedure
    initial begin
        // Apply test cases
        A = 8'h05; B = 8'h03; 
        ALU_Sel = 3'b000; #10; // Addition: 5 + 3 = 8
        
        ALU_Sel = 3'b001; #10; // Subtraction: 5 - 3 = 2
        
        ALU_Sel = 3'b010; #10; // AND: 5 & 3 = 00000001
        
        ALU_Sel = 3'b011; #10; // OR: 5 | 3 = 00000111
        
        ALU_Sel = 3'b100; #10; // XOR: 5 ^ 3 = 00000110
        
        ALU_Sel = 3'b101; #10; // Left Shift: 5 << 1 = 00001010
        
        ALU_Sel = 3'b110; #10; // Right Shift: 5 >> 1 = 00000010
        
        ALU_Sel = 3'b111; #10; // Less Than: (5 < 3) ? 1 : 0 = 0
        
        A = 8'h02; B = 8'h04; // Changing A & B
        ALU_Sel = 3'b111; #10; // Less Than: (2 < 4) ? 1 : 0 = 1
        
        A = 8'h00; B = 8'h00;
        ALU_Sel = 3'b000; #10; // Zero flag check (0 + 0 = 0)
        
        // Finish simulation
        $finish;
    end
    
    // Monitor output
    initial begin
        $monitor("Time=%0t | A=%h, B=%h, ALU_Sel=%b -> ALU_Out=%h, Zero=%b", 
                 $time, A, B, ALU_Sel, ALU_Out, Zero);
    end
    
    // Dump waveforms
    initial begin
        $dumpfile("ALU_tb.vcd");
        $dumpvars(0, ALU_tb);
    end
    
endmodule
