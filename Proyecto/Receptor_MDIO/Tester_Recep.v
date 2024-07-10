/* 
Proyecto Final Circuitos Digitales 2

Archivo: Tester_Recep.v 

Descripciòn: Este archivo contiene el tester del receptor para el protocolo MDIO

Autores: Alexa Lòpez, Sylvia Fonseca, Manfred Soza, Àngeles Ulate
*/


`timescale 1ns/1ns // Escala de tiempo

module Tester_Recep(
    // Definiciòn de las entradas y salidas del tester

    // Entradas
    input [4:0] ADDR,
    input MDIO_DONE,
    input WR_STB,
    input [15:0] WR_DATA,
    input MDIO_IN,
    // Salidas
    output reg rst,
    output reg MDC,
    output reg MDIO_OE,
    output reg MDIO_OUT,
    output reg [15:0] RD_DATA
);

// Simulación del comportamiento de MDC, mismo que es del doble de clk, para que cada periodo tarde 4 ns, 2 en bajo y 2 en alto.
always begin
    #2 MDC = !MDC;
end


initial begin
    // Inicialización de las señales del receptor
    MDC = 0;
    RD_DATA = 16'b0000_0000_0000_0000;
    MDIO_OUT = 1'b0;
    MDIO_OE=0;
    rst = 0; // Reset en 0 indica inhabilitaciòn y valores bajos en las salidas
    #6;


    //_________________________________________________________________________________//
    //                   PLAN DE PRUEBAS PARA EL GENERADOR                             //
    //_________________________________________________________________________________//

    //--------------------------------------------------------------------------
    //  1. Para transacciòn de Lectura (bits 3 y 4 del frame de MDIO: 10)
    //--------------------------------------------------------------------------
    
    rst = 1; // Reset en 1 indica habilitaciòn del receptor

    // Se define MDIO_OUT con el tercer y cuarto bit en 10
    // MDIO_OUT = 32'b0110_0101_1000_0000_0000_0000_0000_0000; CASO PHY, es el que se utiliza

    // MDIO_OUT = 32'b0110_0000_0110_0100_0000_0000_0000_0000; CASO REG

    // Se envìan bit a bit por MDIO_OUT los 32 bits del frame bàsico de transacciones de MDIO.
    // Primeros 16 bits
    // Grupo de 4 bits (0110)
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    // Grupo de 4 bits (0101)
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b1;
    #4;
    // Grupo de 4 bits (1000)
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    // Ùltimos 4 bits (0000)
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;

    // Segundos 16 bits
    // Grupo de 4 bits (0000)
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    // Grupo de 4 bits (0000)
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    // Grupo de 4 bits (0000)
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    // Ùltimos 4 bits (0000)
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;

    // Para que MDIO_OUT se mantenga en bajo
    MDIO_OUT = 1'b0;
    #8;

    // Informaciòn de RD_DATA
    #64;
    RD_DATA = 16'b1100_1001_0000_0001;

    // MDIO_OE según LECTURA
    MDIO_OE=1;
    #64;
    MDIO_OE=0;
    #64;

    //-------------------------------------------------------------------------
    //  2. Para resetear y continuar al siguiente caso
    //-------------------------------------------------------------------------

    // Aplicaciòn del Reset en 0, lo que indica inhabilitaciòn y valores bajos en las salidas
    rst = 0;
    RD_DATA = 16'b0000_0000_0000_0000;
    #8;
    // Pasados 2 ciclos de reloj, se habilita nuevamente el funcionamiento normal del receptor
    rst = 1;


    //--------------------------------------------------------------------------
    //  3. Para transacciòn de Escritura (bits 3 y 4 del frame de MDIO: 01)
    //--------------------------------------------------------------------------

    // Se define MDIO_OUT con el tercer y cuarto bit en 01
    // MDIO_OUT = 32'b0101_1101_1000_0000_1000_1000_1000_0001; CASO PHY, caso utilizado

    // MDIO_OUT = 32'b0101_0000_0100_1100_0000_0000_0000_0000; CASO REG

    // Se envìan bit a bit por MDIO_OUT los 32 bits del frame bàsico de transacciones de MDIO.
    // Primeros 16 bits
    // Grupo de 4 bits (0101)
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b1;
    #4;
    // Grupo de 4 bits (1101)
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b1;
    #4;
    // Grupo de 4 bits (1000)
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    // Ùltimos 4 bits (0000)
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;

    // Segundos 16 bits
    // Grupo de 4 bits (1000)
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    // Grupo de 4 bits (1000)
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    // Grupo de 4 bits (1000)
    MDIO_OUT = 1'b1;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    // Ùltimos 4 bits (0001)
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b0;
    #4;
    MDIO_OUT = 1'b1;
    #4;

    // Para que MDIO_OUT se mantenga en bajo
    MDIO_OUT = 1'b0;
    #8;

    // MDIO_OE según ESCRITURA
    MDIO_OE=1;
    #64;
    MDIO_OE=1;
    #64;
    MDIO_OE=0;
    #60;


    //___________________________FIN PLAN DE PRUEBAS_______________________________
    $finish;
end

endmodule