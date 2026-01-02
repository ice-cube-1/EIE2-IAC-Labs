module control_unit (
    input logic [31:0] instr,
    input logic zero,
    output logic reg_write,
    output logic [2:0] imm_src,
    output logic alu_src,
    output logic mem_write,
    output logic [1:0] result_src, pc_src,
    output logic [2:0] alu_control
);
    logic [1:0] alu_op;
    always_comb begin
        reg_write = 0;
        imm_src = 3'b00;
        alu_src = 0;
        mem_write = 0;
        result_src = 0;
        pc_src = 0;
        case (instr[6:0])
            // beq / bne (does not work for other branch types)
            7'b1100011: begin
                reg_write = 0;
                imm_src = 3'b10;
                alu_src = 0;
                mem_write = 0;
                pc_src = {1'b0, zero ^ instr[12]};
                alu_op = 2'b01;
            end
            // i-type e.g. addi
            7'b0010011: begin
                reg_write = 1;
                imm_src = 3'b00;
                alu_src = 1;
                mem_write = 0;
                result_src = 0;
                pc_src = 0;
                alu_op = 2'b10;
            end
            // r-type e.g. add
            7'b0110011: begin
                reg_write = 1;
                alu_src = 0;
                mem_write = 0;
                result_src = 0;
                pc_src = 0;
                alu_op = 2'b10;
            end
            // lui
            7'b0110111: begin
                reg_write = 1;
                imm_src = 3'b11;
                alu_src = 1;
                mem_write = 0;
                result_src = 0;
                pc_src = 0;
                alu_op = 2'b00;
            end
            // sb
            7'b0100011: begin
                reg_write = 0;
                imm_src = 3'b01;
                alu_src = 1;
                mem_write = 1;
                pc_src = 0;
                alu_op = 2'b00;
            end
            // lbu
            7'b0000011: begin
                reg_write = 1;
                imm_src = 3'b00;
                alu_src = 1;
                mem_write = 0;
                result_src = 1;
                pc_src = 0;
                alu_op = 2'b00;
            end
            // jal
            7'b1101111: begin
                reg_write = 1;
                imm_src = 3'b100;
                alu_src = 1;
                mem_write = 0;
                result_src = 2'b10;
                pc_src = 1;    
            end 
            // jalr
            7'b1100111: begin
                reg_write = 1;
                imm_src = 3'b00;
                alu_src = 1;
                mem_write = 0;
                result_src = 2'b10;
                pc_src = 2'b10;
            end
            default: ;
        endcase
        case (alu_op) 
            2'b00: alu_control = 3'b000;
            2'b01: alu_control = 3'b001;
            default: begin
                if (instr[14:12] == 3'b000) begin
                    if (instr[5] & instr[29]) alu_control = 3'b001;
                    else alu_control = 3'b000;
                end else if (instr[14:12] == 3'b010) alu_control = 3'b101;
                else if (instr[14:12] == 3'b110) alu_control = 3'b011;
                else if (instr[14:12] == 3'b111) alu_control = 3'b010;
            end
        endcase
    end
endmodule
