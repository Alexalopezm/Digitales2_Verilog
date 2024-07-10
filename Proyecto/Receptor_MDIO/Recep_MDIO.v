/* 
Proyecto Final Circuitos Digitales 2

Archivo: Recep_MDIO.v 

Descripciòn: Este archivo contiene el DUT del receptor para el protocolo MDIO

Autores: Alexa Lòpez, Sylvia Fonseca, Manfred Soza, Àngeles Ulate
*/

module Recep_MDIO(
    // Definiciòn de las entradas y salidas del receptor de transacciones MDIO

    // Entradas
    input rst,                  // Señal de Reset. =1 receptor funciona normalmente, =0 todas salidas en 0.
    input MDC,                  // Señal de reloj, con la mitad de la frecuencia del clk del generador, para la sincronizaciòn de transferencia de datos para el MDIO.
    input MDIO_OE,              // Señal de habilitación de MDIO_OUT. En Escritura es de 32 ciclos alto, en Lectura es de 16 ciclos en alto y 16 ciclos en bajo. Luego, baja.
    input MDIO_OUT,             // Señal serial, proviente del generador, que envìa los bits de T_DATA cuando MDIO_START està en alto.
    input [15:0] RD_DATA,       // Señal que contiene el valor o data leìda desde la memoria una vez que MDIO_DONE està en alto y WR_STB en bajo.

    // Salidas
    output reg [4:0] ADDR,      // Señal de direcciòn que indica en què posiciòn de memoria se debe almacenar el dato recibido en WR_DATA o en cuàl se debe leer RD_DATA.
    output reg MDIO_DONE,       // Señal de un ciclo de reloj que indica que se ha completado una transacción de MDIO en el receptor.
    output reg WR_STB,          // Señal que se pone en alto para indicar que ADDR y la data de WR_DATA es vàlida y se debe escribir a la memoria. 
    output reg [15:0] WR_DATA,  // Señal que contiene los datos a escribir en la posiciòn de memoria indicada por ADDR en el ciclo de reloj que se cumple que MDIO_DONE està en alto y WR_STB en bajo.
    output reg MDIO_IN          // Señal serie en la cual se envìa el dato almacenado en la posiciòn REGADDR, durante los ùltimos 16 ciclos de la transacciòn de MDIO.
);

// Definiciòn de registros y señales internas del receptor de transacciones MDIO
reg [2:0] state;        // Señal que indica el estado en el que se està para la FSM
reg [5:0] count;        // Señal de contador para recorrer MDIO_OUT y almacenar su concatenaciòn en un registro
reg [5:0] count_data;   // Señal de contador para recorrer RD_DATA y enviar su data en MDIO_IN en una transacciòn de lectura    
reg [31:0] REGISTRO;    // Registro utilizado para almacenar la concatenaciòn de MDIO_OUT
reg [1:0] bit_2_3;      // Registro para guardar el bit 3 y 4 juntos del frame bàsico del MDIO.


always @(posedge MDC) begin

    // Si se pone en alto el reset, se habilita el receptor de transacciones MDIO, es decir, funciona normalmente
    if (rst) begin

        // Se da paso a la FSM correspondiente al funcionamiento habilitado del receptor
        case(state)

        // Estado 0: Se almacena en REGISTRO los datos provenientes de la entrada MDIO_OUT y se revisa si se trata de una transacciòn MDIO de lectura o de escritura, 
        // de acuerdo a los valores de los bits 3 y 4 del frame bàsico de MDIO, mismos que corresponden a los bits 2 y 3 de MDIO_OUT, considerando su conteo desde 0.
        0: begin
            if (count > 0) begin
                REGISTRO <= {REGISTRO[31:0], MDIO_OUT};
                count <= count - 1;
                state <= 0;
            end else begin
                // Se obtiene el tipo de transacciòn (lectura o escritura)
                // Se guardan por concatenaciòn, los bits 2 y 3 de REGISTRO en un solo registro
                bit_2_3 <= {REGISTRO[29], REGISTRO[28]}; 
                state <= 1;
            end
        end

        // Estado 1: En este se revisa si se trata de una transacciòn MDIO de lectura o de escritura, y se pasa a su correspondiente siguiente estado que describe su comportamiento.
        1: begin

            // Si la concatenaciòn anterior corresponde a 10, se pasa al estado de lectura (2)
            if (bit_2_3 == 2'b10)begin
                state <= 2;

            // Si la concatenaciòn anterior corresponde a 01, se pasa al estado de escritura (3)
            end else if (bit_2_3 == 2'b01) begin
                state <= 3;
            end
        end
        
        // Estado 2: Corresponde a la descripciòn del funcionamiento normal del receptor para transacciones MDIO de lectura
        2: begin
            if (count_data > 0) begin
                // Se envia la DATA almacenada en la dirección PHYADR
                MDIO_IN <= RD_DATA[count_data-1];
                count_data <= count_data - 1;
                state <= 2;                
            end else begin
                MDIO_IN <= 0;
                WR_STB <= 0;
                MDIO_DONE <= 1;
                state <= 4;
            end 
        end

        // Estado 3: Corresponde a la descripciòn del funcionamiento normal del receptor para transacciones MDIO de escritura
        3:begin

            // Se guardan en WR_DATA los bits de REGISTRO correspondientes a la data y que se van a escribir en memoria
            WR_DATA <= {REGISTRO[15:0]};
            // Se guardan en ADDR los bits que corresponden a las posiciones de PHY Address, serà la posiciòn en memoria donde se va a guardar los datos
            ADDR <= {REGISTRO[28:23]};
            
            // Ambos deben estar en alto para se almacenen o escriban en memoria
            MDIO_DONE <= 1;
            WR_STB <= 1;

            state <= 4;

        end

        // Estado 4: Estado de finalizaciòn de las transacciones y que, finalmente, recae en el default.
        4:begin
            MDIO_DONE <= 0;
            WR_STB <= 0;
        end

        default: 
            state <= 0;

        endcase

    end else begin
        // Cuando el reset està en bajo, se resetea el programa, y las señales internas y de salida pasan a su correspondiente estado inicial
        MDIO_IN <= 0;
        WR_DATA <= 16'b0;
        WR_STB <= 0;
        MDIO_DONE <= 0;
        ADDR <= 5'b0;
        state <= 0;
        REGISTRO <= 32'd0;
        count_data <= 5'd16;
        bit_2_3 <= 2'b00; 
        count <= 6'd32;
    end
end


endmodule