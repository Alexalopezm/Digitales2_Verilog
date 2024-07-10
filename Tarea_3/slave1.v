module slave1(
    input reset,        // Reset
    input sclk,         // SCLK
    input spi_data_in,     // MOSI
    input spi_cs_l,    // CS1
    output spi_data_out,     // MISO
    output mensaje          // Señal de mensaje enviado
);

reg [15:0] MISO;
reg [15:0] MOSI;
reg [2:0] state; 
reg [4:0] count;
reg datos_enviados;

always @(posedge sclk or posedge reset) begin
    if(reset) begin
        MISO <= 0;
        MOSI <= 0;
        state <= 0;
        datos_enviados <= 0;
        count <= 5'd0;
    end else if (!spi_cs_l) begin
        case (state)
            0: begin
                if (count < 5'd16 ) begin
                    MOSI <= {MOSI[15:0], spi_data_in};
                    count <= count + 1;
                end else begin
                    state <= 1;
                end
            end

            1: begin
                if (count > 0) begin
                    MISO <= MOSI[count - 1];
                    count <= count - 1;
                    state <= 1;
                end else begin
                    MISO <= 0;
                    if (MISO==spi_data_in) begin
                        datos_enviados <= 1;
                    end
                    
                end
            end
        endcase
    end else begin
        MISO <= 0;
        MOSI <= 0;
        state <= 0;
        datos_enviados <= 0;
        count <= 5'd0;
    end
end

assign spi_data_out = MISO;
assign mensaje = datos_enviados;


endmodule