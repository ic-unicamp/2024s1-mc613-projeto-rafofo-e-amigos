module mapa #(
    parameter MAPA_WIDTH,
    parameter MAPA_HEIGHT
) (
  input beating_high_score,
  input game_over,
  input clk,
  input vga_read,
  input [9:0] renderer_rx,
  input [9:0] renderer_ry,
  output [1:0] mapa_R,
  output [1:0] mapa_G,
  output [1:0] mapa_B,

  input update_renable,
  input [9:0] update_rx,
  input [9:0] update_ry,
  output reg [1:0] update_rdata,

  input update_wenable,
  input [9:0] update_wx,
  input [9:0] update_wy,
  input [1:0] update_wdata
);

  // Mapa do jogo
  // 2 bits
  // 00 nada
  // 01 cobra
  // 10 fruta
  // 11 obstaculo

  reg [1:0] mapa [29:0][39:0];
  reg [1:0] aux;

  assign mapa_R = (game_over) ? 2'b11 : (aux == 2'b10) ? 2'b11 : (aux == 2'b01 && beating_high_score) ? 2'b11 : 2'b00;
  assign mapa_G = (game_over) ? 2'b00 : (aux == 2'b01) ? 2'b11 : 2'b00;
  assign mapa_B = (game_over) ? 2'b00 : (aux == 2'b11) ? 2'b11 : 2'b00;

  always @(posedge clk) begin
    if (vga_read) begin
      aux = mapa[renderer_ry][renderer_rx];
    end

    if (update_wenable) begin
      mapa[update_wy][update_wx] = update_wdata;
    end

    if (update_renable) begin
      update_rdata = mapa[update_rx][update_ry];
    end
  end
endmodule
