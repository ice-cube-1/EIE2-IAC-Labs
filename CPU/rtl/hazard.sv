module hazard (
    input logic reg_write_w,
    input logic [3:0] control_bus_m,
    input logic [4:0] rd_m,
    input logic [4:0] rd_w,
    input logic [4:0] rs1_e,
    input logic [4:0] rs2_e,
    output logic [1:0] forwardb_e, forwarda_e
);
always_comb begin
    if (rs1_e == rd_m && control_bus_m[0] && rs1_e != 0) forwarda_e = 2'b10;
    else if (rs1_e == rd_w && reg_write_w && rs1_e != 0) forwarda_e = 2'b01;
    else forwarda_e = 2'b00;
    if (rs2_e == rd_m && control_bus_m[0] && rs2_e != 0) forwardb_e = 2'b10;
    else if (rs2_e == rd_w && reg_write_w && rs2_e != 0) forwardb_e = 2'b01;
    else forwardb_e = 2'b00;
end
endmodule
