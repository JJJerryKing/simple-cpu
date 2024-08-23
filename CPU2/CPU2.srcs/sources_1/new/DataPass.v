`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/29 19:55:53
// Design Name: 
// Module Name: DataPass
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


module DataPass(
    input clk,
    input Rst,
    output reg W_PC_EN,
    output reg W_IR_EN,
    output reg W_Reg_EN,
    output reg [31:0]A,
    output reg [31:0]B,
    output reg [31:0]C,
    output reg [31:0]rF,
    output wire [31:0]I,
    output wire [31:0]PC, 
    output wire [3:0]NZCV,
    output reg rm_imm_s_Ctrl,
    output reg [1:0]rs_imm_s_Ctrl,
    output reg [2:0]shiftOP_Ctrl,
    output reg [3:0]ALU_OP_Ctrl
    );
    wire [3:0]rn;
    wire [3:0]rd;
    wire [3:0]rm;
    wire [3:0]rs;
    wire rm_imm_s;
    wire [1:0]rs_imm_s;
    wire [4:0]imm5;
    wire [11:0]imm12;
    wire [31:0]R_Data_A;
    wire [31:0]R_Data_B;
    wire [31:0]R_Data_C;
    reg [31:0]Shift_Data;
    reg [7:0]Shift_Num;
    wire [31:0]F;
    reg [5:0]ST,next_ST;
    reg LA;
    reg LB;
    reg LC;
    reg LF;
    reg S_Ctrl;
    wire S;
    wire isCondSatisfy;
    wire [4:0]M;
    wire [3:0]ALU_OP;
    wire [2:0]Shift_OP;
    assign M=5'b10000;
    
    LD LD(
    .clk(clk),
    .Rst(Rst),
    .W_PC_EN(W_PC_EN),
    .NZCV(NZCV),
    .W_IR_EN(W_IR_EN),
    .IR(I),
    .W_IR_valid(isCondSatisfy),
    .PC(PC)
    );
    
    Controller controller(
    .I(I),
    .ALU_OP(ALU_OP),
    .shiftOP(Shift_OP),
    .rm_imm_s(rm_imm_s),
    .rs_imm_s(rs_imm_s),
    .rn(rn),
    .rd(rd),
    .rm(rm),
    .rs(rs),
    .imm5(imm5),
    .imm12(imm12),
    .S(S)
    );
    
    General_Purpose_RF RF(
    .R_Addr_A(rn),
    .R_Addr_B(rm),
    .R_Addr_C(rs),
    .W_Addr(rd),
    .W_Data(rF),
    .Write_Reg(W_Reg_EN),
    .M(M),
    .clk(clk),
    .Rst(Rst),
    .R_Data_A(R_Data_A),
    .R_Data_B(R_Data_B),
    .R_Data_C(R_Data_C)
    );
    
    always@(negedge clk)
    begin
        if(LA)
            A<=R_Data_A;
        if(LB)
            B<=R_Data_B;
        if(LC)
            C<=R_Data_C;
        if(LF)
            rF<=F;
    end
    
    always@(*)
    begin
        if(rm_imm_s_Ctrl)
            Shift_Data<={24'h0,imm12[7:0]};
        else
            Shift_Data<=B;
    end
    
    always@(*)
    begin
        if(rs_imm_s_Ctrl==2'd2)
            Shift_Num<={3'h0,imm12[11:8]<<1'b1};
        else if(rs_imm_s_Ctrl==2'd1)
            Shift_Num<=C[7:0];
        else
            Shift_Num<={3'h0,imm5[4:0]};
    end
    
    ALU_shifter alu_shifter(
        .clk(clk),
        .Shift_Data(Shift_Data),
        .Shift_Num(Shift_Num),
        .Shift_OP(shiftOP_Ctrl),
        .A(A),
        .ALU_OP(ALU_OP_Ctrl),
        .C(NZCV[1]),
        .V(NZCV[0]),
        .S(S_Ctrl),
        .F(F),
        .NZCV(NZCV)
    );
    
    //controll
    localparam Idle=6'd0;
    localparam S0=6'd1;
    localparam S1=6'd2;
    localparam S2=6'd3;
    localparam S3=6'd4;
    
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
            S2:begin
                next_ST=S3;
                if(I[24:23]==2'b10)next_ST=S0;
            end
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
                            W_IR_EN<=1'b1;
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
                            shiftOP_Ctrl<=Shift_OP;
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
