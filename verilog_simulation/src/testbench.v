`timescale 1ns / 1ps
module ALU_tb;
    parameter WIDTH = 8;
    
    reg [WIDTH-1:0] A, B;
    reg [2:0] ALU_Sel;
    wire [WIDTH-1:0] ALU_Out;
    wire Zero;
    
    ALU #(WIDTH) uut (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Out),
        .Zero(Zero)
    );
    
    initial begin
        A = 8'h05; B = 8'h03; ALU_Sel = 3'b000; #10;
        ALU_Sel = 3'b001; #10;
        ALU_Sel = 3'b010; #10;
        ALU_Sel = 3'b011; #10;
        ALU_Sel = 3'b100; #10;
        ALU_Sel = 3'b101; #10;
        ALU_Sel = 3'b110; #10;
        ALU_Sel = 3'b111; #10;
        A = 8'h02; B = 8'h04; ALU_Sel = 3'b111; #10;
        A = 8'h00; B = 8'h00; ALU_Sel = 3'b000; #10;
        $finish;
    end
    
  /*  initial begin
        $monitor("Time=%0t | A=%h, B=%h, ALU_Sel=%b -> ALU_Out=%h, Zero=%b", 
                 $time, A, B, ALU_Sel, ALU_Out, Zero);
    end*/
    
    initial begin
        $dumpfile("output/ALU_tb.vcd");
        $dumpvars(0, ALU_tb);
    end
endmodule
