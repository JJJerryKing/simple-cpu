`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/30 11:49:30
// Design Name: 
// Module Name: test
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


module test;
    reg [31:0]shift_data;
    reg [7:0]shift_num;
    reg carry_flag;
    reg [2:0]shift_op;
    wire [31:0]shift_out;
    wire shift_carry_out;
    barrel_shifter_main the_instance(shift_data,shift_num,carry_flag,shift_op,shift_out,shift_carry_out);
    initial 
    begin
        shift_data=32'b0;

    end
    
endmodule

module test;
    reg [31:0] Shift_Data;
    reg [7:0] Shift_Num;
    reg Carry_Flag;
    reg [2:0] Shift_OP;
    wire [31:0] Shift_Out;
    wire Shift_Carry_Out;
    
    barrel_shifter_main uut (
        .Shift_Data(Shift_Data), 
        .Shift_Num(Shift_Num), 
        .Carry_Flag(Carry_Flag), 
        .Shift_OP(Shift_OP), 
        .Shift_Out(Shift_Out), 
        .Shift_Carry_Out(Shift_Carry_Out)
    );

    initial begin
        Shift_Data = 32'hA5A5A5A5;
        Carry_Flag = 1'b1;
        
        // Test Logical Shift Left (Shift_OP = 3'b00x)
        Shift_OP = 3'b000;
        Shift_Num = 0; #10;  // No shift
        

        Shift_Num = 1; #10;  // Shift by 1

        Shift_Num = 31; #10;  // Shift by 31

        Shift_Num = 32; #10;  // Shift by 32

        Shift_Num = 33; #10;  // Shift by more than 32
        
        Shift_OP = 3'b001;
        Shift_Num = 0; #10;  // No shift

        Shift_Num = 1; #10;  // Shift by 1

        Shift_Num = 31; #10;  // Shift by 31

        Shift_Num = 32; #10;  // Shift by 32

        Shift_Num = 33; #10;  // Shift by more than 32
        
        // Test Logical Shift Right (Shift_OP = 3'b01x)
        Shift_OP = 3'b010;
        Shift_Num = 0; #10;  // =Shift by 32
        
        Shift_Num = 1; #10;  // Shift by 1

        Shift_Num = 31; #10;  // Shift by 31

        Shift_Num = 32; #10;  // Shift by 32

        Shift_Num = 33; #10;  // Shift by more than 32

        Shift_OP = 3'b011;
        Shift_Num = 0; #10;  // No shift
        
        Shift_Num = 1; #10;  // Shift by 1

        Shift_Num = 31; #10;  // Shift by 31

        Shift_Num = 32; #10;  // Shift by 32

        Shift_Num = 33; #10;  // Shift by more than 32

        // Test Arithmetic Shift Right (Shift_OP = 3'b10x)
        Shift_OP = 3'b100;
        Shift_Num = 0; #10;  // = shift by 32
        
        Shift_Num = 1; #10;  // Shift by 1

        Shift_Num = 31; #10;  // Shift by 31

        Shift_Num = 32; #10;  // Shift by 32

        Shift_Num = 33; #10;  // Shift by more than 32
        
        Shift_OP = 3'b101;
        Shift_Num = 0; #10;  // = shift by 32
        
        Shift_Num = 1; #10;  // Shift by 1

        Shift_Num = 31; #10;  // Shift by 31

        Shift_Num = 32; #10;  // Shift by 32

        Shift_Num = 33; #10;  // Shift by more than 32
        
        // Test Rotate Right (Shift_OP = 3'b11x)
        Shift_OP = 3'b110;
        Shift_Num = 0; #10;  // No shift

        Shift_Num = 1; #10;  // Shift by 1

        Shift_Num = 31; #10;  // Shift by 31

        Shift_Num = 32; #10;  // Shift by 32

        Shift_Num = 33; #10;  // Shift by more than 32
        
        Shift_OP = 3'b111;
        Shift_Num = 0; #10;  // No shift

        Shift_Num = 1; #10;  // Shift by 1

        Shift_Num = 31; #10;  // Shift by 31

        Shift_Num = 32; #10;  // Shift by 32

        Shift_Num = 33; #10;  // Shift by more than 32
        
    end

endmodule
