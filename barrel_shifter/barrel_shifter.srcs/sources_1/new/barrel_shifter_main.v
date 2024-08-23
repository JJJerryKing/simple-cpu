`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/30 10:19:42
// Design Name: 
// Module Name: barrel_shifter_main
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


module barrel_shifter_main(
    input [31:0]Shift_Data,
    input [7:0]Shift_Num,
    input Carry_Flag,
    input [2:0]Shift_OP,
    output reg [31:0]Shift_Out,
    output reg Shift_Carry_Out
    );
    always @(*)
    begin
        case (Shift_OP[2:1])
            2'b00:
            begin
                if(Shift_Num==0)
                begin
                    Shift_Out<=Shift_Data;
                end
                if(Shift_Num>=1&&Shift_Num<=32)
                begin
                    Shift_Out<=Shift_Data<<Shift_Num;
                    Shift_Carry_Out<=Shift_Data[32-Shift_Num];
                end
                if(Shift_Num>32)
                begin
                    Shift_Out<=32'b0;
                    Shift_Carry_Out<=32'b0;         
                end
            end
            2'b01:
            begin
                if(Shift_OP[0]==0&&Shift_Num==0)
                begin
                    Shift_Out<=32'b0;
                    Shift_Carry_Out<=Shift_Data[31];
                end
                if(Shift_OP[0]==1&&Shift_Num==0)
                begin
                    Shift_Out<=Shift_Data;
                end
                if(Shift_Num>=1&&Shift_Num<=32)
                begin
                    Shift_Out<=Shift_Data>>Shift_Num;
                    Shift_Carry_Out<=Shift_Data[Shift_Num-1];
                end
                if(Shift_Num>32)
                begin
                    Shift_Out<=32'b0;
                    Shift_Carry_Out<=32'b0;
                end
            end
            2'b10:
            begin
                if(Shift_OP[0]==0&&Shift_Num==0)
                begin
                    Shift_Out<={32{Shift_Data[31]}};
                    Shift_Carry_Out<=Shift_Data[31];
                end
                if(Shift_OP[0]==1&&Shift_Num==0)
                begin
                    Shift_Out<=Shift_Data;
                end
                if(Shift_Num>=1&&Shift_Num<=31)
                begin
                    Shift_Out<={{32{Shift_Data[31]}},Shift_Data}>>Shift_Num;
                    Shift_Carry_Out<=Shift_Data[Shift_Num-1];
                end
                if(Shift_Num>=32)
                begin
                    Shift_Out<={32{Shift_Data[31]}};
                    Shift_Carry_Out<=Shift_Data[31];
                end
            end
            2'b11:
            begin
                if(Shift_OP[0]==0&&Shift_Num==0)
                begin 
                    Shift_Out<={Carry_Flag,Shift_Data[31:1]};
                    Shift_Carry_Out<=Shift_Data[0];
                end
                if(Shift_OP[0]==1&&Shift_Num==0)
                begin
                    Shift_Out<=Shift_Data;
                end
                if(Shift_Num>=1&&Shift_Num<=32)
                begin
                    Shift_Out<={Shift_Data,Shift_Data}>>Shift_Num;
                    Shift_Carry_Out<=Shift_Data[Shift_Num-1];
                end
                if(Shift_Num>32)
                begin
                    Shift_Out<={Shift_Data,Shift_Data}>>Shift_Num[4:0];
                    Shift_Carry_Out<=Shift_Data[Shift_Num[4:0]-1];
                end
            end
        endcase
    end
endmodule
