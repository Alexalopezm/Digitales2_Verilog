// Tarea 2. Calculadora de 8 bits.
// Realizar un módulo de tester para comprobar el funcionamiento de la calculadora
// Se realizan 2 pruebas de cada modo de la calculadora.
// Código realizado por Alexa López Marcos. Carnet B94353.

`timescale 1ns/1ns

module tester(
    input [7:0] c,          // Salida de la operación realizada
    output reg clk,                  // Reloj
    output reg rst,                  // Señal de reset
    output reg en,                   // Señal de enable
    output reg [7:0] a,              // Primer número ingresado
    output reg [7:0] b,              // Segundo número ingresado
    output reg [1:0] MODO            // Tipo de operación a realizar
);

/*
Se definen los parametros de la calculodora,
esto para comparar más facilmente la entrada MODO
*/
parameter suma = 2'b00;
parameter resta = 2'b01;
parameter multiplica = 2'b10;
parameter left_shift = 2'b11;


always begin
    #1 clk = !clk;
end 

initial begin
    // Inicialización de las señales
    clk = 0;
    rst = 0;
    en = 1;
    a = 8'b00000000;
    b = 8'b00000000;
    #3;

    // Primera ronda de pruebas
    //_____________________________________________________________________________________

    MODO=suma;
    a = 8'b10010001;        // 145 expresado en 8 bits
    b = 8'b00101010;        // 42 expresado en 8 bits
    // c = 8'b10111011 (187 en decimal)
    #4;
    
    // Acción de reset luego de cada operación
    en = 0;
    rst = 1;
    a = 8'b00000000;
    b = 8'b00000000;
    #2;
    en = 1;
    rst = 0;

    MODO=resta;
    a = 8'b01111111;        // 127 expresado en 8 bits
    b = 8'b00111111;        // 63 expresado en 8 bits
    // c = 8'b1000000 (64 en decimal)
    #4;
    
    // Acción de reset luego de cada operación
    en = 0;
    rst = 1;
    a = 8'b00000000;
    b = 8'b00000000;
    #2;
    en = 1;
    rst = 0;

    MODO=multiplica;
    a = 8'b00111111;        // 63 expresado en 8 bits
    b = 8'b00000100;        // 4 expresado en 8 bits
    // c = 8'b11111100 (252 en decimal)
    #4;

    // Acción de reset luego de cada operación
    en = 0;
    rst = 1;
    a = 8'b00000000;
    b = 8'b00000000;
    #2;
    en = 1;
    rst = 0;

    MODO=left_shift;
    a = 8'b00000110;        // 6 expresado en 8 bits
    b = 8'b00000000;        // 0 expresado en 8 bits
    // c = 8'b00001100 (12 en decimal)
    #4;

    // Acción de reset luego de cada operación
    en = 0;
    rst = 1;
    a = 8'b00000000;
    b = 8'b00000000;
    #2;
    en = 1;
    rst = 0;

    // // Segunda ronda de pruebas
    // //_____________________________________________________________________________________

    MODO=suma;
    a = 8'b01111111;        // 127 expresado en 8 bits
    b = 8'b00111111;        // 63 expresado en 8 bits
    // c = 8'b10111110 (190 en decimal)
    #4;

    // Acción de reset luego de cada operación
    en = 0;
    rst = 1;
    a = 8'b00000000;
    b = 8'b00000000;
    #2;
    en = 1;
    rst = 0;

    MODO=resta;
    a = 8'b10010001;        // 145 expresado en 8 bits
    b = 8'b00101010;        // 42 expresado en 8 bits
    // c = 8'b1100111 (103 en decimal)
    #4;

    // Acción de reset luego de cada operación
    en = 0;
    rst = 1;
    a = 8'b00000000;
    b = 8'b00000000;
    #2;
    en = 1;
    rst = 0;

    MODO=multiplica;
    a = 8'b00111101;        // 61 expresado en 8 bits
    b = 8'b00000010;        // 2 expresado en 8 bits
    // c = 8'b1111010 (122 en decimal)
    #4;

    // Acción de reset luego de cada operación
    en = 0;
    rst = 1;
    a = 8'b00000000;
    b = 8'b00000000;
    #2;
    en = 1;
    rst = 0;

    MODO=left_shift;
    a = 8'b00100110;        // 38 expresado en 8 bits
    b = 8'b00000000;        // 0 expresado en 8 bits
    // c = 8'b1001100 (76 en decimal)
    #4;

    // Acción de reset luego de la última operación
    en = 0;
    rst = 1;
    a = 8'b00000000;
    b = 8'b00000000;
    #2;
    en = 1;
    rst = 0;
    #4;


    // Finalización de la simulación
    $finish;
end


endmodule