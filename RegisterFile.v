module RegisterFile (
    input clk,
    input rst_n,
    input [4:0] addressA, addressB, addressC,
    input [31:0] WB_out,
    input RegWrite,
    output [31:0] dataA, dataB,
    output reg [31:0] registers [0:31] 
);
	integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
        else if (RegWrite && addressC != 0) begin
            registers[addressC] <= WB_out;
        end
    end

    assign dataA = registers[addressA];
    assign dataB = registers[addressB];
endmodule
