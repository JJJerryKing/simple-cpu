`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/30 22:03:52
// Design Name: 
// Module Name: test_RF
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



module test_RF;
    // Inputs
    reg [3:0] R_Addr_A;
    reg [3:0] R_Addr_B;
    reg [3:0] R_Addr_C;
    reg [3:0] W_Addr;
    reg [31:0] W_Data;
    reg Write_Reg;
    reg Write_PC;
    reg [31:0]PC_New;
    reg [4:0] M;
    reg clk;
    reg Rst;

    // Outputs
    wire [31:0] R_Data_A;
    wire [31:0] R_Data_B;
    wire [31:0] R_Data_C;
    wire Error1;//display write error
    wire Error2;//display read error

    // Instantiate the Unit Under Test (UUT)
    General_Purpose_RF uut (
        .R_Addr_A(R_Addr_A), 
        .R_Addr_B(R_Addr_B), 
        .R_Addr_C(R_Addr_C), 
        .W_Addr(W_Addr), 
        .W_Data(W_Data), 
        .Write_Reg(Write_Reg), 
        .Write_PC(Write_PC), 
        .PC_New(PC_New), 
        .M(M), 
        .clk(clk), 
        .Rst(Rst), 
        .R_Data_A(R_Data_A), 
        .R_Data_B(R_Data_B), 
        .R_Data_C(R_Data_C),
        .Error1(Error1),
        .Error2(Error2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        Rst = 0;
        R_Addr_A = 0;
        R_Addr_B = 0;
        R_Addr_C = 0;
        W_Addr = 0;
        W_Data = 0;
        Write_Reg = 0;
        Write_PC = 0;
        PC_New = 32'h0;
        M = 0;

        // Wait for global reset
        #10;
        
        // Apply reset
        Rst = 1;
        #20;
        Rst = 0;
        #20;
        
        // Write to general purpose registers (Mode 0)
        M = 5'b10000;  // User mode
        Write_Reg = 1;
        W_Addr = 4;
        //W_Addr = 1;
        W_Data = 32'hA5A5A5A5;
        //W_Data = 32'h00000002;
        #10;
        Write_Reg = 0;

        // Read from general purpose registers (Mode 0)
        R_Addr_A = 4;
        //R_Addr_B = 1;
        #10;
        
        // Apply reset
        Rst = 1;
        #20;
        Rst = 0;
        #20;
        
        // Write to banked registers (Mode 1)
        M = 5'b10001;  // FIQ mode
        Write_Reg = 1;
        W_Addr = 9;
        W_Data = 32'h5A5A5A5A;
        #10;
        Write_Reg = 0;

        // Read from banked registers (Mode 1)
        R_Addr_B = 9;
        #10;
        
        // Apply reset
        Rst = 1;
        #20;
        Rst = 0;
        #20;
        
        // wirte(Mode 2)
        M = 5'b10010;  // irq mode
        Write_Reg = 1;
        W_Addr = 5;
        W_Data = 32'h1A1A1A1A;
        #10;
        Write_Reg = 0;

        // read (Mode 2)
        R_Addr_C = 5;
        #10;
        
        // Apply reset
        Rst = 1;
        #20;
        Rst = 0;
        #20;

        // Check Error1 for invalid write address in mode 0 (User mode)
        M = 5'b10000;
        Write_Reg = 1;
        W_Addr = 15;
        W_Data = 32'hDEADBEEF;
        #10;
        Write_Reg = 0;
        
        // Apply reset
        Rst = 1;
        #20;
        Rst = 0;
        #20;

        // Check Error2 for invalid read address in mode 4 (Invalid mode)
        M = 5'b11000;
        R_Addr_A = 9;
        #10;

        // Apply reset
        Rst = 1;
        #20;
        Rst = 0;
        #20;
        
        // Write to and read from PC (Register 15)
        M = 5'b10000;  // User mode
        Write_PC = 1;
        PC_New = 32'hABCDEEFA;
        #10;
        Write_PC = 0;

        R_Addr_C = 15;
        #10;
        
        // Apply reset
        Rst = 1;
        #20;
        Rst = 0;
        #20;

    end
      
endmodule

