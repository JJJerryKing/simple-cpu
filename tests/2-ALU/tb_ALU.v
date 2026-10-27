`timescale 1ns / 1ps

module tb_ALU;
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALU_OP;
    reg C;
    reg V;
    reg shiftCout;
    wire [31:0] F;
    wire [3:0] NZCV;
    initial begin
        $dumpfile("tests/build/2-ALU/ALU.vcd");
        $dumpvars(0, tb_ALU);
    end

    ALU uut (
        .A(A), 
        .B(B), 
        .ALU_OP(ALU_OP), 
        .C(C), 
        .V(V), 
        .shiftCout(shiftCout), 
        .F(F), 
        .NZCV(NZCV)
    );
    reg [4:0] i = 5'b0;
    reg [3:0] j = 4'b0;
    initial begin
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        ALU_OP = 4'h0;
        C = 0;
        V = 0;
        shiftCout = 0;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                #10;
                ALU_OP = i;
                C = j[2];
                V = j[1];
                shiftCout = j[0];
            end
            
        end
    end
endmodule
