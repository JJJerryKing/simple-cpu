`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/31 16:33:40
// Design Name: 
// Module Name: test_memory
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



module test_memory;
    reg clk;
    reg Rst;
    reg Mem_Read;
    reg Mem_Write;
    reg [7:0] Mem_Addr;
    reg [31:0] M_W_Data;
    wire [31:0] M_R_Data;

    // Instantiate the DUT (Device Under Test)
    ARMv7_memory uut (
        .clk(clk),
        .Rst(Rst),
        .Mem_Read(Mem_Read),
        .Mem_Write(Mem_Write),
        .Mem_Addr(Mem_Addr),
        .M_W_Data(M_W_Data),
        .M_R_Data(M_R_Data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period clock
    end

    // Test sequence
    initial begin
        
        
        // Initialize signals
        Rst = 0;
        Mem_Read = 0;
        Mem_Write = 0;
        Mem_Addr = 8'h00;
        M_W_Data = 32'h00000000;
        
        #20;
        
        // Reset the DUT
        //#10 Rst = 1;
        //#10 Rst = 0;
        
        // Read data from memory
        #30 Mem_Addr = 8'h0;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        
        
        
        // Read data from memory
        #30 Mem_Addr = 8'h04;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        

        // Read data from memory
        #30 Mem_Addr = 8'h08;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        
        
        // Read data from memory
        #30 Mem_Addr = 8'h0C;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        
        // Read data from memory
        #30 Mem_Addr = 8'h10;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        


        // Write data to memory
        #30 Mem_Addr = 8'h04;
            M_W_Data = 32'hDEADBEEF;
            Mem_Write = 1;
        #30 Mem_Write = 0;
        
        #30;
        
        // Read data from memory
        #30 Mem_Addr = 8'h0;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        
        // Read data from memory
        #30 Mem_Addr = 8'h04;
            Mem_Read = 1;
        #60 Mem_Read = 0;

        // Read data from memory
        #30 Mem_Addr = 8'h08;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        
        // Read data from memory
        #30 Mem_Addr = 8'h0C;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        #30;
        
        // Read data from memory
        #30 Mem_Addr = 8'h10;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        
        // Write data to memory
        #30 Mem_Addr = 8'h0C;
            M_W_Data = 32'h12345678;
            Mem_Write = 1;
        #30 Mem_Write = 0;
        
        #30;
        
        // Read data from memory
        #30 Mem_Addr = 8'h0;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        
        // Read data from memory
        #30 Mem_Addr = 8'h04;
            Mem_Read = 1;
        #60 Mem_Read = 0;

        // Read data from memory
        #30 Mem_Addr = 8'h08;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        
        // Read data from memory
        #30 Mem_Addr = 8'h0C;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        #30;
        
        // Read data from memory
        #30 Mem_Addr = 8'h10;
            Mem_Read = 1;
        #60 Mem_Read = 0;
        
        // Reset the DUT
        #10 Rst = 1;
        #10 Rst = 0;

    end
endmodule

