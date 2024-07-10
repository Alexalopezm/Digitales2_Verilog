/* 
Proyecto Final Circuitos Digitales 2

Archivo: Trans_MDIO.v 

Descripciòn: Este archivo contiene el DUT del generador para el protocolo MDIO

Autores: Alexa Lòpez, Sylvia Fonseca, Manfred Soza, Àngeles Ulate
*/


module Trans_MDIO (
    // Definiciòn de las entradas y salidas del generador-transmisor de transacciones MDIO
    
    // Entradas
    input clk,                  // Señal de reloj proveniente del CPU, llega al generador con una frecuencia determinada
    input rst,                  // Señal de Reset. =1 generador funciona normalmente, =0 todas salidas en 0
    input [31:0] T_DATA,        // Señal que contiene los 32 bits a transmitir del frame bàsico del protocolo MDIO
    input MDIO_START,           // Señal que tarda un pulso de 1 ciclo reloj e indica que valor T_DATA se cargó y que debe iniciar su transmisiòn
    input MDIO_IN,              // Señal serie para la operación de lectura con los valores de los últimos 16 ciclos de MDIO a escribir en RD_DATA

    // Salidas
    output reg [15:0] RD_DATA,  // Señal que produce, por concatenaciòn, los 16 bits recibidos durante una transacciòn de lectura segùn MDIO_IN. Es válido cuando RD_RDY = 1
    output reg DATA_RDY,        // Señal que se pone en alto cuando se completa la recepción de la palabra serial en la transaccion de lectura
    output reg MDC,             // Señal de reloj, con la mitad de la frecuencia de CLK, para la sincronizaciòn de transferencia de datos para el MDIO
    output reg MDIO_OE,         // Señal de habilitación de MDIO_OUT. En Escritura es de 32 ciclos alto, en Lectura es de 16 ciclos en alto y 16 ciclos en bajo.
    output reg MDIO_OUT         // Señal serial, que envìa los bits de T_DATA cuando MDIO_START està en alto.
);

// Definiciòn de registros y señales internas del generador-transmisor de transacciones MDIO
reg [5:0]count;             // Señal de contador para recorrer T_DATA
reg [2:0]state;             // Señal que indica el estado en el que se està para la FSM
reg [3:0]count_MDIO_IN;     // Señal de contador para recorrer MDIO_IN 
reg [1:0]bit_2_3;           // Registro para guardar el bit 3 y 4 juntos del frame bàsico del MDIO.
reg [5:0]count_MDIO_OE;     // Señal de contador para definir el comportamiento de MDIO_OE de acuerdo a si es una transacciòn de lectura o de escritura


always @(posedge clk) begin

    // Si se pone en alto el reset, se habilita el generador de transacciones MDIO, es decir, funciona normalmente
    if (rst) begin

        // Se define el comportamiento de MDC para que sea de la mitad de la frecuencia de clk
        MDC <= ~MDC; // Cambia el estado de MDC en cada flanco de subida de clk
        
        // Se da paso a la FSM correspondiente al funcionamiento habilitado del generador
        case (state)

            // Estado 0: En este se revisa si MDIO_START està en alto para pasar al siguiente (1), en el que llevarìa a cabo la transmisiòn de datos a travès de la salida serial MDIO_OUT.
            0 : begin
                if (MDIO_START) begin
                    state <= 1;
                end
            end

            // Estado 1: En este se lleva a cabo la transmisiòn de datos a travès de la salida serial MDIO_OUT, segùn la entrada T_DATA
            1 : begin
                // MDIO_OUT toma, serialmente, los valores de T_DATA. Este envìa los bits de T_DATA desde el màs significativo hasta completar
                // los 32 bits, donde en este punto, se pasa al siguiente estado (2).
                if (count > 0) begin
                    MDIO_OUT <= T_DATA[count-1]; 
                    count <= count - 1;
                    state <= 1;
                end else begin
                    MDIO_OUT <= 0;
                    state <= 2;
                end  
            end

            // Estado 2: En este se revisa si se trata de una transacciòn MDIO de lectura o de escritura, de acuerdo a los valores de los bits
            // 3 y 4 del frame bàsico de MDIO, mismos que corresponden a los bits 2 y 3 de T_DATA, considerando su conteo desde 0.
            2: begin
                // Se guardan por concatenaciòn, los bits 2 y 3 de T_DATA en un solo registro
                bit_2_3 <= {T_DATA[29], T_DATA[28]};

                // Si la concatenaciòn anterior corresponde a 10, se pasa al estado de lectura (4)
                if (bit_2_3 == 2'b10)begin
                    state <= 4;
                // Si la concatenaciòn anterior corresponde a 01, se pasa al estado de escritura (3)
                end else if (bit_2_3 == 2'b01) begin
                    // Escritura
                    state <= 3;
                end
            end

            // Estado 3: Corresponde a la descripciòn del funcionamiento normal del generador para transacciones MDIO de escritura
            3: begin
                // Al tratarse de una transacciòn de escritura, MDIO_OE debe permanecer en alto duante los 32 ciclos de la transacciòn,
                // lo cual se revisa que suceda usando el contador y, una vez que esto se cumple, MDIO_OE se pone en bajo y pasa al
                // al siguiente estado (5).
                if (count_MDIO_OE > 0) begin
                    MDIO_OE <= 1;
                    count_MDIO_OE <= count_MDIO_OE - 1;
                    state <= 3;
                end else begin
                    MDIO_OE <= 0;
                    state <= 5;
                end                 
            end

            // Estado 4: Corresponde a la descripciòn del funcionamiento normal del generador para transacciones MDIO de lectura
            4: begin      
                // Al tratarse de una transacciòn de lectura, MDIO_OE debe permanecer en alto durante los primeros 16 ciclos de la transacciòn
                if (count_MDIO_OE > 16) begin
                    MDIO_OE <= 1;
                    count_MDIO_OE <= count_MDIO_OE -1;

                    if (count_MDIO_IN < 16) begin
                        // Mientras el contador de MDIO_IN sea distinto a 0, en MDIO_IN se recibe la data, 
                        // y esta se produce concatenada (los 16 bits) en RD_DATA.
                        RD_DATA <= {RD_DATA[15:0], MDIO_IN};
                        count_MDIO_IN <= count_MDIO_IN + 1;
                    end

                    state <= 4;
                    //$display("Count > 16");    

                // Al tratarse de una transacciòn de lectura, MDIO_OE debe permanecer en bajo durante los ùltimos 16 ciclos de la transacciòn 
                end else if (count_MDIO_OE <= 16) begin
                    MDIO_OE <= 0;
                    count_MDIO_OE <= count_MDIO_OE -1;

                    if (count_MDIO_OE > 0) begin
                        state <= 4;
                    end
                    else if (count_MDIO_OE == 0) begin
                        // Una vez que se ha llegado a cero en el valor del contador de MDIO_OE, y por ende se ha terminado
                        // de producir la data en RD_DATA, se levanta DATA_RDY durante un ciclo y se pasa al siguiente estado (5).
                        //$display("Count 0");
                        count_MDIO_OE <= 0;
                        DATA_RDY <= 1;
                        MDIO_OE <= 0;
                        state <= 5; 
                    end  
                end
            end

            // Estado 5: Estado de finalizaciòn de las transacciones y que, finalmente, recae en el default.
            5: begin
                DATA_RDY <= 0;
                RD_DATA <= 0;                   
            end
                
            default:
                state <= 0;
        endcase
            
    
    end else begin
    // Cuando el reset està en bajo, se resetea el programa, y las señales internas y de salida pasan a su correspondiente estado inicial
    MDC <= 0;
    count_MDIO_IN <= 4'd0;
    DATA_RDY <= 0;
    state <= 0;
    count <= 6'd32;
    MDIO_OUT <= 0;
    bit_2_3 <= 2'b00;
    count_MDIO_OE <= 6'd32;
    MDIO_OE <= 0;
    RD_DATA <= 0;
    end
end

endmodule