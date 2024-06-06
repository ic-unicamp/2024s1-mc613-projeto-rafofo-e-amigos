module mapa #(
    parameter MAPA_WIDTH,
    parameter MAPA_HEIGHT
) (
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
  output reg [3:0] update_rdata,

  input update_wenable,
  input [9:0] update_wx,
  input [9:0] update_wy,
  input [3:0] update_wdata
);

  // Mapa do jogo
  // 4 bits
  // bit 3: se e cobra ou nao (se for 0: 0001 obstaculo; 0010 fruta)
  // bit 2: cobra 1 ou 2
  // bit [1:0] direcao da cauda

  reg [3:0] mapa [29:0][39:0];
  reg [3:0] aux;

  assign mapa_R = (aux == 4'b0010) ? 2'b11 : 2'b00;
  assign mapa_G = (aux[3] == 1) ? 2'b11 : 2'b00;
  assign mapa_B = (aux == 4'b0001) ? 2'b11 : 2'b00;

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
