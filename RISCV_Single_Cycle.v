module RISCV_Single_Cycle (
    input clk, rst_n,
    output [31:0] Instruction_out_top,
    output [31:0] PC_out_top,
    output [31:0] registers [0:31]
);
    wire [31:0] instruction;
    wire [6:0] op;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] rs1, rs2, rd;
    wire [31:0] imm_ext;
    wire [31:0] PC_plus4, PC_branch, next_PC, PC_Out;
    wire [31:0] dataA, dataB, A, B;
    wire [3:0] ALU_Control;
    wire [31:0] alu_out;
    wire [31:0] read_data;
    wire [31:0] WB_out;
    wire ALUSrc, ALUSrc_pc, MemWrite, MemRead, RegWrite, Branch, Branch_taken, Jump;
    wire [1:0] ResultSrc;
    wire [1:0] ALUOp;
    wire [2:0] imm_sel;

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    assign op = instruction[6:0];
    assign Instruction_out_top = instruction;
    assign PC_out_top = PC_Out;

    PC PC_inst (
        .clk(clk),
        .rst_n(rst_n),
        .next_PC(next_PC),
        .PC_Out(PC_Out)
    );

    PCAdder PCAdder_inst (
        .PC_in(PC_Out),
        .PC_plus4(PC_plus4)
    );

    BranchAdder BranchAdder_inst (
        .PC_in(PC_Out),
        .imm_ext(imm_ext),
        .PC_branch(PC_branch)
    );

    NextPCSel NextPCSel_inst (
        .PC_plus4(PC_plus4),
        .PC_branch(PC_branch),
        .JALR_target(alu_out),
        .Branch(Branch),
        .Jump(Jump),
        .Branch_taken(Branch_taken),
        .op(op),
        .next_PC(next_PC)
    );

    IMEM IMEM_inst (
        .address(PC_Out[31:2]),
        .instruction(instruction)
    );

    ControlUnit ControlUnit_inst (
        .op(op),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ALUSrc_pc(ALUSrc_pc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp),
        .imm_sel(imm_sel)
    );

    RegisterFile Reg_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addressA(rs1),
        .addressB(rs2),
        .addressC(rd),
        .WB_out(WB_out),
        .RegWrite(RegWrite),
        .dataA(dataA),
        .dataB(dataB),
        .registers(registers)
    );

    ImmGen ImmGen_inst (
        .instruction(instruction),
        .imm_sel(imm_sel),
        .imm_ext(imm_ext)
    );

    ALUControl ALU_Control_inst (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .op(op),
        .ALU_Control(ALU_Control)
    );

    ALU ALU_inst (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .alu_out(alu_out)
    );

    BranchComp BranchComp_inst (
        .op(op),
        .funct3(funct3),
        .rs1_data(dataA),
        .rs2_data(dataB),
        .Branch_taken(Branch_taken)
    );

    DMEM DMEM_inst (
        .clk(clk),
        .MemWrite(MemWrite),
        .address(alu_out),
        .write_data(dataB),
        .read_data(read_data) 
    );

    MUX2 muxALU1 (
        .A(dataA),
        .B(PC_Out),
        .select(ALUSrc_pc),
        .out(A)
    );

    MUX2 muxALU2 (
        .A(dataB),
        .B(imm_ext),
        .select(ALUSrc),
        .out(B)
    );

    MUX3 muxWB (
        .A(alu_out),
        .B(read_data),
        .C(PC_plus4),
        .select(ResultSrc),
        .out(WB_out)
    );
endmodule
