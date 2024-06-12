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

    output reg [19:0] score
);

    reg [39:0] speed = 50000000;
    reg [39:0] counter = 0;
    reg [19:0] temp_score = 0;

    parameter RESET = 0;
    parameter DELAY = 1;
    parameter IDLE = 2;
    parameter CALCULA_POSICAO = 3;
    parameter CHECA_COLISAO = 4;
    parameter ATUALIZA_COBRA = 5;
    parameter NOVA_FRUTA = 8;

    reg [3:0] state = RESET;
    reg [3:0] aux;

    reg [9:0] corpo_x [127:0];
    reg [9:0] corpo_y [127:0];

    reg [9:0] cabeca_x = 10;
    reg [9:0] cabeca_y = 10;
    reg [9:0] cabeca_antx;
    reg [9:0] cabeca_anty;

    reg [1:0] cauda_dir;
	
    reg [9:0] cauda_x;
    reg [9:0] cauda_y;

    reg [29:0] delaycounter = 0;

    reg inicial = 1;
    reg [9:0] icounterx = 0;
    reg [9:0] icountery = 0;

    reg game_over = 0;
    reg comeu_fruta = 0;

    initial begin
        update_wx = cabeca_x;
        update_wy = cabeca_y;
        update_wdata = 2'b01;
        update_wenable = 1;
    end

always @(posedge clk) begin
    // if (sw_switch == 0) begin
    //   fruta_enable = 1;
    //   state = NOVA_FRUTA;
    // end
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
                cauda_x  = 0;
                cauda_y = 0;
                cabeca_antx = 0;
                cabeca_anty = 0;
                corpo_x[0] = cabeca_x;
                corpo_y[0] = cabeca_y;
                temp_score = 0;
                score = 0;

                update_wx = icounterx;
                update_wy = icountery;

                if (icounterx == 10 && icountery == 10) begin
                    update_wdata = 2'b01;
                end else if (icounterx == 13 && icountery == 13)begin
                    update_wdata = 2'b10;
                end else if (icounterx == 3 && icountery == 4)begin
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
                        inicial = 0;
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

                update_rx = cabeca_x;
                update_ry = cabeca_y;
                update_renable = 1;

                state = CHECA_COLISAO;
            end
            CHECA_COLISAO: begin
                update_renable = 0;
                aux = update_rdata;

                update_wx = cabeca_x;
                update_wy = cabeca_y;
                update_wdata = 2'b01;
                update_wenable = 1;

                // QUANDO TEM TAMANHO 2 NAO TA RECONHECENDO A Fruta, SO AS VEZES E QUANDO RECINHECE BUGA A COBRA
                if (aux == 2'b10) begin 
                    // Encontrou com uma fruta
                    comeu_fruta = 1;
                    temp_score = temp_score + 1;
                    score = temp_score; 
                end else if ((aux == 2'b01) || (aux == 2'b11)) begin
                    // Encontrou com si mesma ou um obstáculo
                    game_over = 1;
                    state = RESET;
                end
                state = ATUALIZA_COBRA;
            end
            ATUALIZA_COBRA: begin
                cabeca_antx = (cabeca_antx +1)%128;
                cabeca_anty = (cabeca_anty +1)%128;
                corpo_x[(cabeca_antx)] = cabeca_x;
                corpo_y[(cabeca_anty)] = cabeca_y;
                if (comeu_fruta == 1)begin
                    fruta_enable = 1;
                    state = NOVA_FRUTA;
                end else begin
                    update_wx = corpo_x[cauda_x];
                    update_wy = corpo_y[cauda_y];
                    update_wdata = 2'b00;
                    update_wenable = 1;

                    cauda_x = (cauda_x + 1)%128;
                    cauda_y = (cauda_y + 1)%128;
                    state = IDLE;
                end
            end
            NOVA_FRUTA: begin
                comeu_fruta = 0;
                fruta_enable = 0;
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
