module sign_extend (
    input logic [31:0] instr,
    input logic [2:0] imm_src,
    output logic [31:0] imm_op
);
    always_comb begin
        case (imm_src)
            3'b00: imm_op = {{20{instr[31]}},instr[31:20]};
            3'b01: imm_op = {{20{instr[31]}},instr[31:25],instr[11:7]};
            3'b10: imm_op = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
            3'b11: imm_op = {instr[31:12], {12{1'b0}}};
            3'b100: imm_op = {{12{instr[31]}}, instr[19:12], instr[11], instr[30:21], 1'b0};
            default: imm_op = 32'b0;
        endcase
    end
endmodule
