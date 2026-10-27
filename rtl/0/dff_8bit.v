`timescale 1ns/1ps

module dff_8bit (
    input  wire [7:0] Din,
    input  wire       Clk,
    input  wire       Rst,
    output reg  [7:0] Qout
);
    // Clk 上升沿锁存数据；Rst 为高电平有效的异步复位。
    always @(posedge Clk or posedge Rst) begin
        if (Rst)
            Qout <= 8'b0;
        else
            Qout <= Din;
    end
endmodule
