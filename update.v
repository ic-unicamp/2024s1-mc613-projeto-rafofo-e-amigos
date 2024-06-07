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

    // output reg [9:0] update_cauda_wx,
    // output reg [9:0] update_cauda_wy,

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
    parameter APAGA_CAUDA = 5;
    parameter ATUALIZA_CAUDA = 6;
    parameter GAME_OVER = 7;
    parameter INICIAL = 8;

    reg [2:0] state = IDLE;
    reg [3:0] aux;

    reg [9:0] cabeca_x = 3;
    reg [9:0] cabeca_y = 3;

    reg [1:0] cauda_dir;
	
    reg [9:0] cauda_x;
    reg [9:0] cauda_y;
    reg [9:0] cauda_last_x;
    reg [9:0] cauda_last_y;

    reg inicial = 0;

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
            if (inicial == 0) begin
                cauda_x = cabeca_x;
                cauda_y = cabeca_y;
                state = INICIAL;
            end
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
            // é uma fruta ou obstaculo:
            update_rx = cabeca_x;
            update_ry = cabeca_y;
            update_renable = 1;
            state = CHECA_COLISAO;
        end
        CHECA_COLISAO: begin
            aux = update_rdata;
            if ((aux[3] == 1 ) || (aux == 4'b0001))begin
            // Colidiu com o obstáculo ou com si mesma
                game_over = 1;
            end else if (aux == 4'b0010) begin
            // Comeu a fruta    
                comeu_fruta = 1;
                tamanho = tamanho + 1; 
            end 
            state = ESCREVE_CABECA;
        end
        ESCREVE_CABECA: begin
            update_wx = cabeca_x;
            update_wy = cabeca_y;
            update_wdata = 8 + cobra_dir;
            update_wenable = 1;
            state = CHECA_CAUDA;
        end
        INICIAL: begin
            update_wx = cauda_x;
            update_wy = cauda_y;
            update_wdata = 4'b0000;
            inicial = 1;
            state = CALCULA_POSICAO;
        end
        CHECA_CAUDA: begin
            // Se não tiver comido uma fruta, pede
            // a leitura da cauda pra descobrir a
            // direção dela
            if (comeu_fruta != 1) begin
                update_rx = cauda_x;
                update_ry = cauda_y;
                update_renable = 1;
                state = APAGA_CAUDA;
            end else if (comeu_fruta == 1) begin
            // Comeu a fruta e aumenta o tamanho da cobra
            end
            
        end
        APAGA_CAUDA: begin
            // Não comeu fruta
            // Com a direção da cauda, apaga a cauda
            // antiga e seta a nova cauda
            aux = update_rdata[1:0];
            cauda_last_x = cauda_x;
            cauda_last_y = cauda_y;
            case (aux)
                0: begin
                    cauda_y = (cauda_y == 0) ? MAPA_HEIGHT - 1 : cauda_y - 1;
                end
                1: begin
                    cauda_y = (cauda_y == MAPA_HEIGHT - 1) ? 0 : cauda_y + 1;
                end
                2: begin
                    cauda_x = (cauda_x == 0) ? MAPA_WIDTH - 1 : cauda_x - 1;
                end
                3: begin
                    cauda_x = (cauda_x == MAPA_WIDTH - 1) ? 0 : cauda_x + 1;
                end
            endcase
            // Apaga a cauda atual
            update_wx = cauda_last_x;
            update_wy = cauda_last_y;
            update_wdata = 4'b0000;
            update_wenable = 1;
            
            state = ATUALIZA_CAUDA;
        end
        ATUALIZA_CAUDA: begin
            // Atualiza o próximo nó para ser a cauda
            update_wx = cauda_x;
            update_wy = cauda_y;
            update_wdata = aux;
            update_wenable = 1;
            state = IDLE;
        end

    endcase
end

endmodule //update
