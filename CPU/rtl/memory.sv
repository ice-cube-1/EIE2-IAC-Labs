module memory (
    input logic [31:0] alu_result_m, 
    input logic [31:0] write_data_m, 
    input logic [31:0] pc_plus_4_m,
    input logic [4:0] rd_m, 
    input logic clk,
    input logic [3:0] control_bus_m,
    output logic [31:0] alu_result_w, read_data_w, pc_plus_4_w
    output logic [4:0] rd_w,
    output logic [2:0] control_bus_w
);
logic [7:0] ram_array [131071:0];
initial $readmemh("data.hex", ram_array, 65536);
always_comb dout = {24'b0, ram_array[alu_result_m]};
always_ff @(posedge clk) begin
    alu_result_w <= alu_result_m;
    read_data_w <= rd_m;
    pc_plus_4_w <= pc_plus_4_m;
    rd_w <= rd_m;
    control_bus_w <= control_bus_m[2:0];
    if (control_bus_m[3]) ram_array[alu_result_m] <= write_data_m[7:0];
end
endmodule