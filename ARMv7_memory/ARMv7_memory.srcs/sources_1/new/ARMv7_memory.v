`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/21 11:11:25
// Design Name: 
// Module Name: ARMv7_memory
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


module ARMv7_memory(
    input clk,
    input Rst,
    input Mem_Read,
    input Mem_Write,
    input [7:0]Mem_Addr,
    input [31:0]M_W_Data,
    output reg [31:0]M_R_Data
    );
    reg Mem_Write_in;
    reg [7:0]Mem_Addr_in;
    reg [31:0]M_W_Data_in;
    wire [31:0]M_R_Data_in;
    
    
    always@(posedge clk or posedge Rst)
    begin
        if (Rst) begin
                // Reset internal signals
                Mem_Write_in <= 1'b0;
                Mem_Addr_in <= 8'b0;
                M_W_Data_in <= 32'b0;
                M_R_Data<=32'b0;
            end 
        else begin
                    // Update internal signals based on Mem_Read and Mem_Write
                    if (Mem_Write) begin
                        Mem_Write_in <= 1'b1;
                        Mem_Addr_in <= Mem_Addr;
                        M_W_Data_in <= M_W_Data;
                    end else if (Mem_Read) begin
                        Mem_Write_in <= 1'b0;  // Ensure no write during read
                        Mem_Addr_in <= Mem_Addr;
                        // M_W_Data_internal is irrelevant during read
                    end else begin
                        // No operation when both Mem_Read and Mem_Write are zero
                        Mem_Write_in <= 1'b0;
                    end
                    
                    // Update read data
                    if (Mem_Read) begin
                        M_R_Data <= M_R_Data_in;
                    end
            end
    end
    
    RAM_B RAM1 (
      .clka(clk),    // input wire clka
      .wea(Mem_Write_in),      // input wire [0 : 0] wea
      .addra(Mem_Addr_in[7:2]),  // input wire [5 : 0] addra
      .dina(M_W_Data_in),    // input wire [31 : 0] dina
      .douta(M_R_Data_in)  // output wire [31 : 0] douta
    );
    
endmodule
