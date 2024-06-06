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
  output [1:0] mapa_B
);

  parameter [3:0] NADA = 0;
  parameter [3:0] COBRA = 1;
  parameter [3:0] FRUTA = 2;
  parameter [3:0] OBSTACULO = 3;

  // Mapa do jogo
  // 4 bits
  // bit 3: se e cobra ou nao (se for 0: 0001 obstaculo; 0010 fruta)
  // bit 2: cobra 1 ou 2
  // bit [1:0] direcao da cauda

  reg [3:0] mapa [29:0][39:0];
  reg [3:0] aux;

  initial begin
    mapa[0][0] = 4'b0001;
    mapa[0][10] = 4'b0010;
    mapa[14][19] = 4'b0001;
    mapa[14][20] = 4'b0001;
    mapa[15][19] = 4'b0001;
    mapa[15][20] = 4'b0001;
    mapa[10][10] = 4'b0010;
    mapa[10][11] = 4'b0010;
  end

  assign mapa_R = (aux == 4'b0001) ? 2'b11 : 2'b00;
  assign mapa_G = (aux == 4'b0010) ? 2'b11 : 2'b00;
  assign mapa_B = 2'b00;

  always @(posedge clk) begin
    if (vga_read) begin
      aux <= mapa[mapa_y_read][mapa_x_read];
    end
  end
endmodule
