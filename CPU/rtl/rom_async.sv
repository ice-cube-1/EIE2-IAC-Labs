module rom_async #( parameter ADDRESS_WIDTH = 7, DATA_WIDTH = 8 ) (
    input logic [ADDRESS_WIDTH-1:0] addr,
    output logic [31:0] dout
);
    logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];
    initial begin
        $readmemh("/home/alice/EIE2-IAC-Labs/lab4/rtl/program.hex", rom_array);
        $display("loaded rom");
    end;
    always_comb
        dout = { rom_array[addr+3],
                rom_array[addr+2],
                rom_array[addr+1],
                rom_array[addr] };

endmodule
