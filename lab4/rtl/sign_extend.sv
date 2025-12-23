module sign_extend (
    input logic instr [31:0],
    input logic imm_src [1:0],
    output logic imm_op [31:0]
);
    always_comb begin
        case (imm_src)
            2'b00: imm_op = {{20{instr[31]}},instr[31:20]};
            2'b01: imm_op = {{20{instr[31]}},instr[31:25],instr[11:7]};
            2'b10: imm_op = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
            default: imm_op = 32'b0;
        endcase
    end
endmodule