`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 17:05:17
// Design Name: 
// Module Name: test_ALU_shifter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module test_ALU_shifter;
    reg [31:0] Shift_Data;
    reg [7:0] Shift_Num;
    reg [2:0] Shift_OP;
    reg [31:0] A;
    reg [3:0] ALU_OP;
    reg C;
    reg V;
    wire [31:0] F;
    wire [3:0] NZCV;

    ALU_shifter uut (
        .Shift_Data(Shift_Data), 
        .Shift_Num(Shift_Num), 
        .Shift_OP(Shift_OP), 
        .A(A), 
        .ALU_OP(ALU_OP), 
        .C(C), 
        .V(V), 
        .F(F), 
        .NZCV(NZCV)
    );

    initial begin
        Shift_Data = 32'h12345678;
        Shift_Num = 0;
        Shift_OP = 3'b000;
        A = 32'h87654321;
        ALU_OP = 4'h0;
        C = 0;
        V = 0;

        #100;
        
        
        // Test case 1: Logical Shift Left
        Shift_OP = 3'b000; // Logical Shift Left
        Shift_Num = 8;
        ALU_OP = 4'h4; // ADD operation in ALU
        #10;

        // Test case 2: Logical Shift Right
        Shift_OP = 3'b010; // Logical Shift Right
        Shift_Num = 8;
        ALU_OP = 4'h4; // ADD operation in ALU
        #10;

        // Test case 3: Arithmetic Shift Right
        Shift_OP = 3'b100; // Arithmetic Shift Right
        Shift_Num = 8;
        ALU_OP = 4'h4; // ADD operation in ALU
        #10;

        // Test case 4: Rotate Right
        Shift_OP = 3'b110; // Rotate Right
        Shift_Num = 8;
        ALU_OP = 4'h4; // ADD operation in ALU
        #10;

        // Test case 5: Different ALU operation
        Shift_OP = 3'b000; // Logical Shift Left
        Shift_Num = 8;
        ALU_OP = 4'h2; // SUB operation in ALU
        #10;
    end

endmodule
