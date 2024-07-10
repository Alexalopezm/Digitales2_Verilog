/* 
Proyecto Final Circuitos Digitales 2

Archivo: Testbench_Recep.v 

Descripciòn: Este archivo contiene el testbench del receptor para el protocolo MDIO

Autores: Alexa Lòpez, Sylvia Fonseca, Manfred Soza, Àngeles Ulate
*/

// Inclusiòn de los archivos del receptor correspondientes al DUT y Tester
`include "Recep_MDIO.v"
`include "Tester_Recep.v"


module Testbench_Recep;
// Definiciòn de las entradas y salidas del testbench

// Entradas
wire rst, MDC, MDIO_OE, MDIO_OUT;   // Sin tamaño
wire [15:0] RD_DATA;
// Salidas
wire MDIO_DONE, WR_STB, MDIO_IN;    // Sin tamaño
wire [4:0] ADDR;
wire [15:0] WR_DATA;

// Instanciaciòn del mòdulo del DUT del receptor
Recep_MDIO Recep(
    .rst(rst),
    .MDC(MDC),
    .MDIO_OE(MDIO_OE),
    .MDIO_OUT(MDIO_OUT),
    .RD_DATA(RD_DATA[15:0]),
    .MDIO_DONE(MDIO_DONE),
    .WR_STB(WR_STB),
    .MDIO_IN(MDIO_IN),
    .ADDR(ADDR[4:0]),
    .WR_DATA(WR_DATA[15:0])
);

// Instanciaciòn del mòdulo del tester del receptor
Tester_Recep tester(
    .rst(rst),
    .MDC(MDC),
    .MDIO_OE(MDIO_OE),
    .MDIO_OUT(MDIO_OUT),
    .RD_DATA(RD_DATA[15:0]),
    .MDIO_DONE(MDIO_DONE),
    .WR_STB(WR_STB),
    .MDIO_IN(MDIO_IN),
    .ADDR(ADDR[4:0]),
    .WR_DATA(WR_DATA[15:0])
);

// Para generar las ondas y visualizar en GTKWave
initial begin
        $dumpfile("tb.vcd");
        $dumpvars;
    end

endmodule