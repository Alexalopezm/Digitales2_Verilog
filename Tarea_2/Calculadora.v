// Tarea 2. Calculadora de 8 bits.
// Realizar un calculadora de 8 bits que sume, reste, multiplique y aplique left shift
// Código realizado por Alexa López Marcos. Carnet B94353.

// Se incluyen los módulos de las operaciones que realiza la calculadora.
`include "Suma.v"
`include "Resta.v"
`include "Multiplicacion.v"
`include "Left_Shift.v"

module Calculadora(
    input clk,                  // Reloj
    input rst,                  // Señal de reset
    input en,                   // Señal de enable
    input [7:0] a,              // Primer número ingresado
    input [7:0] b,              // Segundo número ingresado
    input [1:0] MODO,           // Tipo de operación a realizar
    output reg [7:0] c          // Salida de la operación realizada
);

/*
Se definen los parametros de la calculodora,
esto para comparar más facilmente la entrada MODO
*/
parameter suma = 2'b00;
parameter resta = 2'b01;
parameter multiplica = 2'b10;
parameter left_shift = 2'b11;

// Salidas de cada instancia
wire [7:0] suma_out; // Salida del módulo Suma
wire [7:0] resta_out; // Salida del módulo Resta
wire [7:0] multiplicacion_out;  // Salida del módulo Multiplicacion
wire [7:0] Left_Shift_out;  // Salida del módulo Left_Shift


// Se instancian los módulos de las operaciones que realiza la calculadora.
Suma #(8) sumador(.clk(clk), .rst(rst), .en(en), .a(a[7:0]), .b(b[7:0]), .c(suma_out[7:0]));
Resta #(8) restador(.clk(clk), .rst(rst), .en(en), .a(a[7:0]), .b(b[7:0]), .c(resta_out[7:0]));
Multiplicacion #(8) multiplicador(.clk(clk), .rst(rst), .en(en), .a(a[7:0]), .b(b[7:0]), .c(multiplicacion_out[7:0]));
Left_shift #(8) Left(.clk(clk), .rst(rst), .en(en), .a(a[7:0]), .b(b[7:0]), .c(Left_Shift_out[7:0]));


always @(posedge clk) begin
    // Si enb está en alto entonces la calculadora realiza un acción
    if (en) begin
        if (MODO==suma) begin
            c <= suma_out;
        end
        else 
        if (MODO==resta) begin
            c <= resta_out;
        end
        else if (MODO==multiplica) begin
            c <= multiplicacion_out;
        end
        else if (MODO==left_shift) begin
            // Left shift desplazado un bit
            c <= Left_Shift_out;
        end
    end

end


endmodule

