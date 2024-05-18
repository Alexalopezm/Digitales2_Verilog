// Código realizado por Alexa López Marcos. Carnet B94353.
`include "SemaforoDUT.v"
`include "tester.v"

module testbench;

    wire CLK, ENB, RST;
    wire [1:0] Semaforo_A;
    wire [1:0] Semaforo_B;
    wire A_Peatonal, B_Peatonal;

    SemaforoDUT DUT(
        .CLK(CLK),
        .ENB(ENB),
        .RST(RST),
        .Semaforo_A(Semaforo_A[1:0]),
        .Semaforo_B(Semaforo_B[1:0]),
        .A_Peatonal(A_Peatonal),
        .B_Peatonal(B_Peatonal)
    );

    tester test(
        .CLK(CLK),
        .ENB(ENB),
        .RST(RST),
        .Semaforo_A(Semaforo_A[1:0]),
        .Semaforo_B(Semaforo_B[1:0]),
        .A_Peatonal(A_Peatonal),
        .B_Peatonal(B_Peatonal)
    );


    initial begin
            $dumpfile("tb.vcd");
            $dumpvars;
        end

endmodule