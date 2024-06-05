module mapa #(
    parameter MAPA_WIDTH,
    parameter MAPA_HEIGHT
) (
  input clk,
  input cobra_write,
  input [3:0] cobra_dado,
  input [9:0] cobra_x,
  input [9:0] cobra_y,

  input fruta_write,
  input fruta_read,
  input fruta_dado,
  input [9:0] fruta_x,
  input [9:0] fruta_y,

  input obstaculo_write,
  input obstaculo_read,
  input obstaculo_dado,
  input [9:0] obstaculo_x,
  input [9:0] obstaculo_y,

  input vga_read,
  input [9:0] vga_x,
  input [9:0] vga_y,
  output reg [3:0] vga_dado
);

  parameter [1:0] NADA = 0;
  parameter [1:0] COBRA = 1;
  parameter [1:0] FRUTA = 2;

  // Mapa do jogo
  // 4 bits
  // bit 3: se e cobra ou nao (se for 0: 0001 obstaculo; 0010 fruta)
  // bit 2: cobra 1 ou 2
  // bit [1:0] direcao da cauda

  reg [3:0] map [MAPA_HEIGHT-1:0][MAPA_WIDTH-1:0];

  always @(posedge clk) begin
    if (cobra_write) begin
      if (cobra_dado) begin
        map[cobra_y][cobra_x] <= COBRA;
      end else begin
        map[cobra_y][cobra_x] <= NADA;
      end
    end
  end

  always @(posedge clk) begin
    if (fruta_write) begin
      if (fruta_dado) begin
        map[fruta_y][fruta_x] <= FRUTA;
      end else begin
        map[fruta_y][fruta_x] <= NADA;
      end
    end
  end

  always @(posedge clk) begin
    if (obstaculo_write) begin
      if (obstaculo_dado) begin
        map[obstaculo_y][obstaculo_x] <= obstaculo;
      end else begin
        map[obstaculo_y][obstaculo_x] <= NADA;
      end
    end
  end

endmodule
