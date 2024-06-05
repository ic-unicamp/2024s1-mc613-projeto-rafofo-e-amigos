module mapa #(
    parameter MAPA_WIDTH,
    parameter MAPA_HEIGHT
) (
  input clk,
  input vga_read,
  input [9:0] vga_x,
  input [9:0] vga_y,
  output reg [1:0] mapa_R,
  output reg [1:0] mapa_G,
  output reg [1:0] mapa_B
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
    mapa[0][0] = 1;
    mapa[0][1] = 0;
    mapa[0][2] = 0;
    mapa[1][0] = 0;
  end

  always @(posedge clk) begin
    if (vga_read) begin
      aux = mapa[vga_y][vga_x];
      if (aux == 4'b0010) begin
        mapa_R <= 2'b11;
        mapa_G <= 2'b00;
        mapa_B <= 2'b00;
      end else if (aux == 4'b0001) begin
        mapa_R <= 2'b11;
        mapa_G <= 2'b01;
        mapa_B <= 2'b00;
      end else begin
        mapa_R <= 2'b00;
        mapa_G <= 2'b00;
        mapa_B <= 2'b00;
      end
    end
  end

endmodule
