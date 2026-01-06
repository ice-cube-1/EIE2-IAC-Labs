module decode (
    input logic[31:0] instr_d,
    input logic[31:0] pc_d,
    input logic[31:0] pc_plus_4_d,
    input logic[4:0] rd_w,
    input logic [31:0] result_w,
    input logic reg_write_w,
    input logic clk,
    output logic[31:0] rd1_e, rd2_e, pc_e, imm_ext_e, pc_plus_4_e,
    output logic [4:0] rd_e,
    output logic [10:0] control_bus_e
);
logic [1:0] alu_op;
logic [11:0] control_bus;
logic [6:0] op = instr_d[6:0];
logic [2:0] imm_src, alu_control;
logic [31:0] rf_registers [31:0];
logic [31:0] rd1, rd2;
always_ff @(posedge clk) begin
    rd1_e <= rd1;
    rd2_e <= rd2;
    pc_e <= pc_d;
    rd_e <= instr[11:7];
    imm_ext_e <= imm_op
    pc_plus_4_e <= pc_plus_4_d;
    control_bus_e <= control_bus;
end
always_ff @(negedge clk) if (reg_write_w) rf_registers[rd_w] <= result_w;
always_comb begin
    rd1 = rf_registers[instr[19:15]];
    rd2 = rf_registers[instr[24:20]];
    control_bus[0] = (op == 7'b0010011 || op == 7'b0110011 || op == 7'b0110111 || op == 7'b0000011 || op == 7'b1101111);
    control_bus[3] = (op == 7'b0100011);
    control_bus[9] = ~(op == 7'b1100011 || op == 7'b0110011);
    control_bus[5] = (op == 7'b1100011);
    control_bus[4] = (op == 7'b1101111 || op == 7'b1100111);
    control_bus[10] = (op == 7'b1100111) || (op == 7'b1100011 && instr[12]);
    imm_src = 3'b000;
    control_bus[2:1] = 2'b00;
    alu_op = 2'b00;
    case (op)
        7'b0010011: alu_op = 2'b10; // I-TYPE
        7'b0110011: alu_op = 2'b10; // R-TYPE
        7'b0110111: imm_src = 3'b011; // LUI
        7'b0100011: imm_src = 3'b001; // SB
        7'b0000011: control_bus[2:1] = 2'b01; // LBU
        7'b1101111: begin // JAL
            imm_src = 3'b100;
            control_bus[2:1] = 2'b10;
        end 
        7'b1100111: begin // JALR (specifically RET as does not write to linking register)
            control_bus[2:1] = 2'b10;
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
            case (instr_d[14:12])
                3'b000: alu_control = (instr_d[30] & instr_d[5]) ? 3'b001 : 3'b000;
                3'b010: alu_control = 3'b101;
                3'b110: alu_control = 3'b011;
                3'b111: alu_control = 3'b010;
                3'b100: alu_control = 3'b100;
                3'b001: alu_control = 3'b110;
                default: alu_control = 3'b111;
            endcase
        end
    endcase
    case (imm_src)
        3'b00: imm_op = {{20{instr[31]}},instr[31:20]};
        3'b01: imm_op = {{20{instr[31]}},instr[31:25],instr[11:7]};
        3'b10: imm_op = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
        3'b11: imm_op = {instr[31:12], {12{1'b0}}};
        3'b100: imm_op = {{12{instr[31]}}, instr[19:12], instr[11], instr[30:21], 1'b0};
        default: imm_op = 32'b0;
    endcase
    control_bus[8:6] = alu_control
end
endmodule