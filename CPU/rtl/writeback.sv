module writeback(
    input logic [31:0] alu_result_w, 
    input logic [31:0] read_data_w, 
    input logic [31:0] pc_plus_4_w,
    input logic [2:0] control_bus_w,
    output logic [31:0] result_w,
    output logic reg_write_w
);
always_comb begin
    case (control_bus_w[2:1])
        2'b00: result_w = alu_result_w;
        2'b01: result_w = read_data_w;
        default: result_w = pc_plus_4_w;
    endcase
end
assign reg_write_w = control_bus_w[0];
endmodule
