module reg_alu_etc(
    input logic [31:0] instr,
    input logic reg_write,
    input logic clk,
    input logic alu_src,
    input logic [2:0] alu_ctrl,
    input logic [31:0] imm_op,
    output logic [31:0] a0,
    output logic zero
);
    logic [31:0] result, alu1, reg2, alu2;
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
    mux2 aluop2(
        .in0(reg2),
        .in1(imm_op),
        .sel(alu_src),
        .out(alu2)
    );
    alu alu_unit(
        .alu_control(alu_ctrl),
        .a(alu1),
        .b(alu2),
        .result(result),
        .zero(zero)
    );
endmodule
