`timescale 1ns / 1ps

module RAM#(
    parameter INIT_FILE = "rtl/4-memory/store_test.memh"
)(
    input clka,
    input [0 : 0] wea,
    input [5 : 0] addra,   
    input [31 : 0] dina,
    output [31 : 0] douta
);
    reg [31:0] mem [0:63]; // 64 words of 32 bits each
    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            mem[i] = 32'b0; // Initialize all memory locations to zero
        end
        // Initialize memory from the specified file
        $readmemh(INIT_FILE, mem);
    end

    assign douta = mem[addra]; // Read operation
    always @(posedge clka) begin
        if (wea) begin
            mem[addra] <= dina; // Write operation
        end
    end


endmodule