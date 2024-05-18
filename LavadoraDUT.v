// Código realizado por Alexa López Marcos. Carnet B94353.
/*En este módulo se definen los comportamientos de las salidas del sistema,
con respecto a las condiciones de entrada del sistema*/

module LavadoraDUT(
    input clk,                  // Reloj
    input INTRO_MONEDA,         // Señal de ingreso de monedas
    input FINALIZAR_PAGO,       // Botón de finalizar pago
    input RESET,                // Señal de reset
    output reg SECADO,          // Salida de secado
    output reg LAVADO,          // Salida de lavado
    output reg LAVADO_PESADO,   // Salida de lavado pesado
    output reg INSUFICIENTE     // Señal de insuficiencia
);

// Contadores
reg [4:0] VERIFICACION_PAGO;      // VERIFICACION_PAGO contador interno de la señal INTRO_MONEDA
reg [4:0] CONTADOR_PULSOS;        // Contador de la señal clk para generar pulsos

// Parametros de duración de pulsos
parameter DURACION_PULSOS = 4;  // Duración de los pulsos para las salidas SECADO, LAVADO y LAVADO_PESADO
parameter DURACION_PULSOS_INSU = 1; // Duración de los pulsos para la salida INSUFICIENTE

// Asignación inicial
initial begin
    /*Los valores de las señales de salida y de los contadores
    se inicializan en cero*/
    SECADO = 0;
    LAVADO = 0;
    LAVADO_PESADO = 0;
    INSUFICIENTE = 0;
    VERIFICACION_PAGO = 0;
    CONTADOR_PULSOS = 0;
end

// Parámetros de costos
parameter COSTO_SECADO = 3;
parameter COSTO_LAVADO = 4;
parameter COSTO_LAVADO_PESADO = 9;

always @(posedge clk) begin
    /*Si INTRO_MONEDA se enciende y FINALIZAR_PAGO esta apagado entonces,
    el contador VERIFICACION_PAGO aumenta en un valor*/
    if (INTRO_MONEDA && FINALIZAR_PAGO==0) begin
        VERIFICACION_PAGO <= VERIFICACION_PAGO + 1;
    //--------------------------------------------------------------------------
    /*Si FINALIZAR_PAGO esta encendida e INTRO_MONEDA esta apagada entonces,
    inician las condiciones activadas por el valor de VERIFICACION_PAGO*/
    end else if (FINALIZAR_PAGO && INTRO_MONEDA==0) begin
        if (VERIFICACION_PAGO==COSTO_SECADO) begin
            /*Cuando VERIFICACION_PAGO es igual a COSTO_SECADO entonces,
            se inicia la condición que genera la salida de pulsos de la señal SECADO*/
            if (CONTADOR_PULSOS < DURACION_PULSOS) begin
                CONTADOR_PULSOS <= CONTADOR_PULSOS + 1;
                if (CONTADOR_PULSOS == 0 || CONTADOR_PULSOS == 2) begin
                    SECADO <= 1;
                end else if (CONTADOR_PULSOS == 1 || CONTADOR_PULSOS == 3) begin
                    SECADO <= 0;
                end
            end else if (CONTADOR_PULSOS == DURACION_PULSOS || CONTADOR_PULSOS >= DURACION_PULSOS) begin
                SECADO <= 0;
            end 
        end else if (VERIFICACION_PAGO==COSTO_LAVADO) begin
            /*Cuando VERIFICACION_PAGO es igual a COSTO_LAVADO entonces,
            se inicia la condición que genera la salida de pulsos de la señal LAVADO*/
            if (CONTADOR_PULSOS < DURACION_PULSOS) begin
                CONTADOR_PULSOS <= CONTADOR_PULSOS + 1;
                if (CONTADOR_PULSOS == 0 || CONTADOR_PULSOS == 2) begin
                    LAVADO <= 1;
                end else if (CONTADOR_PULSOS == 1 || CONTADOR_PULSOS == 3) begin
                    LAVADO <= 0;
                end
            end else if (CONTADOR_PULSOS == DURACION_PULSOS || CONTADOR_PULSOS >= DURACION_PULSOS) begin
                LAVADO <= 0;
            end
        end else if (VERIFICACION_PAGO==COSTO_LAVADO_PESADO) begin
            /*Cuando VERIFICACION_PAGO es igual a COSTO_LAVADO_PESADO entonces,
            se inicia la condición que genera la salida de pulsos de la señal LAVADO_PESADO*/
            if (CONTADOR_PULSOS < DURACION_PULSOS) begin
                CONTADOR_PULSOS <= CONTADOR_PULSOS + 1;
                if (CONTADOR_PULSOS == 0 || CONTADOR_PULSOS == 2) begin
                    LAVADO_PESADO <= 1;
                end else if (CONTADOR_PULSOS == 1 || CONTADOR_PULSOS == 3) begin
                    LAVADO_PESADO <= 0;
                end
            end else if (CONTADOR_PULSOS == DURACION_PULSOS || CONTADOR_PULSOS >= DURACION_PULSOS) begin
                LAVADO_PESADO <= 0;
            end 
        end else begin
            if (CONTADOR_PULSOS < DURACION_PULSOS_INSU) begin
                /*Cuando VERIFICACION_PAGO no es igual a ninguno de los costos entonces,
                se inicia la condición que genera la salida de pulsos de la señal INSUFICIENTE*/
                CONTADOR_PULSOS <= CONTADOR_PULSOS + 1;
                if (CONTADOR_PULSOS == 0) begin
                     INSUFICIENTE <= 1;
                end else if (CONTADOR_PULSOS == 1) begin
                        INSUFICIENTE <= 0;
                end
            end else if (CONTADOR_PULSOS == DURACION_PULSOS_INSU || CONTADOR_PULSOS >= DURACION_PULSOS_INSU ) begin
                INSUFICIENTE <= 0;
            end 
        end
    end else if (RESET) begin
        /*Los valores de las señales de salida y de los contadores
        vuelven a su estado inicial*/
        SECADO <= 0;
        LAVADO <= 0;
        LAVADO_PESADO <= 0;
        INSUFICIENTE <= 0;
        VERIFICACION_PAGO <= 0;
        CONTADOR_PULSOS <= 0;
    end
end

endmodule