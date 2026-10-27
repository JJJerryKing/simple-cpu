`timescale 1ns / 1ps

module ROM(
    input [5:0] addra,
    output [31:0] douta
    );
    reg [31:0] mem [0:63]; // 64 words of 32 bits each
    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            mem[i] = 32'b0; // Initialize all memory locations to zero
        end
        // Initialize memory from the specified file
        $readmemh("rtl/5-CPU(dataprocess)/rom_data.memh", mem);
    end

    assign douta = mem[addra]; // Read operation

endmodule