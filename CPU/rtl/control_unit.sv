module control_unit (
    input logic [31:0] instr,
    output logic alu_src, mem_write, reg_write, jump, branch,pc_reg,
    output logic [1:0] result_src,
    output logic [2:0] alu_control, imm_src
);
    logic [1:0] alu_op;
    logic [6:0] op = instr[6:0];
    assign reg_write = (op == 7'b0010011 || op == 7'b0110011 || op == 7'b0110111 || op == 7'b0000011 || op == 7'b1101111);
    assign mem_write = (op == 7'b0100011);
    assign alu_src = ~(op == 7'b1100011 || op == 7'b0110011);
    assign branch = (op == 7'b1100011);
    assign jump = (op == 7'b1101111 || op == 7'b1100111);
    assign pc_reg = (op == 7'b1100111);
    always_comb begin
        imm_src = 3'b000;
        result_src = 2'b00;
        alu_op = 2'b00;
        case (op)
            7'b0010011: alu_op = 2'b10; // I-TYPE
            7'b0110011: alu_op = 2'b10; // R-TYPE
            7'b0110111: imm_src = 3'b011; // LUI
            7'b0100011: imm_src = 3'b001; // SB
            7'b0000011: result_src = 2'b01; // LBU
            7'b1101111: begin // JAL
                imm_src = 3'b100;
                result_src = 2'b10;
            end 
            7'b1100111: begin // JALR (specifically RET as does not write to linking register)
                result_src = 2'b10;
            end
            7'b1100011: begin // BEQ / BNE (does not work for other branch types)
                imm_src = 3'b010;
                alu_op = 2'b01;
            end
            default: ;
        endcase
        case (alu_op) 
            2'b00: alu_control = 3'b000;
            2'b01: alu_control = 3'b001;
            default: begin
                case (instr[14:12])
                    3'b000: alu_control = (instr[30] & instr[5]) ? 3'b001 : 3'b000;
                    3'b010: alu_control = 3'b101;
                    3'b110: alu_control = 3'b011;
                    3'b111: alu_control = 3'b010;
                    3'b100: alu_control = 3'b100;
                    3'b001: alu_control = 3'b110;
                    default: alu_control = 3'b111;
                endcase
            end
        endcase
    end
endmodule
