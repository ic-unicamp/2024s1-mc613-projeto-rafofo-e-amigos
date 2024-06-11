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

    reg inicial = 1;
    reg game_over = 0;
    reg comeu_fruta = 0;

always @(posedge clk) begin
    update_wx = 10;
    update_wy = 10;
    update_wdata = 2'b01;
    update_wenable = 1;
end

endmodule //update
