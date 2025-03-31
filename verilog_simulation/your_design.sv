`timescale 1ns / 1ps

module ALU #(parameter WIDTH = 8) (
    input  logic [WIDTH-1:0] A, B,
    input  logic [2:0] ALU_Sel,
    output logic [WIDTH-1:0] ALU_Out,
    output logic Zero
);

always begin
        case (ALU_Sel)
            3'b000: ALU_Out = A + B;       // Addition
            3'b001: ALU_Out = A - B;       // Subtraction
            3'b010: ALU_Out = A & B;       // Bitwise AND
            3'b011: ALU_Out = A | B;       // Bitwise OR
            3'b100: ALU_Out = A ^ B;       // Bitwise XOR
            3'b101: ALU_Out = A << 1;      // Left Shift
            3'b110: ALU_Out = A >> 1;      // Right Shift
            3'b111: ALU_Out = (A < B) ? 1 : 0; // Less Than
            default: ALU_Out = 0;
        endcase
    end
    
    assign Zero = (ALU_Out == 0) ? 1 : 0; // Zero flag
    
endmodule
