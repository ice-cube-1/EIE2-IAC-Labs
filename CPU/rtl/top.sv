module top (
    input   logic clk,
    input   logic rst,
    input   logic trigger,
    output  logic [31:0] a0
);
    logic [31:0] instr, imm_op, pc, pc_plus_4, alu_result, result, reg2, mem_result, alu1;
    logic [2:0] alu_ctrl, imm_src;
    logic [1:0] result_src, pc_src;
    logic reg_write, alu_src, mem_write, zero;
    pc_etc progam_counters(
        .clk(clk),
        .rst(rst),
        .imm_op(imm_op),
        .alu_result(alu_result),
        .pc_src(pc_src),
        .pc(pc),
        .pc_plus_4(pc_plus_4)
    );
    alu alu_unit(
        .alu_control(alu_ctrl),
        .a(alu1),
        .b(alu_src ? imm_op : reg2),
        .result(alu_result),
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
    ram_async data_memory (
        .addr(alu_result),
        .clk(clk),
        .mem_write(mem_write),
        .write_data(reg2),
        .dout(mem_result)
    );
    always_comb begin
        case (result_src)
            0: result = alu_result;
            1: result = mem_result;
            2'b10: result = pc_plus_4;
        endcase
    end
    reg_file registers(
        .clk(clk),
        .ad1(instr[19:15]),
        .ad2(instr[24:20]),
        .ad3(instr[11:7]),
        .reg_write(reg_write),
        .result(result),
        .a0(a0),
        .t6(trigger),
        .rd1(alu1),
        .rd2(reg2)
    );
endmodule
