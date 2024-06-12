module update #(
    parameter MAPA_HEIGHT,
    parameter MAPA_WIDTH
) (
    input clk,
    input reset,
    output reg update_renable,
    input [1:0] update_rdata,
    output reg [9:0] update_rx,
    output reg [9:0] update_ry,

    output reg update_wenable,
    output reg [1:0] update_wdata,
    output reg [9:0] update_wx,
    output reg [9:0] update_wy,

    // output reg [9:0] update_cauda_wx,
    // output reg [9:0] update_cauda_wy,

    input sw_switch,

    output reg fruta_enable,
    input fruta_wenable,
    input [9:0] fruta_wx,
    input [9:0] fruta_wy,

    output reg obstaculo_wenable,
    input [9:0] obstaculo_wx,
    input [9:0] obstaculo_wy,

    input [1:0] cobra_dir,

    output reg [19:0] score,
    output reg [19:0] high_score,
    output reg beating_high_score,
    output reg game_over
);

    reg [39:0] speed;
    reg [39:0] counter = 0;
    reg [19:0] temp_score = 0;

    parameter RESET = 0;
    parameter DELAY = 1;
    parameter IDLE = 2;
    parameter CALCULA_POSICAO = 3;
    parameter CHECA_COLISAO = 4;
    parameter ATUALIZA_COBRA = 5;
    parameter NOVA_FRUTA = 8;
    parameter GAME_OVER = 6;
    parameter speed_limit = 10000000;

    reg [3:0] state = RESET;
    reg [3:0] last_state;
    reg [3:0] aux;

    reg [9:0] corpo_x [127:0];
    reg [9:0] corpo_y [127:0];

    reg [9:0] cabeca_x = 10;
    reg [9:0] cabeca_y = 10;

    reg [9:0] fruta_x = 13;
    reg [9:0] fruta_y = 13;

    reg [9:0] obs_x = 3;
    reg [9:0] obs_y = 4;

    reg [9:0] cabeca_lista;
    reg [9:0] cauda_lista;

    reg [29:0] delaycounter = 0;

    reg [9:0] icounterx = 0;
    reg [9:0] icountery = 0;

    
    reg comeu_fruta = 0;

always @(posedge clk) begin
    if (reset == 0) begin
        state = RESET;
    end else begin 
        case (state)
            RESET: begin
                game_over = 0;
                comeu_fruta = 0;
                counter = 0;
                cabeca_x = 10;
                cabeca_y = 10;
                cauda_lista  = 0;
                cabeca_lista = 0;
                corpo_x[0] = cabeca_x;
                corpo_y[0] = cabeca_y;
                temp_score = 0;
                score = 0;
                beating_high_score = 0;
                speed = 50000000;
                update_wx = icounterx;
                update_wy = icountery;

                if (icounterx == cabeca_x && icountery == cabeca_y) begin
                    update_wdata = 2'b01;
                end else if (icounterx == fruta_x && icountery == fruta_y)begin
                    update_wdata = 2'b10;
                end else if (icounterx == obs_x && icountery == obs_y)begin
                    update_wdata = 2'b11;
                end else begin
                    update_wdata = 0;
                end
                update_wenable = 1;

                icounterx = icounterx + 1;
                if (icounterx == 40) begin
                    icounterx = 0;
                    icountery = icountery + 1;
                    if (icountery == 30) begin
                        icountery = 0;
                        icounterx = 0;
                        update_wenable = 0;
                        state = DELAY;
                    end
                end
            end
            DELAY: begin
                delaycounter = delaycounter + 1;
                if (delaycounter == 100000000) begin
                    delaycounter = 0;
                    state = IDLE;
                end
            end
            IDLE: begin
                counter = counter + 1;
                update_wenable = 0;
                update_renable = 0;
                fruta_enable = 0;
                obstaculo_wenable = 0;
                comeu_fruta = 0;
                if (counter >= speed) begin
                    counter = 0;
                    state = CALCULA_POSICAO;
                end
            end
            CALCULA_POSICAO: begin
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

                state = CHECA_COLISAO;
            end
            CHECA_COLISAO: begin

                update_wx = cabeca_x;
                update_wy = cabeca_y;
                update_wdata = 2'b01;
                update_wenable = 1;

                // QUANDO TEM TAMANHO 2 NAO TA RECONHECENDO A Fruta, SO AS VEZES E QUANDO RECINHECE BUGA A COBRA
                state = ATUALIZA_COBRA;
                if (fruta_x == cabeca_x && fruta_y == cabeca_y) begin 
                    // Encontrou com uma fruta
                    comeu_fruta = 1;
                    temp_score = temp_score + 1;
                    score = temp_score; 
                    // Atualiza a pontuação do jogo
                    if (score > high_score) begin
                        high_score = score;
                        beating_high_score = 1;
                    end
                    // Aumenta a velocidade de cobra
                    if (speed > speed_limit) begin
                        speed = speed - 5000000;
                    end
                end else if ((obs_x == cabeca_x && obs_y == cabeca_y)) begin
                    // Encontrou com si mesma ou um obstáculo
                    game_over = 1;
                    state = GAME_OVER;
                end
            end
            GAME_OVER: begin
            end
            ATUALIZA_COBRA: begin
                cabeca_lista = (cabeca_lista + 1) % 128;
                corpo_x[(cabeca_lista)] = cabeca_x;
                corpo_y[(cabeca_lista)] = cabeca_y;

                if (comeu_fruta == 1)begin
                    fruta_enable = 1;
                    state = NOVA_FRUTA;
                end else begin
                    update_wx = corpo_x[cauda_lista];
                    update_wy = corpo_y[cauda_lista];

                    update_wdata = 2'b00;
                    update_wenable = 1;

                    cauda_lista = (cauda_lista + 1) % 128;
                    state = IDLE;
                end
            end
            NOVA_FRUTA: begin
                comeu_fruta = 0;
                fruta_enable = 0;

                fruta_x = fruta_wx;
                fruta_y = fruta_wy;

                update_wx = fruta_wx;
                update_wy = fruta_wy;
                update_wdata = 2'b10;
                update_wenable = 1;
                state = IDLE;
            end
        endcase
    end
end

endmodule //update
