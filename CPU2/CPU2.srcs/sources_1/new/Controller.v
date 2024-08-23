`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/28 10:58:12
// Design Name: 
// Module Name: Controller
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


module Controller(
    input [31:0]I,
    output reg [3:0]ALU_OP,
    output reg [2:0]shiftOP,
    output rm_imm_s,
    output reg [1:0]rs_imm_s,
    output [3:0]rn,
    output [3:0]rd,
    output [3:0]rm,
    output [3:0]rs,
    output [4:0]imm5,
    output [11:0]imm12,
    output [23:0]imm24,
    output S,
    output reg [2:0]DPx,
    output reg BX,
    output reg B,
    output reg BL
    );
    reg Und_Ins;
    
    
    wire [3:0]cond;
    wire [3:0]OP;
    wire [1:0]type;
    
    assign cond=I[31:28];
    assign OP=I[24:21];
    assign S=I[20];
    assign rn=I[19:16];
    assign rd=I[15:12];
    assign rs=I[11:8];
    assign imm5=I[11:7];
    assign type=I[6:5];
    assign rm=I[3:0];
    assign imm12=I[11:0];
    assign imm24=I[23:0];
    
    //deal with data
    localparam AND=4'b0000;
    localparam EOR=4'b0001;
    localparam SUB=4'b0010;
    localparam RSB=4'b0011;
    localparam ADD=4'b0100;
    localparam ADC=4'b0101;
    localparam SBC=4'b0110;
    localparam RSC=4'b0111;
    localparam TST=4'b1000;
    localparam TEQ=4'b1001;
    localparam CMP=4'b1010;
    localparam CMN=4'b1011;
    localparam ORR=4'b1100;
    localparam MOV=4'b1101;
    localparam BIC=4'b1110;
    localparam MVN=4'b1111;
    
    always@(*)
    begin
        DPx[0]<=(I[27:25]==3'b000)&&(I[4]==1'b0)&&(rd!=4'd15);
        DPx[1]<=(I[27:25]==3'b000)&&(I[4]==1'b1)&&(I[7]==1'b0)&&(rd!=4'd15);
        DPx[2]<=(I[27:25]==3'b001)&&(rd!=4'd15);
        BX<=(I[27:4]==24'b0001_0010_1111_1111_1111_0001)?1'b1:1'b0;
        B<=(I[27:24]==4'b1010)?1'b1:1'b0;
        BL<=(I[27:24]==4'b1011)?1'b1:1'b0;
    end
    
    always@(*)
    begin
        if(OP[3:2]==2'b10&&S)
            Und_Ins<=1'b0;
        else if(rd==4'd15&&rn==4'd14&&S==1'b1&&(OP==MOV||OP==SUB))
            Und_Ins<=1'b0;
        else if(DPx==3'b100||DPx==3'b010||DPx==3'b001)
            Und_Ins<=1'b0;
        else 
            Und_Ins<=1'b1;
    end
    
    //OP->ALU_OP
    always@(*)
    begin
        case(OP)
            TST:ALU_OP<=4'b0000;
            TEQ:ALU_OP<=4'b0001;
            CMP:ALU_OP<=4'b0010;
            CMN:ALU_OP<=4'b0100;
            default:ALU_OP<=OP;
        endcase
    end
    
    //type->shiftOP
    always@(*)
    begin
        if(DPx[2])
            shiftOP<=3'b111;
        else
            shiftOP<={type,DPx[1]};
    end
    
    assign rm_imm_s=DPx[2];
    always@(*)
    begin
        case(DPx)
            3'b001:rs_imm_s<=2'd0;
            3'b010:rs_imm_s<=2'd1;
            3'b100:rs_imm_s<=2'd2;
            default:rs_imm_s<=2'd0;
        endcase
    end
    
endmodule
