`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 16:11:36
// Design Name: 
// Module Name: test_ALU
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


module test_ALU;

    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALU_OP;
    reg C;
    reg V;
    reg shiftCout;
    wire [31:0] F;
    wire [3:0] NZCV;

    ALU uut (
        .A(A), 
        .B(B), 
        .ALU_OP(ALU_OP), 
        .C(C), 
        .V(V), 
        .F(F), 
        .shiftCout(shiftCout), 
        .NZCV(NZCV)
    );

    initial begin
        A = 0;
        B = 0;
        ALU_OP = 0;
        C = 0;
        V = 0;
        shiftCout = 0;

        #100;
        
        A = 32'hA5A5A5A5;
        B = 32'h00000002;
        //Test & operation
        ALU_OP = 4'h0;
        #10;

        // Test XOR operation
        ALU_OP = 4'h1;
        #10;

        // Test SUB A-B operation
        ALU_OP = 4'h2;
        #10;
        
        // Test SUB B-A operation
        ALU_OP = 4'h3;
        #10;

        // Test ADD operation
        ALU_OP = 4'h4;
        #10;
        
        // Test Carry_ADD operation
        ALU_OP = 4'h5;
        #10;
        
        // Test Carry_SUB A-B operation
        ALU_OP = 4'h6;
        #10;
        
        // Test Carry_SUB B-A operation
        ALU_OP = 4'h7;
        #10;
        
         // Test PassA operation
        ALU_OP = 4'h8;
        #10;
        
         // Test SUB A-B+4 operation
        ALU_OP = 4'hA;
        #10;

        // Test OR operation
        ALU_OP = 4'hC;
        #10;
        
        // Test PassB operation
        ALU_OP = 4'hD;
        #10;

        // Test A&not B operation
        ALU_OP = 4'hE;
        #10;

        // Test NOT B operation
        ALU_OP = 4'hF;
        #10;

        C=1;
        shiftCout = 1;
        //Test & operation
        ALU_OP = 4'h0;
        #10;

        // Test XOR operation
        ALU_OP = 4'h1;
        #10;

        // Test SUB A-B operation
        ALU_OP = 4'h2;
        #10;
        
        // Test SUB B-A operation
        ALU_OP = 4'h3;
        #10;

        // Test ADD operation
        ALU_OP = 4'h4;
        #10;
        
        // Test Carry_ADD operation
        ALU_OP = 4'h5;
        #10;
        
        // Test Carry_SUB A-B operation
        ALU_OP = 4'h6;
        #10;
        
        // Test Carry_SUB B-A operation
        ALU_OP = 4'h7;
        #10;
        
         // Test PassA operation
        ALU_OP = 4'h8;
        #10;
        
         // Test SUB A-B+4 operation
        ALU_OP = 4'hA;
        #10;

        // Test OR operation
        ALU_OP = 4'hC;
        #10;
        
        // Test PassB operation
        ALU_OP = 4'hD;
        #10;
      
        // Test A&not B operation
        ALU_OP = 4'hE;
        #10;

        // Test NOT B operation
        ALU_OP = 4'hF;
        #10;
        
    end
      
endmodule
