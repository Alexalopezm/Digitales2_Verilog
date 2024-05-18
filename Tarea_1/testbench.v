`include "LavadoraDUT.v"
`include "tester.v"

module testbench;

wire SECADO, LAVADO, LAVADO_PESADO, INSUFICIENTE;
wire clk, INTRO_MONEDA, FINALIZAR_PAGO, RESET;

    LavadoraDUT DUT(
        .clk(clk),
        .INTRO_MONEDA(INTRO_MONEDA),
        .FINALIZAR_PAGO(FINALIZAR_PAGO),
        .RESET(RESET),
        .SECADO(SECADO),
        .LAVADO(LAVADO),
        .LAVADO_PESADO(LAVADO_PESADO),
        .INSUFICIENTE(INSUFICIENTE)
    );

    tester test(
        .clk(clk),
        .INTRO_MONEDA(INTRO_MONEDA),
        .FINALIZAR_PAGO(FINALIZAR_PAGO),
        .RESET(RESET),
        .SECADO(SECADO),
        .LAVADO(LAVADO),
        .LAVADO_PESADO(LAVADO_PESADO),
        .INSUFICIENTE(INSUFICIENTE) 
    );

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars;
    end

endmodule