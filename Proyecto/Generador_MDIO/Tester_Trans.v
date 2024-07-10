/* 
Proyecto Final Circuitos Digitales 2

Archivo: Tester_Trans.v 

Descripciòn: Este archivo contiene el tester del generador para el protocolo MDIO

Autores: Alexa Lòpez, Sylvia Fonseca, Manfred Soza, Àngeles Ulate
*/


`timescale 1ns/1ns // Escala de tiempo


module Tester_Trans (
    // Definiciòn de las entradas y salidas del tester

    // Entradas
    input [15:0] RD_DATA,
    input DATA_RDY,
    input MDC,
    input MDIO_OE,
    input MDIO_OUT,
    // Salidas
    output reg clk,
    output reg rst,
    output reg [31:0] T_DATA, 
    output reg MDIO_START, 
    output reg MDIO_IN
    
);

// Definciòn del comportamiento del clock para que cada periodo tarde 2 ns, 1 en bajo y 1 en alto.
always begin
    #1 clk = !clk;
end


initial begin
    // Inicialización de las señales del generador-transmisor
    clk = 0;
    MDIO_IN = 1'b0;
    MDIO_START = 0;
    rst = 0; // Reset en 0 indica inhabilitaciòn y valores bajos en las salidas
    #2;

    //_________________________________________________________________________________//
    //                   PLAN DE PRUEBAS PARA EL GENERADOR                             //
    //_________________________________________________________________________________//

    //--------------------------------------------------------------------------
    //  1. Para transacciòn de Escritura (bits 3 y 4 del frame de MDIO: 01)
    //--------------------------------------------------------------------------

    // Se define T_DATA con el tercer y cuarto bt en 01
    T_DATA = 32'b1001_0101_0011_0110_1010_1110_0101_0011;
    rst = 1; // Reset en 0 indica habilitaciòn del funcionamiento normal del generador

    $display("T_DATA: %b", T_DATA); // Mostrar T_DATA en la consola

    // Se activa durante un pulso de un ciclo de reloj para indicar al generador que se
    // ha cargado un valor en la entrada T_DATA
    MDIO_START = 1;
    #2;
    MDIO_START = 0;
    #151;

    //-------------------------------------------------------------------------
    //  2. Para resetear y continuar al siguiente caso
    //-------------------------------------------------------------------------

    // Aplicaciòn del Reset en 0, lo que indica inhabilitaciòn y valores bajos en las salidas
    rst = 0;
    #8;
    // Pasados 4 ciclos de reloj, se habilita nuevamente el funcionamiento normal del generador
    rst = 1; // Se comporta normalmente


    //-------------------------------------------------------------------------
    //  3. Para transacciòn de Lectura (bits 3 y 4 del frame de MDIO: 10)
    //-------------------------------------------------------------------------

    // Se define T_DATA con el tercer y cuarto bit en 10
    T_DATA = 32'b1010_0101_0011_0110_1010_1110_0101_0011;
    $display("T_DATA: %b", T_DATA); // Mostrar T_DATA en la consola

    // Se activa durante un pulso de un ciclo de reloj para indicar al generador que se
    // ha cargado un valor en la entrada T_DATA
    MDIO_START = 1;
    #2;
    MDIO_START = 0;
    #70;

    // Definición de cada uno de los bits de MDIO_IN
    
    //MDIO_IN = 1'b0;
    //#32;

    MDIO_IN = 1'b1;
    #2;
    MDIO_IN = 1'b0;
    #2;
    MDIO_IN = 1'b1;
    #2;
    MDIO_IN = 1'b0;
    #2;


    MDIO_IN = 1'b1;
    #2;
    MDIO_IN = 1'b1;
    #2;
    MDIO_IN = 1'b1;
    #2;
    MDIO_IN = 1'b0;
    #2;


    MDIO_IN = 1'b0;
    #2;
    MDIO_IN = 1'b1;
    #2;
    MDIO_IN = 1'b0;
    #2;
    MDIO_IN = 1'b1;
    #2;


    MDIO_IN = 1'b0;
    #2;
    MDIO_IN = 1'b0;
    #2;
    MDIO_IN = 1'b1;
    #2;
    MDIO_IN = 1'b1;
    #2;

    // Para que la señal quede en 0
    MDIO_IN = 1'b0;
    #43;


    //___________________________FIN PLAN DE PRUEBAS_______________________________
    $finish;
end
endmodule