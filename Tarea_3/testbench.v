`include "master.v"
`include "slave1.v"

module testbench (
    output reg clk,
    output reg reset,
    output MISO,
    output reg [15:0] datain,
    input spi_cs1_l,
    input spi_cs2_l,
    input sclk,
    input spi_data,
    input [15:0] counter
);

master maestro (
    .clk(clk),
    .reset(reset),
    .datain(datain),
    .spi_cs1_l(spi_cs1_l),
    .spi_cs2_l(spi_cs2_l),
    .sclk(sclk),
    .spi_data(spi_data),
    .mensaje(mensaje),
    .MISO(MISO),
    .counter(counter)
);

slave1 esclavo1 (
    .reset(reset),
    .spi_cs_l(spi_cs1_l),
    .sclk(sclk),
    .spi_data_in(spi_data),
    .mensaje(mensaje),
    .spi_data_out(MISO)
);

slave1 esclavo2 (
    .reset(reset),
    .spi_cs_l(spi_cs2_l),
    .sclk(sclk),
    .spi_data_in(spi_data),
    .mensaje(mensaje),
    .spi_data_out(MISO)
);

always #5 clk = !clk;

initial begin
    reset = 1;
    clk = 1;
    datain = 0;
    #10;
    reset = 0;
    #10;
    datain = 16'hA569;
    #725;
    $finish;
end

initial begin
    $dumpfile("tb.vcd");
    $dumpvars;
end

    
endmodule