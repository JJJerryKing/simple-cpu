`timescale 1ns/1ps

module adder_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] Sum,
    output wire       Cout
);
    // 将操作数显式扩展为 5 位，以保留最高位进位。
    assign {Cout, Sum} = {1'b0, A} + {1'b0, B} + Cin;
endmodule
