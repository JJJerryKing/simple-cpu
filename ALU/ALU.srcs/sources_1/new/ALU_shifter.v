`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/07 11:50:01
// Design Name: 
// Module Name: ALU_shifter
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


module ALU_shifter(
    input [31:0]Shift_Data,
    input [7:0]Shift_Num,
    input [2:0]Shift_OP,
    input [31:0]A,
    input [3:0]ALU_OP,
    input C,
    input V,
    output [31:0]F,
    output [3:0]NZCV
    );
    wire [31:0]Shift_Out;
    wire Shift_Carry_Out;
    barrel_shifter_main shifter_instance(Shift_Data,Shift_Num,NZCV[1],Shift_OP,Shift_Out,Shift_Carry_Out);
    ALU alu_instance(A,Shift_Out,ALU_OP,C,V,F,Shift_Carry_Out,NZCV);
    
endmodule

