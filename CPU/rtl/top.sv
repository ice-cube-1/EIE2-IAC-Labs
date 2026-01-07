module top (
    input   logic clk,
    input   logic rst,
    input   logic trigger,
    output  logic [31:0] a0
);
logic [31:0] instr_d, pc_d, pc_plus_4_d;
logic [31:0] pc_target_e, rd1_e, rd2_e, pc_e, imm_ext_e, pc_plus_4_e;
logic [31:0] rd1_e, rd2_e, pc_e, imm_ext_e, pc_plus_4_e
logic [31:0] result_w, alu_result_w, read_data_w, pc_plus_4_w, control_bus_w;
logic [10:0] control_bus_e;
logic [4:0] rd_e, rd_w, rd_m;
logic [3:0] control_bus_m;
logic pc_src_e, reg_write_w;
fetch fetch (
    .pc_target_e(pc_target_e), .pc_src_e(pc_src_e), .clk(clk), .rst(rst),
    .instr_d(instr_d), .pc_d(pc_d), .pc_plus_4_d(pc_plus_4_d)
);
decode decode (
    .instr_d(instr_d), .pc_d(pc_d), .pc_plus_4_d(pc_plus_4_d), .rd_w(rd_w), .result_w(result_w), .reg_write_w(reg_write_w), .clk(clk),
    .rd1_e(rd1_e), .rd2_e(rd2_e), .pc_e(pc_e), .imm_ext_e(imm_ext_e), .pc_plus_4_e(pc_plus_4_e), .rd_e(rd_e), .control_bus_e(control_bus_e)
);
execute execute (
    .rd1_e(rd1_e), .rd2_e(rd2_e), .pc_e(pc_e), .rd_e(rd_e), .imm_ext_e(imm_ext_e), .pc_plus_4_e(pc_plus_4_e), .control_bus_e(control_bus_e), .clk(clk),
    .pc_src_e(pc_src_e), .pc_target_e(pc_target_e), alu_result_m(alu_result_m), .write_data_m(write_data_m), .pc_plus_4_m(pc_plus_4_m), .rd_m(rd_m), .control_bus_m(control_bus_m)
);
memory memory (
    .alu_result_m(alu_result_m), .write_data_m(write_data_m), .pc_plus_4_m(pc_plus_4_m), .rd_m(rd_m), .clk(clk), .control_bus_m(control_bus_m), 
    .alu_result_w(alu_result_w), .read_data_w(read_data_w), .pc_plus_4_w(pc_plus_4_w), .rd_w(rd_w), .control_bus_w(control_bus_w)
)
writeback writeback (
    .alu_result_w(alu_result_w), .read_data_w(read_data_w), .pc_plus_4_w(pc_plus_4_w), .control_bus_w(control_bus_w),
    .result_w(result_w), .reg_write_w(reg_write_w)
)
endmodule
