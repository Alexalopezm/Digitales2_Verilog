module master (
    input clk,
    input reset,
    input [15:0] datain,
    input mensaje,
    input MISO,       // MISO slave 1
    output spi_cs1_l,
    output spi_cs2_l,
    output sclk,
    output spi_data,
    output [15:0] counter
);

reg [15:0] MOSI;
reg [2:0] state;
reg [4:0] count;
reg spi_cs1; 
reg spi_cs2; 
reg spi_sclk;

always @(posedge clk) begin
    if(reset) begin
        MOSI <= 16'b0;
        count <= 5'd16;
        state <= 0;
        spi_cs1 <= 1'b1;
        spi_cs2 <= 1'b1;
        spi_sclk <= 1'b0; //porque nada puede empezar hasta el CS no baje
    end else begin
        case (state)
            0 : begin
                spi_cs1 <= 1;
                spi_cs2 <= 1;
                spi_sclk <= 0;
                count <= 5'd16;
                state <= 1;
            end 
            1 :  begin
                spi_cs1 <= 0;
                spi_cs2 <= 0;
                spi_sclk <= 0;
                MOSI <= datain[count-1];
                count <= count -1;
                state <= 2;
            end
            2 : begin
                spi_cs1 <= 0;
                spi_cs2 <= 0;
                spi_sclk <= 1;
                if(count > 0) begin
                    state <= 1;
                end else begin
                    state <= 3;
                end
            end
            3: begin
                MOSI <= 0;
                spi_cs1 <= 0;
                spi_cs2 <= 0;
                spi_sclk <= 0;
                state <= 4;
            end
            4: begin
                MOSI <= 0;
                spi_cs1 <= 0;
                spi_cs2 <= 0;
                spi_sclk <= 1;
                if (mensaje) begin
                    spi_cs1 <= 1;
                    spi_cs2 <= 1;
                    state <= 0;
                end else begin 
                    state <= 3;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign spi_data = MOSI;
assign counter = count;
assign spi_cs1_l = spi_cs1;
assign spi_cs2_l = spi_cs2;
assign sclk = spi_sclk;
    
endmodule