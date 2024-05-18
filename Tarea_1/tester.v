// Código realizado por Alexa López Marcos. Carnet B94353.

`timescale 1ns/1ns

module tester(
    input SECADO,               // Salida de secado
    input LAVADO,               // Salida de lavado
    input LAVADO_PESADO,        // Salida de lavado pesado
    input INSUFICIENTE,         // Señal de insuficiencia
    output reg clk,             // Reloj
    output reg INTRO_MONEDA,    // Señal de ingreso de monedas
    output reg FINALIZAR_PAGO,  // Botón de finalizar pago
    output reg RESET            // Señal de reset
);

always begin
    #1 clk = !clk;
end 

initial begin
    clk=1;
    RESET=0;
    FINALIZAR_PAGO=0;
    INTRO_MONEDA=0;
    #1
    //---------------------------------------------------------------------------------------------------
    // Prueba de 3 monedas, para activar la señal SECADO
    repeat (6) begin
        #1 INTRO_MONEDA = !INTRO_MONEDA;
    end 

    /*Se aplica la señal de FINALIZAR_PAGO y luego la señal de RESET,
    esto para que las señales se inicalicen para la siguiente entrada de monedas*/ 

    #3
    FINALIZAR_PAGO = 1;
    #10
    FINALIZAR_PAGO = 0;
    #3
    RESET =1;
    #2
    RESET =0;
    #4
    //---------------------------------------------------------------------------------------------------
    // Prueba de 4 monedas, para activar la señal LAVADO
    repeat (8) begin
        #1 INTRO_MONEDA = !INTRO_MONEDA;
    end 

    /*Se aplica la señal de FINALIZAR_PAGO y luego la señal de RESET,
    esto para que las señales se inicalicen para la siguiente entrada de monedas*/

    #3
    FINALIZAR_PAGO = 1;
    #10
    FINALIZAR_PAGO = 0;
    #3
    RESET =1;
    #2
    RESET =0;
    #4
    //---------------------------------------------------------------------------------------------------
    // Prueba de 9 monedas, para activar la señal SECADO
    repeat (18) begin
        #1 INTRO_MONEDA = !INTRO_MONEDA;
    end 

    #3
    FINALIZAR_PAGO = 1;
    #10
    FINALIZAR_PAGO = 0;
    #3
    RESET =1;
    #2
    RESET =0;
    #4
    //---------------------------------------------------------------------------------------------------
    // Prueba de 2 monedas, para activar la señal INSUFICIENTE.
    // En este caso con la introducción de una cantidad entre 1 y 3 monedas en la lavadora.
    repeat (4) begin
        #1 INTRO_MONEDA = !INTRO_MONEDA;
    end 

    /*Se aplica la señal de FINALIZAR_PAGO y luego la señal de RESET,
    esto para que las señales se inicalicen para la siguiente entrada de monedas*/ 

    #3
    FINALIZAR_PAGO = 1;
    #10
    FINALIZAR_PAGO = 0;
    #3
    RESET =1;
    #2
    RESET =0;
    #4
    //---------------------------------------------------------------------------------------------------
    // Prueba de 5 monedas, para activar la señal INSUFICIENTE.
    // En este caso con la introducción de una cantidad entre 4 y 9 monedas en la lavadora.
    repeat (10) begin
        #1 INTRO_MONEDA = !INTRO_MONEDA;
    end 

    /*Se aplica la señal de FINALIZAR_PAGO y luego la señal de RESET,
    esto para que las señales se inicalicen para la siguiente entrada de monedas*/ 

    #3
    FINALIZAR_PAGO = 1;
    #10
    FINALIZAR_PAGO = 0;
    #3
    RESET =1;
    #2
    RESET =0;
    #4
    //---------------------------------------------------------------------------------------------------
    // Prueba de 10 monedas, para activar la señal INSUFICIENTE.
    // En este caso con la introducción de más de 9 monedas en la lavadora.
    repeat (22) begin
        #1 INTRO_MONEDA = !INTRO_MONEDA;
    end 

    /*Se aplica la señal de FINALIZAR_PAGO y luego la señal de RESET,
    esto para que las señales se inicalicen para la siguiente entrada de monedas*/ 

    #3
    FINALIZAR_PAGO = 1;
    #10
    FINALIZAR_PAGO = 0;
    #3
    RESET =1;
    #2
    RESET =0;
    #5
    // Finalización de la simulación
    $finish;
end


endmodule