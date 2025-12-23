module pc_etc (
    input logic clk,
    input logic rst,
    input logic [31:0] imm_op,
    input logic pc_src
    output logic [4:0] pc
);
    logic [31:0] next_pc;
    mux2 get_next_pc(
        .in1(pc + imm_op),
        .in0(pc+4),
        .sel(pc_src),
        .out(next_pc)
    );
    always_ff @(posedge clk) begin
        if (rst) pc <= 0;
        else pc <= next_pc;
    end
endmodule