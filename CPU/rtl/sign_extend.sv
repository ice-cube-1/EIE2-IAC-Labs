module sign_extend (
    input logic [31:0] instr,
    input logic [1:0] imm_src,
    output logic [31:0] imm_op
);
    always_comb begin
        case (imm_src)
            2'b00: imm_op = {{20{instr[31]}},instr[31:20]};
            2'b01: imm_op = {{20{instr[31]}},instr[31:25],instr[11:7]};
            2'b10: imm_op = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
            2'b11: imm_op = {instr[31:12], {12{1'b0}}};
            default: imm_op = 32'b0;
        endcase
    end
endmodule
