module reg_file (
    input logic clk,
    input logic [4:0] ad1,
    input logic [4:0] ad2,
    input logic [4:0] ad3,
    input logic reg_write,
    input logic [31:0] result,
    input logic t6,
    output logic [31:0] a0, rd1, rd2
);
    logic [31:0] rf_registers [31:0];
    assign rf_registers[31] = {31'b0,t6};
    always_ff @(posedge clk) if (reg_write) rf_registers[ad3] <= result;
    always_comb begin
        a0 = rf_registers[10];
        rd1 = rf_registers[ad1];
        rd2 = rf_registers[ad2];
    end
endmodule
