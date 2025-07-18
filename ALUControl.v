module ALUControl (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input [6:0] op,
    output reg [3:0] ALU_Control
);
    wire RtypeSub = (op == 7'b0110011 && funct3 == 3'b000 && funct7[5]) ? 1'b1 : 1'b0;
    always @(*) begin
        case (ALUOp)
            2'b00: ALU_Control = 4'b0000; // ADD (load, store, AUIPC, JAL, JALR)
            2'b01: ALU_Control = 4'b0001; // SUB (branch)
            2'b10: begin
                case (funct3)
                    3'b000: ALU_Control = RtypeSub ? 4'b0001 : 4'b0000; // ADD/SUB
                    3'b001: ALU_Control = 4'b0101; // SLL
                    3'b010: ALU_Control = 4'b1000; // SLT
                    3'b011: ALU_Control = 4'b1001; // SLTU
                    3'b100: ALU_Control = 4'b0100; // XOR
                    3'b101: ALU_Control = funct7[5] ? 4'b0111 : 4'b0110; // SRA/SRL
                    3'b110: ALU_Control = 4'b0011; // OR
                    3'b111: ALU_Control = 4'b0010; // AND
                    default: ALU_Control = 4'b0000;
                endcase
            end
            default: ALU_Control = 4'b0000;
        endcase
    end
endmodule