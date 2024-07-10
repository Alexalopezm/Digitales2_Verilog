/* 
Proyecto Final Circuitos Digitales 2

Archivo: Testbench_Trans.v 

Descripciòn: Este archivo contiene el testbench del generador para el protocolo MDIO

Autores: Alexa Lòpez, Sylvia Fonseca, Manfred Soza, Àngeles Ulate
*/

// Inclusiòn de los archivos del generador-transmisor correspondientes al DUT y Tester
`include "Tester_Trans.v"
`include "Trans_MDIO.v"

module Testbench_Trans;
// Definiciòn de las entradas y salidas del testbench
wire clk, rst;
wire [31:0] T_DATA;
wire [15:0] RD_DATA;
wire MDIO_IN;
wire MDIO_START, DATA_RDY, MDC, MDIO_OE, MDIO_OUT;

    // Instanciaciòn del mòdulo del DUT del generador-transmisor
    Trans_MDIO Transmisor(
        .clk(clk),
        .rst(rst),
        .T_DATA(T_DATA[31:0]),
        .MDIO_START(MDIO_START),
        .MDIO_IN(MDIO_IN),
        .RD_DATA(RD_DATA[15:0]),
        .DATA_RDY(DATA_RDY),
        .MDC(MDC),
        .MDIO_OE(MDIO_OE),
        .MDIO_OUT(MDIO_OUT)
    );

    // Instanciaciòn del mòdulo del tester del generador-transmisor
    Tester_Trans tester(
        .clk(clk),
        .rst(rst),
        .T_DATA(T_DATA),
        .MDIO_START(MDIO_START),
        .MDIO_IN(MDIO_IN),
        .RD_DATA(RD_DATA),
        .DATA_RDY(DATA_RDY),
        .MDC(MDC),
        .MDIO_OE(MDIO_OE),
        .MDIO_OUT(MDIO_OUT)
    );

// Para generar las ondas y visualizar en GTKWave
initial begin
        $dumpfile("tb.vcd");
        $dumpvars;
    end

endmodule