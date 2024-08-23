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
    input clk,
    input [31:0]Shift_Data,
    input [7:0]Shift_Num,
    input [2:0]Shift_OP,
    input [31:0]A,
    input [3:0]ALU_OP,
    input C,
    input V,
    input S,
    input [23:0]imm24,
    input ALU_B_s,
    output [31:0]F,
    output [3:0]NZCV
    );
    wire [31:0]Shift_Out;
    wire Shift_Carry_Out;
    reg [31:0]B;
    barrel_shifter_main shifter_instance(Shift_Data,Shift_Num,NZCV[1],Shift_OP,Shift_Out,Shift_Carry_Out);
    always@(*)begin
        if(ALU_B_s)
            B<={{6{imm24[23]}},imm24,2'b00};
        else
            B<=Shift_Out;
    end
    ALU alu_instance(clk,A,B,ALU_OP,C,V,S,F,Shift_Carry_Out,NZCV);
    
endmodule

