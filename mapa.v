module mapa #(
    parameter MAPA_WIDTH,
    parameter MAPA_HEIGHT
) (
  input clk,
  input vga_read,
  input [9:0] mapa_x_read,
  input [9:0] mapa_y_read,
  output [1:0] mapa_R,
  output [1:0] mapa_G,
  output [1:0] mapa_B,

  input state_read,
  input [9:0] state_xr,
  input [9:0] state_yr,
  output reg [3:0] state_rdata,

  input state_write,
  input [9:0] state_xw,
  input [9:0] state_yw,
  input [3:0] state_wdata
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
      aux = mapa[mapa_y_read][mapa_x_read];
    end

    if (state_write) begin
      mapa[state_yw][state_xw] = state_wdata;
    end

    if (state_read) begin
      state_rdata = mapa[state_xr][state_yr];
    end
  end
endmodule
