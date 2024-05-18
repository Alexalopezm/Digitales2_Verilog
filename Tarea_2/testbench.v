// Tarea 2. Calculadora de 8 bits.
// Realizar las conexiones del módulo de tester con el módulo de DUT.
// Código realizado por Alexa López Marcos. Carnet B94353.

`include "Calculadora.v"
`include "tester.v"

module testbench;

wire clk, rst, en;
wire [1:0] MODO;
wire [7:0] a;
wire [7:0] b;
wire [7:0] c;

    Calculadora DUT(
        .clk(clk),
        .rst(rst),
        .en(en),
        .MODO(MODO[1:0]),
        .a(a[7:0]),
        .b(b[7:0]),
        .c(c[7:0])
    );

    tester test(
        .clk(clk),
        .rst(rst),
        .en(en),
        .MODO(MODO[1:0]),
        .a(a[7:0]),
        .b(b[7:0]),
        .c(c[7:0])
    );

    initial begin
        $dumpfile("tb1.vcd");
        $dumpvars;
    end

endmodule
