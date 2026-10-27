`timescale 1ns / 1ps

module tb_CPU1;
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
        wire [5:0]ST;
        wire [5:0]next_ST;
        initial begin
            $dumpfile("tests/build/5-CPU(dataprocess)/CPU1.vcd");
            $dumpvars(0, tb_CPU1);
        end
        
        CPU cpu(clk,Rst,W_PC_EN,W_IR_EN,W_Reg_EN,A,B,C,rF,I,PC,NZCV,rm_imm_s_Ctrl,rs_imm_s_Ctrl,Shift_OP,ALU_OP,ST,next_ST);
        
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

            #1000;
            $finish;
        end
endmodule
