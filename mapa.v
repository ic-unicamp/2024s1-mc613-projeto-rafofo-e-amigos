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

  reg [3:0] map [MAPA_HEIGHT-1:0][MAPA_WIDTH-1:0];
  reg [3:0] aux;

  initial begin
    map[10][10] = 4'b0001;
  end

  always @(posedge clk) begin
    if (vga_read) begin
      aux = map[vga_y][vga_x];
      if (aux == 4'b0010) begin
        mapa_R = 2'b11;
        mapa_G = 2'b00;
        mapa_B = 2'b00;
      end else if (aux == 4'b0001) begin
        mapa_R = 2'b11;
        mapa_G = 2'b01;
        mapa_B = 2'b00;
      end
		else begin
		        mapa_R = 2'b00;
        mapa_G = 2'b00;
        mapa_B = 2'b00;
		end
    end
    if (cobra_write) begin
      if (cobra_dado) begin
        map[cobra_y][cobra_x] <= COBRA;
      end else begin
        map[cobra_y][cobra_x] <= NADA;
      end
    end
    if (fruta_write) begin
      if (fruta_dado) begin
        map[fruta_y][fruta_x] <= FRUTA;
      end else begin
        map[fruta_y][fruta_x] <= NADA;
      end
    end
    if (obstaculo_write) begin
      if (obstaculo_dado) begin
        map[obstaculo_y][obstaculo_x] <= OBSTACULO;
      end else begin
        map[obstaculo_y][obstaculo_x] <= NADA;
      end
    end
  end

endmodule
