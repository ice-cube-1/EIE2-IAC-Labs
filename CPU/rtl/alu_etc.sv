module alu_etc(
    input logic alu_src,
    input logic[31:0] alu1,
    input logic [31:0] reg2,
    input logic [2:0] alu_ctrl,
    input logic [31:0] imm_op,
    output logic [31:0] alu_result,
    output logic zero
);
    logic [31:0] alu2;
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
        .result(alu_result),
        .zero(zero)
    );
endmodule
