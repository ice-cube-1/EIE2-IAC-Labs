module alu (
    input logic [2:0] alu_control,
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] result,
    output logic zero
);
    always_comb begin
        case (alu_control)
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = ($signed(a) < $signed(b));
            3'b110: result = a << b[4:0];
            3'b111: result = a >> b[4:0];
            default: result = 32'b0;
        endcase
    end
    assign zero = (result == 32'b0);
endmodule