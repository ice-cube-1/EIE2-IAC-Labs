module control_unit (
    input logic [31:0] instr,
    input logic zero,
    output logic reg_write,
    output logic [1:0] imm_src,
    output logic alu_src,
    output logic mem_write,
    output logic result_src,
    output logic pc_src,
    output logic [2:0] alu_control
);
    always_comb begin
        reg_write = 0;
        imm_src = 2'b00;
        alu_src = 0;
        mem_write = 0;
        result_src = 0;
        pc_src = 0;
        alu_control = 3'b000;
        case (instr[6:0])
            // lw
            7'b0000011: begin
                reg_write = 1;
                imm_src = 2'b00;
                alu_src = 1;
                mem_write = 0;
                result_src = 1;
                pc_src = 0;
                alu_control = 3'b000;
            end
            // bne
            7'b1100011: begin
                reg_write = 0;
                imm_src = 2'b10;
                alu_src = 0;
                mem_write = 0;
                pc_src = !zero;
                alu_control = 3'b001;
            end
            // addi
            7'b0010011: begin
                reg_write = 1;
                imm_src = 2'b00;
                alu_src = 1;
                mem_write = 0;
                result_src = 0;
                pc_src = 0;
                alu_control = 3'b000;
            end
            default: ;
        endcase
    end
endmodule
