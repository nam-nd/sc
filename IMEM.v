module IMEM (
    input [29:0] addr,
    output [31:0] instruction
);
    reg [31:0] memory [0:1023];
    initial begin
        $readmemh("memory.dat", memory); 
    end
    assign instruction = memory[addr];
endmodule
