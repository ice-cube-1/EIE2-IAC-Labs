module top (
    input   logic clk,
    input   logic rst,
    input   logic trigger,
    output  logic [31:0] a0
);
    logic [31:0] instr, imm_op, pc, alu_result, result, reg2, mem_result, alu1;
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
    alu_etc alu(
        .alu_src(alu_src),
        .alu_ctrl(alu_ctrl),
        .imm_op(imm_op),
        .zero(zero),
        .reg2(reg2),
        .alu1(alu1),
        .alu_result(alu_result)
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
    ram_async data_memory (
        .addr(alu_result),
        .clk(clk),
        .mem_write(mem_write),
        .write_data(reg2),
        .dout(mem_result)
    );
    mux2 #(32) get_result (
        .in0(alu_result),
        .in1(mem_result),
        .sel(result_src),
        .out(result)
    );
    reg_file registers(
        .clk(clk),
        .ad1(instr[19:15]),
        .ad2(instr[24:20]),
        .ad3(instr[11:7]),
        .reg_write(reg_write),
        .result(result),
        .a0(a0),
        .rd1(alu1),
        .rd2(reg2)
    );
endmodule
