module Multiplicacion #(parameter N = 1)(
    input clk,                  // Reloj
    input rst,                  // Señal de reset
    input en,                   // Señal de enable
    input [7:0] a,              // Primer número ingresado
    input [7:0] b,              // Segundo número ingresado
    output reg [7:0] c          // Salida de la operación realizada
);

// Proceso de Multiplicar
always @(posedge clk)
begin
    if (en) begin
        c <= a * b;
    end
    else if (rst) begin
        c <= 8'b00000000;
    end
end


endmodule