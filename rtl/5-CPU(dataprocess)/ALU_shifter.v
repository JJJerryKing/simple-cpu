`timescale 1ns / 1ps


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
    output [31:0]F,
    output [3:0]NZCV
    );
    wire [31:0]Shift_Out;
    wire Shift_Carry_Out;
    barrel_shifter shifter_instance(Shift_Data,Shift_Num,NZCV[1],Shift_OP,Shift_Out,Shift_Carry_Out);
    ALU alu_instance(clk,A,Shift_Out,ALU_OP,C,V,S,F,Shift_Carry_Out,NZCV);
    
endmodule

