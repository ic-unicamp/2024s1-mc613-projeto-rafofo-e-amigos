module update #(
    parameter MAPA_HEIGHT,
    parameter MAPA_WIDTH
) (
    input clk,

    output reg update_renable,
    input [3:0] update_rdata,
    output reg [9:0] update_rx,
    output reg [9:0] update_ry,

    output reg update_wenable,
    output reg [3:0] update_wdata,
    output reg [9:0] update_wx,
    output reg [9:0] update_wy,

    output fruta_wenable,
    input [9:0] fruta_wx,
    input [9:0] fruta_wy,

    output obstaculo_wenable,
    input [9:0] obstaculo_wx,
    input [9:0] obstaculo_wy,

    input [1:0] cobra_dir
);

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
            update_wenable = 0;
            update_renable = 0;
            counter = counter + 1;
            if (counter == speed) begin
                counter = 0;
                state = CALCULA_POSICAO;
            end
        end
        CALCULA_POSICAO: begin
            // Calcula a proxima posição da cabeça com base na direção
            case (cobra_dir) 
                0: begin
                    cabeca_y = (cabeca_y == 0) ? MAPA_HEIGHT - 1 : cabeca_y - 1;
                end
                1: begin
                    cabeca_y = (cabeca_y == MAPA_HEIGHT - 1) ? 0 : cabeca_y + 1;
                end
                2: begin
                    cabeca_x = (cabeca_x == 0) ? MAPA_WIDTH - 1 : cabeca_x - 1;
                end
                3: begin
                    cabeca_x = (cabeca_x == MAPA_WIDTH - 1) ? 0 : cabeca_x + 1;
                end
            endcase

            // Pede a leitura da nova posição pra conferir se ela
            // é uma fruta ou obstaculo, mais ou menos assim:
            // update_rx = cabeca_x;
            // update_ty = cabeca_y;
            // update_renable = 1;
            state = CHECA_COLISAO;
        end
        CHECA_COLISAO: begin
            // aux = update_rdata;
            // Checa se é uma fruta ou obstaculo
            // Se for um obstaculo: game_over
            state = ESCREVE_CABECA;
        end
        ESCREVE_CABECA: begin
            // Escreve a cabeça
            update_wx = cabeca_x;
            update_wy = cabeca_y;
            update_wdata = 4'b1000;
            update_wenable = 1;
            state = CHECA_CAUDA;
        end
        CHECA_CAUDA: begin
            // Se não tiver comido uma fruta, pede
            // a leitura da cauda pra descobrir a
            // direção dela
            state = ESCREVE_CAUDA;
        end
        ESCREVE_CAUDA: begin
            // Com a direção da cauda, apaga a cauda
            // antiga e seta a nova cauda
            state = IDLE;
        end
    endcase
end

endmodule //update
