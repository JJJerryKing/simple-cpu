`timescale 1ns / 1ps


module tb_barrel_shifter;
    reg [31:0] Shift_Data;
    reg [7:0] Shift_Num;
    reg Carry_Flag;
    reg [2:0] Shift_OP;
    wire [31:0] Shift_Out;
    wire Shift_Carry_Out;
    
    barrel_shifter uut (
        .Shift_Data(Shift_Data), 
        .Shift_Num(Shift_Num), 
        .Carry_Flag(Carry_Flag), 
        .Shift_OP(Shift_OP), 
        .Shift_Out(Shift_Out), 
        .Shift_Carry_Out(Shift_Carry_Out)
    );

    integer op;

    initial begin
        Shift_Data = 32'hA5A5A5A5;
        Carry_Flag = 1'b1;

        for (op = 0; op < 8; op = op + 1) begin
            Shift_OP = op[2:0];

            Shift_Num = 0;  #10;
            Shift_Num = 1;  #10;
            Shift_Num = 31; #10;
            Shift_Num = 32; #10;
            Shift_Num = 33; #10;
        end

        $finish;
    end

    initial begin
        $dumpfile("tests/build/1-barrelShifter/barrel_shifter.vcd");
        $dumpvars(0, tb_barrel_shifter);
    end

endmodule
