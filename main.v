module main (
  // -------------------------
  // Interface com a placa
  input CLOCK_50,
  input [3:0] KEY,
  input [9:0] SW,
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3,
  output [6:0] HEX4,
  output [6:0] HEX5,
  // -------------------------
  // Sinais para o DAC
  output wire VGA_CLK,
  output [7:0] VGA_R,
  output [7:0] VGA_G,
  output [7:0] VGA_B,
  output VGA_SYNC_N,
  output VGA_BLANK_N,
  output VGA_HS,
  output VGA_VS
);

  // User input
  wire reset;
  wire up;
  wire down;
  wire left;
  wire right;

  wire [9:0] x;
  wire [9:0] y;

  // Calculated colors
  wire [7:0] R;
  wire [7:0] G;
  wire [7:0] B;

  wire [19:0] score;
  wire [19:0] high_score;

  parameter [9:0] SCREEN_WIDTH_PIXELS = 640;
  parameter [9:0] SCREEN_HEIGHT_PIXELS = 480;

  // TODO: Decidir tamanho
  parameter [9:0] BLOCK_SIZE = 10;

  parameter [9:0] SCREEN_WIDTH = SCREEN_WIDTH_PIXELS / BLOCK_SIZE;
  parameter [9:0] SCREEN_HEIGHT = SCREEN_HEIGHT_PIXELS / BLOCK_SIZE;

  // Display vga
  vga out (
    .CLOCK_50(CLOCK_50),
    .reset(reset),
    .R(R),
    .G(G),
    .B(B),
    .VGA_CLK(VGA_CLK),
    .VGA_G(VGA_G),
    .VGA_R(VGA_R),
    .VGA_B(VGA_B),
    .VGA_SYNC_N(VGA_SYNC_N),
    .VGA_BLANK_N(VGA_BLANK_N),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .x(x),
    .y(y)
  );

  // RAM do mapa
  mapa mapa (
    .cobra_clk(),
    .cobra_write(),
    .cobra_dado(),
    .cobra_x(),
    .cobra_y(),

    .fruta_clk(),
    .fruta_write(),
    .fruta_dado(),
    .fruta_x(),
    .fruta_y()
  );

  // Display da pontuação
  bin2display display (
    .pontuacao(score),
    .high_score(high_score),
    .digito0(HEX0),
    .digito1(HEX1),
    .digito2(HEX2),
    .digito3(HEX3),
    .digito4(HEX4),
    .digito5(HEX5)
  );

// TODO: Módulo da cobra

// TODO: Módulo de colisão

endmodule
