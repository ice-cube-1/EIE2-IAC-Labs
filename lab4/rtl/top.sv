module top #(
    parameter DATA_WIDTH = 32
) (
    input   logic clk,
    input   logic rst,
    output  logic [DATA_WIDTH-1:0] a0
);
    logic [31:0] instr, imm_op;
    logic [6:0] pc;
    logic [1:0] imm_src;
    logic [2:0] alu_ctrl;
    logic reg_write, alu_src, mem_write, result_src, pc_src, zero;
    pc_etc progam_counters(
        .clk(clk),
        .rst(rst),
        .imm_op(imm_op),
        .pc_src(pc_src),
        .pc(pc)
    );
    reg_alu_etc registers_alu(
        .instr(instr),
        .reg_write(reg_write),
        .clk(clk),
        .alu_src(alu_src),
        .alu_ctrl(alu_ctrl),
        .imm_op(imm_op),
        .a0(a0),
        .zero(zero)
    );
    rom_async instruction_memory(
        .addr(pc),
        .dout(instr)
    );
    sign_extend sign(
        .instr(instr),
        .imm_src(imm_src),
        .imm_op(imm_op)
    );
    control_unit cu (
        .instr(instr),
        .zero(zero),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .pc_src(pc_src),
        .alu_control(alu_ctrl)
    );
endmodule
