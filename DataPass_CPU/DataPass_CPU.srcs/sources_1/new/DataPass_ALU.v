`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/28 10:48:37
// Design Name: 
// Module Name: DataPass_ALU
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


module DataPass_ALU(
    input clk,
    input Rst
    );
    localparam Idle=6'd0;
    localparam S0=6'd1;
    localparam S1=6'd2;
    localparam S2=6'd3;
    localparam S3=6'd4;
    reg [5:0]ST,next_ST;
    
    always@(posedge clk or posedge Rst)
    begin
        if(Rst)
            ST<=Idle;
        else 
            ST<=next_ST;
    end
    
    always@(*)
    begin
        case(ST)
            Idle:next_ST=S0;
            S0:next_ST=isCondSatisfy?S1:S0;
            S1:next_ST=S2;
            S2:next_ST=S3;
            S3:next_ST=S0;
            default:next_ST=0;
        endcase
    end
    
    always@(posedge clk or posedge Rst)
    begin
        W_PC_EN<=1'b0;
        W_IR_EN<=1'b0;
        W_Reg_EN<=1'b0;
        LA<=1'b0;
        LB<=1'b0;
        LC<=1'b0;
        LF<=1'b0;
        S_Ctrl<=1'b0;
        if(Rst)
            begin
                W_PC_EN<=1'b0;
                W_IR_EN<=1'b0;
                W_Reg_EN<=1'b0;
                LA<=1'b0;
                LB<=1'b0;
                LC<=1'b0;
                LF<=1'b0;
                S_Ctrl<=1'b0;
            end
        else
            begin
                case(next_ST)
                    S0:begin
                            W_PC_EN<=1'b1;
                            W_IR_EN<=isCondSatisfy;
                        end
                    S1:begin
                            LA<=1'b1;
                            LB<=1'b1;
                            LC<=1'b1;
                        end
                    S2:begin
                            LF<=1'b1;
                            rm_imm_s_Ctrl<=rm_imm_s;
                            rs_imm_s_Ctrl<=rs_imm_s;
                            shiftOP_Ctrl<=shiftOP;
                            ALU_OP_Ctrl<=ALU_OP;
                            S_Ctrl<=S;
                        end 
                    S3:begin
                            W_Reg_EN<=1'b1;
                        end
                endcase
            end
    end
    
    
endmodule
