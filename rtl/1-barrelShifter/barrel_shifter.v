/**
 * @file barrel_shifter.v
 * @author hjx
 * @brief 32位桶形移位器，支持逻辑左移、逻辑右移、算术右移、
 *        循环右移以及带进位循环右移。
 * @version 0.1
 * @date 2026-10-20
 */
`timescale 1ns / 1ps
/**
 * @brief
 * 本模块为组合逻辑电路，根据 Shift_OP 选择移位方式，
 * 根据 Shift_Num 指定移位位数。
 *
 * 支持的操作：
 * - LSL：逻辑左移
 * - LSR：逻辑右移
 * - ASR：算术右移
 * - ROR：循环右移
 * - RRX：带进位循环右移
 *
 * Shift_Carry_Out 输出最后一个被移出的数据位。
 * @param[in]  Shift_Data       32位待移位数据
 * @param[in]  Shift_Num        移位位数
 * @param[in]  Carry_Flag       RRX操作使用的输入进位标志
 * @param[in]  Shift_OP         移位操作控制信号
 * @param[out] Shift_Out        32位移位结果
 * @param[out] Shift_Carry_Out  最后被移出的数据位
 */
module barrel_shifter(
    input [31:0]Shift_Data,
    input [7:0]Shift_Num,
    input Carry_Flag,
    input [2:0]Shift_OP,
    output reg[31:0]Shift_Out,
    output reg Shift_Carry_Out
);
    always @(*)
    begin
        case (Shift_OP[2:1])
            2'b00:
            begin
                if(Shift_Num==0)
                begin
                    Shift_Out=Shift_Data;
                end
                else if(Shift_Num>=1&&Shift_Num<=32)
                begin
                    Shift_Out=Shift_Data<<Shift_Num;
                    Shift_Carry_Out=Shift_Data[32-Shift_Num];
                end
                else if(Shift_Num>32)
                begin
                    Shift_Out=32'b0;
                    Shift_Carry_Out=32'b0;
                end
            end
            2'b01:
            begin
                if(Shift_OP[0]==0&&Shift_Num==0)
                begin
                    Shift_Out=32'b0;
                    Shift_Carry_Out=Shift_Data[31];
                end
                if(Shift_OP[0]==1&&Shift_Num==0)
                begin
                    Shift_Out=Shift_Data;
                end
                if(Shift_Num>1&&Shift_Num<=32)
                begin
                    Shift_Out=Shift_Data>>Shift_Num;
                    Shift_Carry_Out=Shift_Data[Shift_Num-1];
                end
                if(Shift_Num>32)
                begin
                    Shift_Out=32'b0;
                    Shift_Carry_Out=32'b0;
                end
            end
            2'b10:
            begin
                if(Shift_OP[0]==0&&Shift_Num==0)
                begin
                    Shift_Out={32{Shift_Data[31]}};
                    Shift_Carry_Out=Shift_Data[31];
                end
                if(Shift_OP[0]==1&&Shift_Num==0)
                begin
                    Shift_Out=Shift_Data;
                end
                if(Shift_Num>=1&&Shift_Num<=32)
                begin
                    Shift_Out={{32{Shift_Data[31]}},Shift_Data}>>Shift_Num;
                    Shift_Carry_Out=Shift_Data[Shift_Num-1];
                end
                if(Shift_Num>32)
                begin
                    Shift_Out={32{Shift_Data[31]}};
                    Shift_Carry_Out=Shift_Data[31];
                end
            end
            2'b11:
            begin
                if(Shift_OP[0]==0&&Shift_Num==0)
                begin
                    Shift_Out={Carry_Flag,Shift_Data[31:1]};
                    Shift_Carry_Out=Shift_Data[0];
                end
                if(Shift_OP[0]==1&&Shift_Num==0)
                begin
                    Shift_Out=Shift_Data;
                end
                if(Shift_Num>=1&&Shift_Num<=32)
                begin
                    Shift_Out={Shift_Data,Shift_Data}>>Shift_Num;
                    Shift_Carry_Out=Shift_Data[Shift_Num-1];
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