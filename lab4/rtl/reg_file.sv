module reg_file (
    input logic clk,
    input logic [4:0] ad1,
    input logic [4:0] ad2,
    input logic [4:0] ad3,
    input logic reg_write,
    input logic [31:0] result,
    output logic [31:0] a0,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);
    logic [31:0] registers [31:0];
    always_ff @(posedge clk) begin
        if (reg_write) registers[ad3] <= result;
    end
    always_comb begin
        a0 = registers[0]
        rd1 = registers[ad1]
        rd2 = registers[ad2]
    end
endmodule