// Circuitos Digitales II - Laboratorio II - 17 de Mayo del 2024.
// Código de Alexa López Marcos B94353  y Angeles Ulate Jarquín C07908

// CONTROLADOR PARA UN CAJERO AUTOMÁTICO DEL BANCO DE COSTA RICA
// Módulo DUT

module CajeroDUT (
  // Las de 1 o 2 bits
    input CLK, RESET, TARJETA_RECIBIDA, TIPO_TARJETA,
    input DIGITO_STB, TIPO_TRANS, MONTO_STB,
    // Las de más de 2 bits
    input [15:0] PIN, // Objetivo de PIN de usuario
    input [3:0] DIGITO, // Cada ingreso del PIN
    input [31:0] MONTO,
    // Salidas
    output reg BALANCE_ACTUALIZADO,
    output reg ENTREGAR_DINERO,
    output reg FONDOS_INSUFICIENTES,
    output reg PIN_INCORRECTO,
    output reg ADVERTENCIA,
    output reg BLOQUEO
);

// Definición de los parametros para los estados
parameter INGRESO_TARJETA = 0;
parameter COMPROBAR_PIN1 = 1;
parameter PIN_INC_2 = 2;
parameter PIN_INC_3 = 3;
parameter CUAL_TARJETA = 4;
parameter COBRO = 5;
parameter CUAL_TRANS = 6;
parameter MONTO_ACT_RET = 7;
parameter RETIRO_TRANS = 8;
parameter DEPOSITO_TRANS = 9;
parameter MONTO_ACT_DEP = 10;

// Parametro interno de comisión
parameter COMISION = 50;

// Definición de registros
reg [63:0] BALANCE;
reg [15:0] PIN_INTERNO;   //PIN_INTERNO se utiliza para comparar con PIN
reg [1:0] CONTADOR;
reg [1:0] CONTADOR2;

// En este caso tiene que ser de 4 bits
reg [3:0] ESTADO;
reg [3:0] SIG_ESTADO;

  initial begin
    // Registros Internos
    PIN_INTERNO = 16'b0000000000000000;   // Pin interno
    BALANCE = 1000;   // 200
    CONTADOR = 2'b00;   // Primer contador
    CONTADOR2 = 2'b00;  // Segundo contador
    // Salidas
    BALANCE_ACTUALIZADO = 0;
    ENTREGAR_DINERO = 0;
    FONDOS_INSUFICIENTES = 0;
    PIN_INCORRECTO = 0;
    ADVERTENCIA = 0;
    BLOQUEO = 0;
  end

  // Para manejo de números ingresados para PIN
  always @(posedge DIGITO_STB) begin
    /*
    Cada flanco positivo de la señal DIGITO_STB
    se almacena el valor ingresado en DIGITO
    a registro PIN_INTERNO y se ingrementa CONTADOR.
    Cuando CONTADOR es igual a 4 se aumenta CONTADOR2.
    */ 
    PIN_INTERNO <= {PIN_INTERNO[11:0], DIGITO};
    CONTADOR++;
    if (CONTADOR==2'b11) begin
      CONTADOR2++;
    end
  end


 always @(posedge CLK or negedge RESET) begin
  //Para cada flanco positivo de CLK o flanco negativo de RESET
    if (RESET) begin
      // Salidas
      BALANCE_ACTUALIZADO<=0;
      ENTREGAR_DINERO<=0;
      FONDOS_INSUFICIENTES<=0;
      PIN_INCORRECTO<=0;
      ADVERTENCIA<=0;
      BLOQUEO<=0;
      // Contadores internos
      CONTADOR = 2'b00;
      CONTADOR2 = 2'b00;
      // Estados
      ESTADO <= INGRESO_TARJETA;
      SIG_ESTADO <= INGRESO_TARJETA;
    end else begin
      ESTADO <= SIG_ESTADO;
    end
 end

// Máquina de estados
always @(*) begin
  case(ESTADO)

    // Estado 0
    INGRESO_TARJETA: begin
      /* Si TARJETA_RECIBIDA está en alto y
      el CONTADOR2 es igual a 2'b01, entonces:
      El siguiente estado es COMPROBAR_PIN1,
      sino se mantiene en el estado INGRESO_TARJETA */
      SIG_ESTADO= (TARJETA_RECIBIDA && (CONTADOR2==2'b01)) ? COMPROBAR_PIN1: INGRESO_TARJETA;
    end

    // Estado 1
    COMPROBAR_PIN1: begin
      if (PIN_INTERNO == PIN) begin
        /* Si PIN_INTERNO es igual a PIN, entonces:
        La salida PIN_INCORRECTO es 0 y
        el siguiente estado es CUAL_TARJETA. */
        PIN_INCORRECTO = 0;
        SIG_ESTADO = CUAL_TARJETA;
      end else begin 
        /* Si PIN_INTERNO es diferente de PIN, entonces:
        La salida PIN_INCORRECTO es 1. */ 
        PIN_INCORRECTO = 1;
        if (PIN_INCORRECTO && (CONTADOR2==2'b10)) begin
          /* Si PIN_INCORRECTO y CONTADOR2 es igual a 2'b10, entonces:
          El siguiente estado es PIN_INC_2. */
          SIG_ESTADO = PIN_INC_2; 
        end 
      end
    end

    // Estado 2
    PIN_INC_2: begin
      if (PIN_INTERNO == PIN) begin
        /* Si PIN_INTERNO es igual a PIN, entonces:
        La salida PIN_INCORRECTO es 0 y
        el siguiente estado es CUAL_TARJETA. */
        PIN_INCORRECTO = 0;
        SIG_ESTADO = CUAL_TARJETA;
      end else begin
        /* Si PIN_INTERNO es diferente de PIN, entonces:
        La salida PIN_INCORRECTO es 1.
        La salida BLOQUEO es 0.
        La salida ADVERTENCIA es 1. */ 
        PIN_INCORRECTO = 1;
        BLOQUEO = 0;
        ADVERTENCIA = 1;
        if (PIN_INCORRECTO && (CONTADOR2==2'b11)) begin
          /* Si PIN_INCORRECTO y CONTADOR2 es igual a 2'b11, entonces:
          El siguiente estado es PIN_INC_3.*/
          SIG_ESTADO = PIN_INC_3;
        end 
      end
    end

    // Estado 3
    PIN_INC_3: begin
      if (PIN_INTERNO == PIN) begin
        /* Si PIN_INTERNO es igual a PIN, entonces:
        La salida PIN_INCORRECTO es 0 y
        el siguiente estado es CUAL_TARJETA. */
        PIN_INCORRECTO = 0;
        SIG_ESTADO = CUAL_TARJETA;
      end else begin
        /* Si PIN_INTERNO es diferente de PIN, entonces:
        La salida PIN_INCORRECTO es 1.
        La salida ADVERTENCIA es 0.
        La salida BLOQUEO es 1. */ 
        PIN_INCORRECTO = 1;
        ADVERTENCIA = 0; 
        BLOQUEO = 1;
        // Una vez que se activa BLOQUEO para cambiar de estado se debe aplicar un RESET.
          if (RESET) begin
            /* Si RESET está en alto, entonces:
            El siguiente estado es INGRESO_TARJETA. */
            SIG_ESTADO = INGRESO_TARJETA;
          end
      end
    end

    // Estado 4
    CUAL_TARJETA: begin
      /* Si TIPO_TARJETA está en alto, entonces:
      El siguiente estado es COBRO (PRIVADO),
      sino pasa al estado CUAL_TRANS. */
      SIG_ESTADO= TIPO_TARJETA ? COBRO: CUAL_TRANS;
    end

    // Estado 5
    COBRO: begin
      /* Se realiza cobro de la COMISION y
      se actualiza el monto de BALANCE.
      Luego del cobro pasa al estado CUAL_TRANS. */
      BALANCE = BALANCE - COMISION;
      SIG_ESTADO = CUAL_TRANS;
    end

    // Estado 6
    CUAL_TRANS: begin
      /* Si TIPO_TRANS está en alto, entonces:
      El siguiente estado es RETIRO_TRANS,
      sino pasa el siguiente es DEPOSITO_TRANS. */
      SIG_ESTADO= TIPO_TRANS ? RETIRO_TRANS: DEPOSITO_TRANS;
    end

    // Estado 7
    RETIRO_TRANS: begin
      /* Si MONTO_STB está en alto, entonces:
      El siguiente estado es MONTO_ACT_RET,
      sino pasa el siguiente es RETIRO_TRANS. */
      SIG_ESTADO= MONTO_STB ? MONTO_ACT_RET: RETIRO_TRANS;
    end

    // Estado 8
    MONTO_ACT_RET: begin
      if (MONTO>BALANCE) begin
          /* Si MONTO es mayor que BALANCE, entonces:
          La salida FONDOS_INSUFICIENTES es 1. */
          FONDOS_INSUFICIENTES = 1;
          // Una vez que se activa FONDOS_INSUFICIENTES para cambiar de estado se debe aplicar un RESET.
          /* Si RESET está en alto, entonces:
          El siguiente estado es INGRESO_TARJETA
          sino, el siguiente estado MONTO_ACT_RET. */ 
          SIG_ESTADO = RESET ? INGRESO_TARJETA : MONTO_ACT_RET;
        end else begin
          /* Si MONTO es menor que BALANCE, entonces:
          A BALANCE se le resta el MONTO a retirar.
          La salida FONDOS_INSUFICIENTES es 0. 
          La salida BALANCE_ACTUALIZADO es 1.
          La salida ENTREGAR_DINERO es 1.*/
          BALANCE = BALANCE - MONTO;
          FONDOS_INSUFICIENTES = 0;
          BALANCE_ACTUALIZADO = 1;
          ENTREGAR_DINERO = 1;
          // Una vez que se activa ENTREGAR_DINERO para cambiar de estado se debe aplicar un RESET.
          if (RESET) begin
            /* Si RESET está en alto, entonces:
            El siguiente estado es INGRESO_TARJETA. */ 
            SIG_ESTADO = INGRESO_TARJETA;
          end
        end
    end

    // Estado 9
    DEPOSITO_TRANS: begin
        /* Si MONTO_STB está en alto, entonces:
        El siguiente estado es MONTO_ACT_DEP,
        sino pasa el siguiente es DEPOSITO_TRANS. */
        SIG_ESTADO = MONTO_STB ? MONTO_ACT_DEP : DEPOSITO_TRANS;
    end

    // Estado 10
    MONTO_ACT_DEP: begin
        /* A BALANCE se le suma el MONTO a depositar.
        La salida BALANCE_ACTUALIZADO es 1.*/
        BALANCE = BALANCE + MONTO;
        BALANCE_ACTUALIZADO = 1;
        // Una vez que se activa BALANCE_ACTUALIZADO para cambiar de estado se debe aplicar un RESET.
        if (RESET) begin
          /* Si RESET está en alto, entonces:
          El siguiente estado es INGRESO_TARJETA. */ 
          SIG_ESTADO = INGRESO_TARJETA;
        end
    end
  endcase
end

endmodule