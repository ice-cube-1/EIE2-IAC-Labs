module execute (
    input logic[31:0] rd1_e, 
    input logic[31:0] rd2_e,
    input logic[31:0] pc_e,
    input logic[4:0] rd_e,
    input logic[31:0] imm_ext_e,
    input logic[31:0] pc_plus_4_e,
    input logic [10:0] control_bus_e,
    input logic clk,
    output logic pc_src_e,
    output logic [31:0] pc_target_e, alu_result_m, write_data_m, pc_plus_4_m,
    output logic [4:0] rd_m,
    output logic [3:0] control_bus_m
);
logic [31:0] b;
logic [31:0] result;
always_comb begin
    assign b = control_bus_e[9] ? imm_ext_e : rd2_e;
    case (control_bus_e[8:6])
        3'b000: result = rd1_e + b;
        3'b001: result = rd1_e - b;
        3'b010: result = rd1_e & b;
        3'b011: result = rd1_e | b;
        3'b100: result = rd1_e ^ b;
        3'b101: result = {31'b0,($signed(rd1_e) < $signed(b))};
        3'b110: result = rd1_e << b[4:0];
        3'b111: result = rd1_e >> b[4:0];
    endcase
end
assign pc_src_e = ((control_bus_e[10] ^ (result == 32'b0)) & control_bus_e[5]) | control_bus_e[4];
assign pc_target_e = (control_bus_e[10] & control_bus_e[4]) ? rd1_e+imm_ext_e : pc_e+imm_ext_e;
always_ff @(posedge clk) begin
    alu_result_m <= result;
    write_data_m <= rd2_e;
    rd_m <= rd_e;
    pc_plus_4_m <= pc_plus_4_e;
    control_bus_m <= control_bus_e[3:0];
end
endmodule
