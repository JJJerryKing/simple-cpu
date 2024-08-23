`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/31 23:37:32
// Design Name: 
// Module Name: test_CPU1
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


module test_CPU1;
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
        
        DataPass cpu(clk,Rst,W_PC_EN,W_IR_EN,W_Reg_EN,A,B,C,rF,I,PC,NZCV,rm_imm_s_Ctrl,rs_imm_s_Ctrl,Shift_OP,ALU_OP);
        
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
