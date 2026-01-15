module execute (
    input logic[31:0] rd1_e, 
    input logic[31:0] rd2_e,
    input logic[31:0] pc_e,
    input logic[4:0] rd_e,
    input logic[31:0] prev_result_w,
    input logic[31:0] imm_ext_e,
    input logic[31:0] pc_plus_4_e,
    input logic[31:0] result_w,
    input logic [10:0] control_bus_e,
    input logic[1:0] forwarda_e,
    input logic [1:0] forwardb_e,
    input logic clk,
    output logic pc_src_e,
    output logic [31:0] pc_target_e, alu_result_m, write_data_m, pc_plus_4_m,
    output logic [4:0] rd_m,
    output logic [3:0] control_bus_m
);
logic [31:0] a, b, result,rd;
always_comb begin
    case (forwarda_e)
        2'b00: a = rd1_e;
        2'b01: a = result_w;
        2'b11: a = prev_result_w;
        default: a = alu_result_m;
    endcase
    case (forwardb_e)
        2'b00: rd = rd2_e;
        2'b01: rd = result_w;
        2'b11: rd = prev_result_w;
        default: rd = alu_result_m;
    endcase
    if (control_bus_e[9]) b = imm_ext_e;
    else b = rd;
    case (control_bus_e[8:6])
        3'b000: result = a + b;
        3'b001: result = a - b;
        3'b010: result = a & b;
        3'b011: result = a | b;
        3'b100: result = a ^ b;
        3'b101: result = {31'b0,($signed(a) < $signed(b))};
        3'b110: result = a << b[4:0];
        3'b111: result = a >> b[4:0];
    endcase
end
assign pc_src_e = ((control_bus_e[10] ^ (result == 32'b0)) & control_bus_e[5]) | control_bus_e[4];
assign pc_target_e = (control_bus_e[10] & control_bus_e[4]) ? a+imm_ext_e : pc_e+imm_ext_e;
always_ff @(posedge clk) begin
    alu_result_m <= result;
    write_data_m <= rd;
    rd_m <= rd_e;
    pc_plus_4_m <= pc_plus_4_e;
    control_bus_m <= control_bus_e[3:0];
end
endmodule
