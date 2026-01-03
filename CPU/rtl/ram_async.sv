module ram_async #() (
    input logic [31:0] addr,
    input logic mem_write,
    input logic clk,
    input logic [31:0] write_data,
    output logic [31:0] dout
);
    logic [7:0] ram_array [131071:0];
    initial $readmemh("data.hex", ram_array, 65536);
    always_comb dout = {24'b0, ram_array[addr]};
    always_ff @(posedge clk) if (mem_write) ram_array[addr] <= write_data[7:0];
endmodule
