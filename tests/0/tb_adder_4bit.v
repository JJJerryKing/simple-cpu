`timescale 1ns/1ps

module tb_adder_4bit;
    reg  [3:0] A;
    reg  [3:0] B;
    reg        Cin;
    wire [3:0] Sum;
    wire       Cout;

    integer a_value;
    integer b_value;
    integer cin_value;
    reg [4:0] expected;

    adder_4bit dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
        $dumpfile("tests/build/adder_4bit.vcd");
        $dumpvars(0, tb_adder_4bit);
    end

    initial begin
        for (a_value = 0; a_value < 16; a_value = a_value + 1) begin
            for (b_value = 0; b_value < 16; b_value = b_value + 1) begin
                for (cin_value = 0; cin_value < 2; cin_value = cin_value + 1) begin
                    A = a_value[3:0];
                    B = b_value[3:0];
                    Cin = cin_value[0];
                    expected = a_value + b_value + cin_value;
                    #1;

                    if ({Cout, Sum} !== expected) begin
                        $display(
                            "FAIL: A=%h B=%h Cin=%b expected=%h actual=%h",
                            A, B, Cin, expected, {Cout, Sum}
                        );
                        $fatal(1);
                    end
                end
            end
        end

        $display("PASS: adder_4bit exhaustive test");
        $finish;
    end
endmodule
