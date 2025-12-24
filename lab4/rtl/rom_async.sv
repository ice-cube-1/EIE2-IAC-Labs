module rom_async #( parameter ADDRESS_WIDTH = 5, DATA_WIDTH = 32 ) (
    input logic [ADDRESS_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] dout
);
    logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];
    initial begin
        $readmemh("instructions.mem", rom_array);
        $display("loaded rom");
    end;
    always_comb
        dout = rom_array [addr];
endmodule
