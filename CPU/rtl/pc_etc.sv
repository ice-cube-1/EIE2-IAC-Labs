module pc_etc (
    input logic clk,
    input logic rst,
    input logic [31:0] pc_target,
    input logic pc_src,
    output logic [31:0] pc, pc_plus_4
);
    logic [31:0] next_pc;
    always_comb begin
        pc_plus_4 = pc + 32'd4;
        next_pc = pc_src ? pc_target : pc_plus_4;
    end
    always_ff @(posedge clk) pc <= rst ? 32'd0 : next_pc;
endmodule
