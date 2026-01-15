module top (
    input   logic clk,
    input   logic rst,
    input   logic trigger,
    output  logic [31:0] a0
);
logic [31:0] instr_d, pc_d, pc_plus_4_d;
logic [31:0] pc_target_e, rd1_e, rd2_e, pc_e, imm_ext_e, pc_plus_4_e;
logic [31:0] result_w, alu_result_w, read_data_w, pc_plus_4_w, prev_result_w;
logic [31:0] alu_result_m, pc_plus_4_m, write_data_m;
logic [10:0] control_bus_e;
logic [4:0] rd_e, rd_w, rd_m, rs1_e, rs2_e, prev_rd_w;
logic [3:0] control_bus_m;
logic [2:0] control_bus_w;
logic [1:0] forwarda_e, forwardb_e;
logic pc_src_e, reg_write_w, stall;
fetch fetch (
    .pc_target_e(pc_target_e), .pc_src_e(pc_src_e), .clk(clk), .rst(rst), .stall(stall),
    .instr_d(instr_d), .pc_d(pc_d), .pc_plus_4_d(pc_plus_4_d)
);
decode decode (
    .instr_d(instr_d), .pc_d(pc_d), .pc_plus_4_d(pc_plus_4_d), .rd_w(rd_w), .result_w(result_w), .reg_write_w(reg_write_w), .clk(clk), .a0(a0), .stall(stall), .pc_src_e(pc_src_e),
    .rd1_e(rd1_e), .rd2_e(rd2_e), .pc_e(pc_e), .imm_ext_e(imm_ext_e), .pc_plus_4_e(pc_plus_4_e), .rd_e(rd_e), .control_bus_e(control_bus_e), .rs2_e(rs2_e), .rs1_e(rs1_e)
);
execute execute (
    .rd1_e(rd1_e), .rd2_e(rd2_e), .pc_e(pc_e), .rd_e(rd_e), .imm_ext_e(imm_ext_e), .pc_plus_4_e(pc_plus_4_e), .control_bus_e(control_bus_e), .clk(clk), .forwarda_e(forwarda_e), .forwardb_e(forwardb_e), .result_w(result_w),
    .pc_src_e(pc_src_e), .pc_target_e(pc_target_e), .alu_result_m(alu_result_m), .write_data_m(write_data_m), .pc_plus_4_m(pc_plus_4_m), .rd_m(rd_m), .control_bus_m(control_bus_m), .prev_result_w(prev_result_w)
);
memory memory (
    .alu_result_m(alu_result_m), .write_data_m(write_data_m), .pc_plus_4_m(pc_plus_4_m), .rd_m(rd_m), .clk(clk), .control_bus_m(control_bus_m), 
    .alu_result_w(alu_result_w), .read_data_w(read_data_w), .pc_plus_4_w(pc_plus_4_w), .rd_w(rd_w), .control_bus_w(control_bus_w)
);
writeback writeback (
    .alu_result_w(alu_result_w), .read_data_w(read_data_w), .pc_plus_4_w(pc_plus_4_w), .control_bus_w(control_bus_w), .stall(stall),
    .result_w(result_w), .reg_write_w(reg_write_w), .rd_w(rd_w), .prev_rd_w(prev_rd_w), .prev_result_w(prev_result_w), .clk(clk)
);
hazard hazard (
    .reg_write_w(reg_write_w), .control_bus_m(control_bus_m), .rd_m(rd_m), .rd_w(rd_w), .rs1_e(rs1_e), .rs2_e(rs2_e),
    .forwarda_e(forwarda_e), .forwardb_e(forwardb_e), .stall(stall), .prev_rd_w(prev_rd_w), .clk(clk)
);
endmodule
