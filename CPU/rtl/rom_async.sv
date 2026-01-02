module rom_async #() (
    input logic [31:0] addr,
    output logic [31:0] dout
);
    logic [7:0] rom_array [3217035263:3217031168];
    initial begin
        $readmemh("program.hex", rom_array);
    end;
    always_comb
        dout = { rom_array[addr+3],
                rom_array[addr+2],
                rom_array[addr+1],
                rom_array[addr] };

endmodule
