module pc_etc (
    input logic clk,
    input logic rst,
    input logic [31:0] imm_op,
    input logic [31:0] alu_result,
    input logic [1:0] pc_src,
    output logic [31:0] pc,
    output logic [31:0] pc_plus_4
);
    logic [31:0] next_pc;
    always_comb begin
        pc_plus_4 = pc+31'b100;
        case (pc_src) 
            0: next_pc = pc_plus_4;
            1: next_pc = pc + imm_op;
            2'b10: next_pc = alu_result;
        endcase
    end
    always_ff @(posedge clk) begin
        if (rst) pc <= 0;
        else pc <= next_pc;
    end
endmodule
