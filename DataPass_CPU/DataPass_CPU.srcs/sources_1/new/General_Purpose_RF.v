`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/14 10:13:34
// Design Name: 
// Module Name: General_Purpose_RF
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


module General_Purpose_RF(
    input [3:0]R_Addr_A,
    input [3:0]R_Addr_B,
    input [3:0]R_Addr_C,
    input [3:0]W_Addr,
    input [31:0]W_Data,
    input Write_Reg,
    input [4:0]M,
    input clk,
    input Rst,
    output reg [31:0]R_Data_A,
    output reg [31:0]R_Data_B,
    output reg [31:0]R_Data_C
    );
    reg Error1;
    reg Error2;
    reg [31:0]R[15:0];
    reg [31:0]R_fig[12:8];
    reg [31:0]R13_svc;
    reg [31:0]R13_abt;
    reg [31:0]R13_und;
    reg [31:0]R13_irq;
    reg [31:0]R13_fig;
    reg [31:0]R13_mon;
    reg [31:0]R13_hyp;
    reg [31:0]R14_svc;
    reg [31:0]R14_abt;
    reg [31:0]R14_und;
    reg [31:0]R14_irq;
    reg [31:0]R14_fig;
    reg [31:0]R14_mon;
    always@(negedge clk or posedge Rst)
    begin
        if(Rst==1)
        begin
                Error1<=0;
                for(integer i=0;i<15;i=i+1)begin
                    R[i]<=32'b0;
                end
                for(integer i=8;i<13;i=i+1)begin
                    R_fig[i]<=32'b0;
                end
                R13_svc<=32'b0;
                R13_abt<=32'b0;
                R13_und<=32'b0;
                R13_irq<=32'b0;
                R13_fig<=32'b0;
                R13_mon<=32'b0;
                R13_hyp<=32'b0;
                R14_svc<=32'b0;
                R14_abt<=32'b0;
                R14_und<=32'b0;
                R14_irq<=32'b0;
                R14_fig<=32'b0;
                R14_mon<=32'b0;
        end
        else 
            begin
                if(M[4]==0||W_Addr==15)Error1=1;
                else 
                begin
                    Error1=0;
                    case(M[3:0])
                        4'b0000:begin
                            if(Write_Reg)R[W_Addr]<=W_Data;
                        end
                          4'b0001:begin
                            if(Write_Reg)
                            begin
                                 if(W_Addr<8)R[W_Addr]<=W_Data;
                                 else if(W_Addr<13)R_fig[W_Addr]<=W_Data;
                                 else if(W_Addr==13)R13_fig<=W_Data;
                                 else if(W_Addr==14)R14_fig<=W_Data;
                             end
                         end
                          4'b0010:begin
                            if(Write_Reg)
                               begin
                                   if(W_Addr<13)R[W_Addr]<=W_Data;
                                   else if(W_Addr==13)R13_irq<=W_Data;
                                   else if(W_Addr==14)R14_irq<=W_Data;
                               end
                          end
                          4'b0011:begin
                            if(Write_Reg)
                             begin
                                 if(W_Addr<13)R[W_Addr]<=W_Data;
                                 else if(W_Addr==13)R13_svc<=W_Data;
                                 else if(W_Addr==14)R14_svc<=W_Data;
                             end
                          end
                          4'b0110:begin
                            if(Write_Reg)
                             begin
                                 if(W_Addr<13)R[W_Addr]<=W_Data;
                                 else if(W_Addr==13)R13_mon<=W_Data;
                                 else if(W_Addr==14)R14_mon<=W_Data;
                             end
                          end
                          4'b0111:begin
                            if(Write_Reg)
                             begin
                                 if(W_Addr<13)R[W_Addr]<=W_Data;
                                 else if(W_Addr==13)R13_abt<=W_Data;
                                 else if(W_Addr==14)R14_abt<=W_Data;
                             end
                          end
                          4'b1010:begin
                            if(Write_Reg)
                             begin
                                 if(W_Addr<13)R[W_Addr]<=W_Data;
                                 else if(W_Addr==13)R13_hyp<=W_Data;
                                 else if(W_Addr==14)Error1=1;
                             end
                          end
                          4'b1011:begin
                            if(Write_Reg)
                             begin
                                 if(W_Addr<13)R[W_Addr]<=W_Data;
                                 else if(W_Addr==13)R13_und<=W_Data;
                                 else if(W_Addr==14)R14_und<=W_Data;
                             end     
                          end
                          4'b1111:begin
                            if(Write_Reg)R[W_Addr]<=W_Data; 
                          end
                          default:Error1=1;
                     endcase
                end
            end
    end
 
always@(*)
begin
    Error2=0;
    if(R_Addr_A<8) R_Data_A<=R[R_Addr_A];
    else if(R_Addr_A<13)
        if(M[3:0]!=4'b0100&&M[3:0]!=4'b0101&&M[3:0]!=4'b1000&&M[3:0]!=4'b1001&&M[3:0]!=4'b1100&&M[3:0]!=4'b1101&&M[3:0]!=4'b1110)
        begin
            if(M[3:0]==4'b0001)R_Data_A<=R_fig[R_Addr_A];
            else R_Data_A<=R[R_Addr_A];
        end 
        else Error2=1;
    else if(R_Addr_A==13)
        case(M[3:0])
            4'b0000:R_Data_A<=R[13];
            4'b0001:R_Data_A<=R13_fig;
            4'b0010:R_Data_A<=R13_irq;
            4'b0011:R_Data_A<=R13_svc;
            4'b0110:R_Data_A<=R13_mon;
            4'b0111:R_Data_A<=R13_abt;
            4'b1010:R_Data_A<=R13_hyp;
            4'b1011:R_Data_A<=R13_und;
            4'b1111:R_Data_A<=R[13];
            default:Error2=1;
        endcase
    else if(R_Addr_A==14)
        case(M[3:0])
            4'b0000:R_Data_A<=R[14];
            4'b0001:R_Data_A<=R14_fig;
            4'b0010:R_Data_A<=R14_irq;
            4'b0011:R_Data_A<=R14_svc;
            4'b0110:R_Data_A<=R14_mon;
            4'b0111:R_Data_A<=R14_abt;
            4'b1011:R_Data_A<=R14_und;
            4'b1111:R_Data_A<=R[14];
            default:Error2=1;
        endcase
    else Error2=1;
    
     if(R_Addr_B<8) R_Data_B<=R[R_Addr_B];
       else if(R_Addr_B<13)
           if(M[3:0]!=4'b0100&&M[3:0]!=4'b0101&&M[3:0]!=4'b1000&&M[3:0]!=4'b1001&&M[3:0]!=4'b1100&&M[3:0]!=4'b1101&&M[3:0]!=4'b1110)
           begin
               if(M[3:0]==4'b0001)R_Data_B<=R_fig[R_Addr_B];
               else R_Data_B<=R[R_Addr_B];
           end 
           else Error2=1;
       else if(R_Addr_B==13)
           case(M[3:0])
               4'b0000:R_Data_B<=R[13];
               4'b0001:R_Data_B<=R13_fig;
               4'b0010:R_Data_B<=R13_irq;
               4'b0011:R_Data_B<=R13_svc;
               4'b0110:R_Data_B<=R13_mon;
               4'b0111:R_Data_B<=R13_abt;
               4'b1010:R_Data_B<=R13_hyp;
               4'b1011:R_Data_B<=R13_und;
               4'b1111:R_Data_B<=R[13];
               default:Error2=1;
           endcase
       else if(R_Addr_B==14)
           case(M[3:0])
               4'b0000:R_Data_B<=R[14];
               4'b0001:R_Data_B<=R14_fig;
               4'b0010:R_Data_B<=R14_irq;
               4'b0011:R_Data_B<=R14_svc;
               4'b0110:R_Data_B<=R14_mon;
               4'b0111:R_Data_B<=R14_abt;
               4'b1011:R_Data_B<=R14_und;
               4'b1111:R_Data_B<=R[14];
               default:Error2=1;
           endcase
       else Error2=1;
       
        if(R_Addr_C<8) R_Data_C<=R[R_Addr_C];
          else if(R_Addr_C<13)
              if(M[3:0]!=4'b0100&&M[3:0]!=4'b0101&&M[3:0]!=4'b1000&&M[3:0]!=4'b1001&&M[3:0]!=4'b1100&&M[3:0]!=4'b1101&&M[3:0]!=4'b1110)
              begin
                  if(M[3:0]==4'b0001)R_Data_C<=R_fig[R_Addr_C];
                  else R_Data_C<=R[R_Addr_C];
              end 
              else Error2=1;
          else if(R_Addr_C==13)
              case(M[3:0])
                  4'b0000:R_Data_C<=R[13];
                  4'b0001:R_Data_C<=R13_fig;
                  4'b0010:R_Data_C<=R13_irq;
                  4'b0011:R_Data_C<=R13_svc;
                  4'b0110:R_Data_C<=R13_mon;
                  4'b0111:R_Data_C<=R13_abt;
                  4'b1010:R_Data_C<=R13_hyp;
                  4'b1011:R_Data_C<=R13_und;
                  4'b1111:R_Data_C<=R[13];
                  default:Error2=1;
              endcase
          else if(R_Addr_C==14)
              case(M[3:0])
                  4'b0000:R_Data_C<=R[14];
                  4'b0001:R_Data_C<=R14_fig;
                  4'b0010:R_Data_C<=R14_irq;
                  4'b0011:R_Data_C<=R14_svc;
                  4'b0110:R_Data_C<=R14_mon;
                  4'b0111:R_Data_C<=R14_abt;
                  4'b1011:R_Data_C<=R14_und;
                  4'b1111:R_Data_C<=R[14];
                  default:Error2=1;
              endcase
          else Error2=1;
end

endmodule
