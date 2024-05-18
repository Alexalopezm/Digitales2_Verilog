// Código realizado por Alexa López Marcos. Carnet B94353.
// Este módulo se utiliza para definir el comportamiento de las salidas
module SemaforoDUT(
    input CLK,
    input ENB,
    input RST,
    input [1:0] Semaforo_A,
    input [1:0] Semaforo_B,
    output reg A_Peatonal,
    output reg B_Peatonal
);

// Estado de los semaforos A y B
parameter ROJO= 2'b00;
parameter AMARILLO= 2'b01;
parameter VERDE= 2'b10;

always @(posedge CLK)
begin
    if (ENB) begin  // Si el enable esta encendido entonces todo debe funcionar
        if (Semaforo_A == VERDE && (Semaforo_B == ROJO || Semaforo_B == AMARILLO)) begin 
            // Si el semaforo A esta en verde y el semaforo B esta en amarrillo o rojo, entonces...
           A_Peatonal <= 0;    // El peatonal A va a estar en rojo.
           B_Peatonal <= 1;    // El peatonal B va a estar en verde.

        end else if (Semaforo_B == VERDE && (Semaforo_A == ROJO || Semaforo_A == AMARILLO)) begin 
            // Si el semaforo B esta en verde y el semaforo A esta en amarrillo o rojo, entonces...
            A_Peatonal <= 1;   // El peatonal A va a estar en verde.
            B_Peatonal <= 0;   // El peatonal B va a estar en rojo.
        
        end 
    end else if (RST) begin // Todo vuelve a su condición inicial
            A_Peatonal <= 0; // En rojo
            B_Peatonal <= 0; // En rojo
        end 
end

endmodule