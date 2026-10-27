`timescale 1ns/1ps

module tb_dff_8bit;
    reg  [7:0] Din;
    reg        Clk;
    reg        Rst;
    wire [7:0] Qout;

    dff_8bit dut (
        .Din(Din),
        .Clk(Clk),
        .Rst(Rst),
        .Qout(Qout)
    );

    initial begin
        $dumpfile("tests/build/dff_8bit.vcd");
        $dumpvars(0, tb_dff_8bit);
    end

    initial begin
        Din = 8'h00;
        Clk = 1'b0;
        Rst = 1'b1;
        #1;
        if (Qout !== 8'h00) begin
            $display("FAIL: reset did not clear Qout, actual=%h", Qout);
            $fatal(1);
        end

        Rst = 1'b0;
        Din = 8'hA5;
        #1;
        if (Qout !== 8'h00) begin
            $display("FAIL: Qout changed without a rising clock edge, actual=%h", Qout);
            $fatal(1);
        end

        #3;
        Clk = 1'b1;
        #1;
        if (Qout !== 8'hA5) begin
            $display("FAIL: rising edge did not capture Din, actual=%h", Qout);
            $fatal(1);
        end

        Clk = 1'b0;
        Din = 8'h3C;
        #1;
        Rst = 1'b1;
        #1;
        if (Qout !== 8'h00) begin
            $display("FAIL: asynchronous reset waited for a clock edge, actual=%h", Qout);
            $fatal(1);
        end

        Rst = 1'b0;
        Din = 8'hF0;
        #3;
        Clk = 1'b1;
        #1;
        if (Qout !== 8'hF0) begin
            $display("FAIL: register did not recover after reset, actual=%h", Qout);
            $fatal(1);
        end

        $display("PASS: dff_8bit clock and asynchronous reset test");
        $finish;
    end
endmodule
