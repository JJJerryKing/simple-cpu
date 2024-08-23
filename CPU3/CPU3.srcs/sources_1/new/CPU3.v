`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/06 21:34:24
// Design Name: 
// Module Name: CPU3
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


module CPU3(
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
    output reg [3:0]ALU_OP_Ctrl,
    output reg [1:0]rd_s,
    output reg [1:0]PC_s,
    output reg ALU_A_s,
    output reg [1:0]ALU_B_s,
    output reg S_Ctrl,
    output reg Mem_W_s,
    output reg W_Rdata_s,
    output reg Mem_Write,
    output reg Reg_C_s,
    output P,
    output U,
    output W,
    output Und_Ins,
    output [2:0]DPx,
    output [1:0]STRx,
    output [1:0]LDRx,
    output BX,
    output iB,
    output BL,
    output SWP,
    output reg [5:0]ST,
    output reg [5:0]next_ST,
    output [31:0]W_Data
    //output [23:0]imm24
    );
    wire [3:0]rn;
    wire [3:0]rd; 
    wire [3:0]rm;
    wire [3:0]rs;
    wire rm_imm_s;
    wire [1:0]rs_imm_s;
    wire [4:0]imm5;
    wire [11:0]imm12;
    wire [23:0]imm24;
    wire [31:0]R_Data_A;
    wire [31:0]R_Data_B;
    wire [31:0]R_Data_C;
    reg [31:0]Shift_Data;
    reg [7:0]Shift_Num;
    wire [31:0]F;
    //reg [5:0]ST,next_ST;
    reg LA;
    reg LB;
    reg LC;
    reg LF;
    wire S;
    wire isCondSatisfy;
    wire [4:0]M;
    wire [3:0]ALU_OP;
    wire [2:0]Shift_OP;
    reg [3:0]W_Addr;
    wire [31:0]dataA;
    wire [31:0]M_W_Data;
    wire [31:0]M_R_Data;
    wire [3:0]R_Addr_C;
    wire [1:0]type;
    reg flag;
    //wire [31:0]W_Data;
    
    
    assign M=5'b10000;
    
    
    LD LD(
    .M_R_Data(M_R_Data),
    .W_Rdata_s(W_Rdata_s),
    .PC_s(PC_s),
    .rF(rF),
    .B(B),
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
    .flag(flag),
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
    .imm24(imm24),
    .S(S),
    .DPx(DPx),
    .BX(BX),
    .B(iB),
    .BL(BL),
    .SWP(SWP),
    .LDRx(LDRx),
    .STRx(STRx),
    .Und_Ins(Und_Ins),
    .P(P),
    .U(U),
    .W(W),
    .type(type)
    );
    
    always@(*)
    begin
        if(rd_s==2'b00)W_Addr<=rd;
        else if(rd_s==2'b01)W_Addr<=4'b1110;
        else if(rd_s==2'b10)W_Addr<=rn;
    end
    assign R_Addr_C=Reg_C_s?rd:rs;
    assign W_Data=W_Rdata_s?M_R_Data:rF;
    General_Purpose_RF RF(
    .R_Addr_A(rn),
    .R_Addr_B(rm),
    .R_Addr_C(R_Addr_C),
    .W_Addr(W_Addr),
    .W_Data(W_Data),
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
    
    assign dataA=ALU_A_s?PC:A;
    ALU_shifter alu_shifter(
        .clk(clk),
        .Shift_Data(Shift_Data),
        .Shift_Num(Shift_Num),
        .Shift_OP(shiftOP_Ctrl),
        .A(dataA),
        .ALU_OP(ALU_OP_Ctrl),
        .C(NZCV[1]),
        .V(NZCV[0]),
        .S(S_Ctrl),
        .imm12(imm12),
        .imm24(imm24),
        .ALU_B_s(ALU_B_s),
        .F(F),
        .NZCV(NZCV)
    );
    
    
    assign M_W_Data=Mem_W_s?C:B;
    DataRAM dataRAM (
      .clka(~clk),    // input wire clka
      .wea(Mem_Write),      // input wire [0 : 0] wea
      .addra(rF[7:2]),  // input wire [5 : 0] addra
      .dina(M_W_Data),    // input wire [31 : 0] dina
      .douta(M_R_Data)  // output wire [31 : 0] douta
    );
    
    
    //controll
    localparam Idle=6'd0;
    localparam S0=6'd1;
    localparam S1=6'd2;
    localparam S2=6'd3;
    localparam S3=6'd4;
    localparam S7=6'd8;
    localparam S8=6'd9;
    localparam S9=6'd10;
    localparam S10=6'd11;
    localparam S11=6'd12;
    localparam S12=6'd13;
    localparam S13=6'd14;
    localparam S14=6'd15;
    localparam S15=6'd16;
    localparam S16=6'd17;
    localparam S17=6'd18;
    localparam S18=6'd19;
    
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
            S0:begin
                if(isCondSatisfy)begin
                    if(DPx==3'b001|DPx==3'b010|DPx==3'b100|BX)
                        next_ST=S1;
                    else if(iB)
                        next_ST=S8;
                    else if(BL)
                        next_ST=S10;
                    else if(LDRx==2'b01||LDRx==2'b10||STRx==2'b01||STRx==2'b10||SWP)
                        next_ST=S1;
                end
                else next_ST=S0;
            end
            S1:begin
                if(DPx==3'b100||DPx==3'b010||DPx==3'b001)next_ST=S2;
                else if(BX)next_ST=S7;
                else if(LDRx==2'b01||LDRx==2'b10||STRx==2'b01||STRx==2'b10)next_ST=S12;
                else if(SWP)next_ST=S16;
            end
            S2:begin
                next_ST=S3;
                if(I[24:23]==2'b10)next_ST=S0;
            end
            S3:next_ST=S0;
            S7:next_ST=S0;
            S8:next_ST=S9;
            S9:next_ST=S0;
            S10:next_ST=S11;
            S11:next_ST=S9;
            S12:begin
                if(LDRx==2'b01||LDRx==2'b10)next_ST<=S13;
                if(STRx==2'b01||STRx==2'b10)next_ST<=S15;
            end
            S13:next_ST=S14;
            S14:next_ST=S0;
            S15:next_ST=S14;
            S16:next_ST=S17;
            S17:next_ST=S18;
            S18:next_ST=S0;
            default:next_ST=S0;
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
        PC_s<=2'b0;
        rd_s<=2'b0;
        ALU_A_s<=1'b0;
        ALU_B_s<=2'b0;
        Mem_W_s<=1'b0;
        W_Rdata_s<=1'b0;
        Mem_Write<=1'b0;
        Reg_C_s<=1'b0;
        flag<=1'b0;
        if(Rst)
            begin
                flag<=1'b0;
                W_PC_EN<=1'b0;
                W_IR_EN<=1'b0;
                W_Reg_EN<=1'b0;
                LA<=1'b0;
                LB<=1'b0;
                LC<=1'b0;
                LF<=1'b0;
                S_Ctrl<=1'b0;
                PC_s<=2'b0;
                rd_s<=1'b0;
                ALU_A_s<=1'b0;
                ALU_B_s<=2'b0;
                Mem_W_s<=1'b0;
                W_Rdata_s<=1'b0;
                Mem_Write<=1'b0;
                Reg_C_s<=1'b0;
            end
        else
            begin
                case(next_ST)
                    S0:begin
                            flag<=1'b1;
                            W_PC_EN<=1'b1;
                            W_IR_EN<=1'b1;
                            PC_s<=2'b00;
                        end
                    S1:begin
                            if(DPx==3'b100||DPx==3'b010||DPx==3'b001)begin
                                LA<=1'b1;
                                LB<=1'b1;
                                LC<=1'b1;
                            end
                            else if(STRx==2'b01||STRx==2'b10)begin
                                LA<=1'b1;
                                LB<=1'b1;
                                LC<=1'b1;
                                Reg_C_s<=1'b1;
                            end
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
                    S7:begin
                        W_PC_EN<=1'b1;
                        PC_s<=2'b01;
                    end
                    S8:begin
                        ALU_A_s<=1'b1;
                        ALU_B_s<=1'b1;
                        ALU_OP_Ctrl<=4'b0100;
                        S_Ctrl<=1'b0;
                        LF<=1'b1;
                    end
                    S9:begin
                        W_PC_EN<=1'b1;
                        PC_s<=2'b10;
                    end
                    S10:begin
                        ALU_A_s<=1'b1;
                        ALU_OP_Ctrl<=4'b1000;
                        S_Ctrl<=1'b0;
                        LF<=1'b1;
                    end
                    S11:begin
                        ALU_A_s<=1'b1;
                        ALU_B_s<=1'b1;
                        ALU_OP_Ctrl<=4'b0100;
                        S_Ctrl<=1'b0;
                        LF<=1'b1;
                        rd_s<=1'b1;
                        W_Reg_EN<=1'b1;
                    end
                    S12:begin
                        if(P==1'b0)begin
                            ALU_A_s<=1'b0;
                            ALU_OP_Ctrl<=4'b1000;
                            S_Ctrl<=1'b0;
                            LF<=1'b1;
                        end
                        else if(P==1'b1)begin
                            if(LDRx==2'b01||STRx==2'b01)begin
                                ALU_A_s<=1'b0;
                                ALU_B_s<=2'b10;
                                if(U==1'b1)ALU_OP_Ctrl<=4'b0100;
                                else ALU_OP_Ctrl<=4'b0010;
                                S_Ctrl<=1'b0;
                                LF<=1'b1;
                            end
                            else if(LDRx==2'b10||STRx==2'b10)begin
                                rm_imm_s_Ctrl<=1'b0;
                                rs_imm_s_Ctrl<=2'b0;
                                shiftOP_Ctrl<={type,1'b0};
                                ALU_A_s<=1'b0;
                                ALU_B_s<=2'b00;
                                if(U==1'b1)ALU_OP_Ctrl<=4'b0100;
                                else ALU_OP_Ctrl<=4'b0010;
                                S_Ctrl<=1'b0;
                                LF<=1'b1;
                            end
                        end
                    end
                    S13:begin
                        if(P==1'b0)begin
                            if(LDRx==2'b01)begin
                                ALU_A_s<=1'b0;
                                ALU_B_s<=2'b10;
                                if(U==1'b1)ALU_OP_Ctrl<=4'b0100;
                                else ALU_OP_Ctrl<=4'b0010;
                                S_Ctrl<=1'b0;
                                LF<=1'b1;
                                W_Rdata_s<=1'b1;
                                rd_s<=2'b00;
                                W_Reg_EN<=1'b1;
                            end
                            else if(LDRx==2'b10)begin
                                rm_imm_s_Ctrl<=1'b0;
                                rs_imm_s_Ctrl<=2'b00;
                                shiftOP_Ctrl<={type,1'b0};
                                ALU_A_s<=1'b0;
                                ALU_B_s<=2'b00;
                                if(U==1'b1)ALU_OP_Ctrl<=4'b0100;
                                else ALU_OP_Ctrl<=4'b0010;
                                S_Ctrl<=1'b0;
                                LF<=1'b1;
                                W_Rdata_s<=1'b1;
                                rd_s<=2'b00;
                                W_Reg_EN<=1'b1;
                            end
                        end
                        else if(P==1'b1)begin
                            W_Rdata_s<=1'b1;
                            rd_s<=2'b00;
                            W_Reg_EN<=1'b1;
                        end
                    end
                    S14:begin
                        if(P==1'b0||W==1'b1)begin
                            W_Rdata_s<=1'b0;
                            rd_s<=2'b10;
                            W_Reg_EN<=1'b1;
                        end
                    end
                    S15:begin
                        if(P==1'b0)begin
                            if(STRx==2'b01)begin
                                ALU_A_s<=1'b0;
                                ALU_B_s<=2'b10;
                                if(U==1'b1)ALU_OP_Ctrl<=4'b0100;
                                else ALU_OP_Ctrl<=4'b0010;
                                S_Ctrl<=1'b0;
                                LF<=1'b1;
                                Mem_W_s<=1'b1;
                                Mem_Write<=1'b1;
                            end
                            else if(STRx==2'b10)begin
                                rm_imm_s_Ctrl<=1'b0;
                                rs_imm_s_Ctrl<=1'b0;
                                shiftOP_Ctrl<={type,1'b0};
                                ALU_A_s<=1'b0;
                                ALU_B_s<=2'b00;
                                if(U==1'b1)ALU_OP_Ctrl<=4'b0100;
                                else ALU_OP_Ctrl<=4'b0010;
                                S_Ctrl<=1'b0;
                                LF<=1'b1;
                                Mem_W_s<=1'b1;
                                Mem_Write<=1'b1;
                            end
                        end 
                        else if(P==1'b1)begin
                            Mem_W_s<=1'b1;
                            Mem_Write<=1'b1;
                        end
                    end
                endcase
            end
    end
    
    
endmodule

