module fetch (
    input logic [31:0] pc_target_e,
    input logic pc_src_e,
    input logic clk,
    input logic rst,
    output logic [31:0] instr_d, pc_d, pc_plus_4_d
);
logic [31:0] next_pc, pc_plus_4, pc, instr;
logic [7:0] rom_array [3217035263:3217031168];
initial $readmemh("program.hex", rom_array);
always_comb begin
    pc_plus_4 = pc + 32'd4;
    next_pc = pc_src_e ? pc_target_e : pc_plus_4;
    instr = {rom_array[pc+3], rom_array[pc+2], rom_array[pc+1], rom_array[pc]};
end
always_ff @(posedge clk) begin
    instr_d <= instr;
    pc_plus_4_d <= pc_plus_4;
    pc_d <= pc;
    pc <= rst ? 32'd0 : next_pc;
end
endmodule
