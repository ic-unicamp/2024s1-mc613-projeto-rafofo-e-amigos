module update #(
    parameter MAPA_HEIGHT,
    parameter MAPA_WIDTH
) (
    input clk,
    output reg state_read,
    input [3:0] state_rdata,
    output reg [9:0] state_xr,
    output reg [9:0] state_yr,

    output reg state_write,
    output reg [3:0] state_wdata,
    output reg [9:0] state_xw,
    output reg [9:0] state_yw,

    input [1:0] cobra_dir
);

    parameter [4:0] OVERFLOW = 4'b1111;

    reg [29:0] speed = 50000000;
    reg [29:0] counter = 0;

    parameter IDLE = 0;
    parameter CALCULA_POSICAO = 1;
    parameter CHECA_COLISAO = 2;
    parameter ESCREVE_CABECA = 3;
    parameter CHECA_CAUDA = 4;
    parameter ESCREVE_CAUDA = 5;

    reg [2:0] state = IDLE;
    reg [3:0] aux;

    reg [9:0] cabeca_x = 3;
    reg [9:0] cabeca_y = 3;

    reg [1:0] cauda_dir;
    reg [9:0] cauda_x = 3;
    reg [9:0] cauda_y = 3;
    reg [9:0] cauda_last_x;
    reg [9:0] cauda_last_y;

    reg game_over = 0;
    reg comeu_fruta = 0;

always @(posedge clk) begin

    case (state) 
        IDLE: begin
            state_write = 0;
            state_read = 0;
            counter = counter + 1;
            if (counter == speed) begin
                counter = 0;
                state = ESCREVE_CABECA;
            end
        end
        CALCULA_POSICAO: begin
            cabeca_x = cabeca_x + 1;
            state = ESCREVE_CABECA;
        end
        CHECA_COLISAO: begin
            state = ESCREVE_CABECA;
        end
        ESCREVE_CABECA: begin
            state_xw = cabeca_x;
            state_yw = cabeca_y;
            state_wdata = 4'b1000;
            state_write = 1;
            state = CHECA_CAUDA;
        end
        CHECA_CAUDA: begin
            state = ESCREVE_CAUDA;
        end
        ESCREVE_CAUDA: begin
            state = IDLE;
        end
    endcase
end

endmodule //update
