// Código realizado por Alexa López Marcos. Carnet B94353.
// Este módulo se utiliza para definir el comportamiento de las entradas
`timescale 1ns/1ns // Escala de tiempo
module tester(
    input A_Peatonal,
    input B_Peatonal,
    output reg CLK,
    output reg ENB,
    output reg RST,
    output reg [1:0] Semaforo_A,
    output reg [1:0] Semaforo_B
);

// Estado de los semaforos A y B
parameter ROJO= 2'b00;
parameter AMARILLO= 2'b01;
parameter VERDE= 2'b10;

always begin
    #1 CLK = !CLK;
end 

initial begin
    CLK=1;  // Para activar el clock
    ENB=1;  // Activa el enable
    RST=0;  // Reset desactivado
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = ROJO;
    Semaforo_B = VERDE;
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = ROJO;
    Semaforo_B = AMARILLO;
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = VERDE;
    Semaforo_B = ROJO;
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = AMARILLO;
    Semaforo_B = ROJO;
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = ROJO;
    Semaforo_B = VERDE;
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    ENB=0;
    RST=1;  // Reset activado
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    RST=0;
    ENB=1;  // Activa el enable
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = ROJO;
    Semaforo_B = AMARILLO;
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = VERDE;
    Semaforo_B = ROJO;
    #2      // Pasan 2 ciclos del reloj     
//----------------------------------------------------------------------
    ENB=0;
    RST=1;  // Reset activado
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    RST=0;
    ENB=1;  // Activa el enable
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = AMARILLO;
    Semaforo_B = VERDE;
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = ROJO;
    Semaforo_B = VERDE;
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = ROJO;
    Semaforo_B = AMARILLO;
    #2      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    Semaforo_A = VERDE;
    Semaforo_B = ROJO;
    #10      // Pasan 2 ciclos del reloj
//----------------------------------------------------------------------
    $finish;

end


endmodule