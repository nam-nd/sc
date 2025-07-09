module BranchComp (
    input [6:0] op,
    input [2:0] funct3,
    input [31:0] rs1_data, rs2_data,
    output reg Branch_taken
);
    always @(*) begin
        Branch_taken = 1'b0;
        if (op == 7'b1100011) begin
            case (funct3)
                3'b000: Branch_taken = (rs1_data == rs2_data); // BEQ
                3'b001: Branch_taken = (rs1_data != rs2_data); // BNE
                3'b100: Branch_taken = ($signed(rs1_data) < $signed(rs2_data)); // BLT
                3'b101: Branch_taken = ($signed(rs1_data) >= $signed(rs2_data)); // BGE
                3'b110: Branch_taken = (rs1_data < rs2_data); // BLTU
                3'b111: Branch_taken = (rs1_data >= rs2_data); // BGEU
                default: Branch_taken = 1'b0;
            endcase
        end
    end
endmodule