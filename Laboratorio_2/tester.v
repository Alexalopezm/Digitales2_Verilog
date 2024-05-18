// Circuitos Digitales II - Laboratorio II - 17 de Mayo del 2024.
// Código de Alexa López Marcos B94353  y Angeles Ulate Jarquín C07908

// CONTROLADOR PARA UN CAJERO AUTOMÁTICO DEL BANCO DE COSTA RICA
// Módulo TESTER

`timescale 1ns/1ns

module tester (
    // Entradas
    input BALANCE_ACTUALIZADO,
    input ENTREGAR_DINERO,
    input FONDOS_INSUFICIENTES,
    input PIN_INCORRECTO,
    input ADVERTENCIA,
    input BLOQUEO,
    // Salidas
    // Las de 1 bit
    output reg CLK, 
    output reg RESET, 
    output reg TARJETA_RECIBIDA, 
    output reg TIPO_TARJETA,
    output reg DIGITO_STB, 
    output reg TIPO_TRANS, 
    output reg MONTO_STB,
    // Las de más de 2 bits
    output reg [15:0] PIN, 
    output reg [3:0] DIGITO,
    output reg [31:0] MONTO
);


always begin
    #1 CLK = !CLK;
end 

// Condiciones de las entradas
initial begin
    CLK = 0;
    PIN = 16'b0100001101010011;
    RESET = 1;
    DIGITO= 4'b0000;
    DIGITO_STB = 0;
    MONTO = 0;
    TARJETA_RECIBIDA = 0;
    TIPO_TARJETA = 0;
    TIPO_TRANS = 0; 
    MONTO_STB = 0;
    #2;
    RESET = 0;
    #4;
    // //___________________________________________________________________________________________________________
    // // Caso 1
    // // Pin Acertado + Deposito
    
    // TARJETA_RECIBIDA = 1;
    // TIPO_TARJETA = 1;       // Banco Privado
    // #2;

    // // Digitos Pin
    // DIGITO_STB = 1;
    // DIGITO= 4'b0100; // Dígito 1 (4)
    // #1;
    // DIGITO_STB = 0;
    // #1;
    // //_______________________
    // DIGITO_STB = 1;
    // DIGITO= 4'b0011; // Dígito 2 (3)
    // #1;
    // DIGITO_STB = 0;
    // #1;
    // //_______________________
    // DIGITO_STB = 1;
    // DIGITO= 4'b0101; // Dígito 3 (5)
    // #1;
    // DIGITO_STB = 0;
    // #1;
    // //_______________________
    // DIGITO_STB = 1;
    // DIGITO= 4'b0011; // Dígito 4 (3)
    // #1;
    // DIGITO_STB = 0;
    // #1;
    // // Termino de ingresar el pin
    
    // TIPO_TRANS = 0;     // Deposito
    // #25;
    // MONTO_STB = 1;
    // MONTO = 200;        // Digito el monto 200
    
    // #2;
    // RESET = 1;          // Reinicio
    // MONTO_STB = 0;      // Señal en 1 un ciclo
    // MONTO = 0;          // Digito el monto 200      
    // #2;
    // RESET =0;
    // #2;

    // //___________________________________________________________________________________________________________
    // // Caso 2
    // // Pin Acertado + Retiro
    
    // TARJETA_RECIBIDA = 1;
    // TIPO_TARJETA = 1;       // Banco Privado
    // #2;

    // // Digitos Pin
    // DIGITO_STB = 1;
    // DIGITO= 4'b0100; // Dígito 1 (4)
    // #1;
    // DIGITO_STB = 0;
    // #1;
    // //_______________________
    // DIGITO_STB = 1;
    // DIGITO= 4'b0011; // Dígito 2 (3)
    // #1;
    // DIGITO_STB = 0;
    // #1;
    // //_______________________
    // DIGITO_STB = 1;
    // DIGITO= 4'b0101; // Dígito 3 (5)
    // #1;
    // DIGITO_STB = 0;
    // #1;
    // //_______________________
    // DIGITO_STB = 1;
    // DIGITO= 4'b0011; // Dígito 4 (3)
    // #1;
    // DIGITO_STB = 0;
    // #1;
    // // Termino de ingresar el pin
    
    // TIPO_TRANS = 1;     // Retiro
    // #25;
    // MONTO_STB = 1;
    // MONTO = 1300;        // Digito el monto 200
    // #2;
    // MONTO_STB = 0;      // Señal en 1 un ciclo
    // #2;
    // MONTO_STB = 1;
    // MONTO = 200;        // Digito el monto 200
    
    // #2;
    // RESET =1;
    // MONTO_STB = 0;      // Señal en 1 un ciclo
    // MONTO = 0;          // Digito el monto 200      
    // #2;
    // RESET = 0;
    // #2;

    //___________________________________________________________________________________________________________
    // Caso 3
    // Pin Incorrecto

    TARJETA_RECIBIDA = 1;
    TIPO_TARJETA = 0;       // BCR
    #2;

    // Primer Pin Incorrecto

    // Digitos Pin
    DIGITO_STB = 1;
    DIGITO= 4'b0111; // Dígito 1 (7)
    #1;
    DIGITO_STB = 0;
    #1;
    //_______________________
    DIGITO_STB = 1;
    DIGITO= 4'b0011; // Dígito 2 (3)
    #1;
    DIGITO_STB = 0;
    #1;
    //_______________________
    DIGITO_STB = 1;
    DIGITO= 4'b0101; // Dígito 3 (5)
    #1;
    DIGITO_STB = 0;
    #1;
    //_______________________
    DIGITO_STB = 1;
    DIGITO= 4'b0011; // Dígito 4 (3)
    #1;
    DIGITO_STB = 0;
    #1;
    DIGITO= 4'b0000;    // Reset de Digito
    // Termino de ingresar el pin
    #8;

    // Segundo Pin Incorrecto

    // Digitos Pin
    DIGITO_STB = 1;
    DIGITO= 4'b0111; // Dígito 1 (7)
    #1;
    DIGITO_STB = 0;
    #1;
    //_______________________
    DIGITO_STB = 1;
    DIGITO= 4'b0011; // Dígito 2 (3)
    #1;
    DIGITO_STB = 0;
    #1;
    //_______________________
    DIGITO_STB = 1;
    DIGITO= 4'b0101; // Dígito 3 (5)
    #1;
    DIGITO_STB = 0;
    #1;
    //_______________________
    DIGITO_STB = 1;
    DIGITO= 4'b0011; // Dígito 4 (3)
    #1;
    DIGITO_STB = 0;
    #1;
    DIGITO= 4'b0000;    // Reset de Digito
    // Termino de ingresar el pin
    #8;
    
    // Tercer Pin Incorrecto

    // Digitos Pin
    DIGITO_STB = 1;
    DIGITO= 4'b0111; // Dígito 1 (7)
    #1;
    DIGITO_STB = 0;
    #1;
    //_______________________
    DIGITO_STB = 1;
    DIGITO= 4'b0011; // Dígito 2 (3)
    #1;
    DIGITO_STB = 0;
    #1;
    //_______________________
    DIGITO_STB = 1;
    DIGITO= 4'b0101; // Dígito 3 (5)
    #1;
    DIGITO_STB = 0;
    #1;
    //_______________________
    DIGITO_STB = 1;
    DIGITO= 4'b0011; // Dígito 4 (3)
    #1;
    DIGITO_STB = 0;
    #1;
    // Reset de Digito
    DIGITO= 4'b0000;
    #1;
    // Termino de ingresar el pin
    #2;
    
    // Reset para salir del BLOQUEO
    RESET =1;
    #2;
    RESET = 0;
    #2;

    // Fin de los casos

    $finish;

end


endmodule