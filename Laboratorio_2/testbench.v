// Circuitos Digitales II - Laboratorio II - 17 de Mayo del 2024.
// Código de Alexa López Marcos B94353  y Angeles Ulate Jarquín C07908

// CONTROLADOR PARA UN CAJERO AUTOMÁTICO DEL BANCO DE COSTA RICA
// Módulo TESTBENCH

`include "CajeroDUT.v"
`include "tester.v"

module testbench;
    // Entradas
    wire BALANCE_ACTUALIZADO, ENTREGAR_DINERO, FONDOS_INSUFICIENTES;
    wire PIN_INCORRECTO, ADVERTENCIA, BLOQUEO;
    // Salidas
    // Las de 1 bit
    wire CLK, RESET, TARJETA_RECIBIDA, TIPO_TARJETA;
    wire DIGITO_STB, TIPO_TRANS, MONTO_STB;
    // Las de más de 2 bits
    wire [15:0] PIN;
    wire [3:0] DIGITO;
    wire [31:0] MONTO;

    CajeroDUT DUT(
        .BALANCE_ACTUALIZADO(BALANCE_ACTUALIZADO),
        .ENTREGAR_DINERO(ENTREGAR_DINERO), 
        .FONDOS_INSUFICIENTES(FONDOS_INSUFICIENTES),
        .PIN_INCORRECTO(PIN_INCORRECTO), 
        .ADVERTENCIA(ADVERTENCIA), 
        .BLOQUEO(BLOQUEO),
        .CLK(CLK), 
        .RESET(RESET), 
        .TARJETA_RECIBIDA(TARJETA_RECIBIDA), 
        .TIPO_TARJETA(TIPO_TARJETA),
        .DIGITO_STB(DIGITO_STB), 
        .TIPO_TRANS(TIPO_TRANS), 
        .MONTO_STB(MONTO_STB),
        .PIN(PIN[15:0]),
        .DIGITO(DIGITO[3:0]),
        .MONTO(MONTO[31:0])
    );

    tester test(
        .BALANCE_ACTUALIZADO(BALANCE_ACTUALIZADO),
        .ENTREGAR_DINERO(ENTREGAR_DINERO), 
        .FONDOS_INSUFICIENTES(FONDOS_INSUFICIENTES),
        .PIN_INCORRECTO(PIN_INCORRECTO), 
        .ADVERTENCIA(ADVERTENCIA), 
        .BLOQUEO(BLOQUEO),
        .CLK(CLK), 
        .RESET(RESET), 
        .TARJETA_RECIBIDA(TARJETA_RECIBIDA), 
        .TIPO_TARJETA(TIPO_TARJETA),
        .DIGITO_STB(DIGITO_STB), 
        .TIPO_TRANS(TIPO_TRANS), 
        .MONTO_STB(MONTO_STB),
        .PIN(PIN[15:0]),
        .DIGITO(DIGITO[3:0]),
        .MONTO(MONTO[31:0])
    );
    
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars;
    end



endmodule