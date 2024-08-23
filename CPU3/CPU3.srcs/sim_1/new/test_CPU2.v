`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/06 21:56:25
// Design Name: 
// Module Name: test_CPU2
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


module test_CPU2;
       reg clk;
       reg Rst;
       wire W_PC_EN;
       wire W_IR_EN;
       wire W_Reg_EN;
       wire [31:0]A;
       wire [31:0]B;
       wire [31:0]C;
       wire [31:0]rF;
       wire [31:0]I;
       wire [31:0]PC; 
       wire [3:0]NZCV;
       wire rm_imm_s_Ctrl;
       wire [1:0]rs_imm_s_Ctrl;
       wire [2:0]Shift_OP;
       wire [3:0]ALU_OP;
       wire rd_s;
       wire [1:0]PC_s;
       wire ALU_A_s;
       wire ALU_B_s;
       wire S_Ctrl;
       
       CPU3 cpu(clk,Rst,W_PC_EN,W_IR_EN,W_Reg_EN,A,B,C,rF,I,PC,NZCV,rm_imm_s_Ctrl,rs_imm_s_Ctrl,Shift_OP,ALU_OP,rd_s,PC_s,ALU_A_s,ALU_B_s,S_Ctrl);
       always #5 clk=~clk;
       initial
       begin
           clk=0;
           Rst=0;
           
           #10;
           
       // Apply reset
           Rst = 1;
           #20;
           Rst = 0;
           #20;
       end
endmodule

