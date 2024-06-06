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

  wire [1:0] cobra_dir;

  wire [9:0] vga_x;
  wire [9:0] vga_y;

  wire [9:0] mapa_x_read;
  wire [9:0] mapa_y_read;

  wire fruta_write;
  wire [9:0] fruta_xw;
  wire [9:0] fruta_yw;

  wire obstaculo_write;
  wire [9:0] obstaculo_xw;
  wire [9:0] obstaculo_yw;

  wire state_read;
  wire [3:0] state_rdata;
  wire [9:0] state_xr;
  wire [9:0] state_yr;

  wire state_write;
  wire [5:0] state_xw;
  wire [9:0] state_yw;
  wire [9:0] state_wdata;

  // Calculated colors
  wire [7:0] R;
  wire [7:0] G;
  wire [7:0] B;

  wire [19:0] score;
  wire [19:0] high_score;

  parameter [9:0] SCREEN_WIDTH= 640;
  parameter [9:0] SCREEN_HEIGHT= 480;

  // TODO: Decidir tamanho
  parameter [9:0] BLOCK_SIZE = 16;
  parameter [4:0] BLOCK_BITS = 4;

  parameter [9:0] MAPA_WIDTH = SCREEN_WIDTH / BLOCK_SIZE;
  parameter [9:0] MAPA_HEIGHT = SCREEN_HEIGHT / BLOCK_SIZE;

  // Display vga
  vga out (
    .CLOCK_50(CLOCK_50),
    .reset(KEY[0]),
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
    .active(vga_active),
    .x(vga_x),
    .y(vga_y)
  );

  // Faz a comunicação entre o vga e o mapa
  renderer #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .BLOCK_SIZE(BLOCK_SIZE),
    .BLOCK_BITS(BLOCK_BITS)
  ) renderer (
    .clk(CLOCK_50),
    .pixel_read(vga_active),
    .pixel_x(vga_x),
    .pixel_y(vga_y),
    .R(R),
    .G(G),
    .B(B),
    .mapa_x(mapa_x_read),
    .mapa_y(mapa_y_read),
    .mapa_R(mapa_R),
    .mapa_G(mapa_G),
    .mapa_B(mapa_B),
    .mapa_read(mapa_read)
  );


  // RAM do mapa
  mapa #(
    .MAPA_HEIGHT(MAPA_HEIGHT),
    .MAPA_WIDTH(MAPA_WIDTH)
  ) mapa (
    .clk(CLOCK_50),

    .vga_read(mapa_read),
    .mapa_R(mapa_R),
    .mapa_G(mapa_G),
    .mapa_B(mapa_B),
    .mapa_x_read(mapa_x_read),
    .mapa_y_read(mapa_y_read),

    .state_read(state_read),
    .state_xr(state_xr),
    .state_yr(state_yr),
    .state_rdata(state_rdata),

    .state_write(state_write),
    .state_xw(state_xw),
    .state_yw(state_yw),
    .state_wdata(state_wdata)
  );

  update #(
    .MAPA_HEIGHT(MAPA_HEIGHT),
    .MAPA_WIDTH(MAPA_WIDTH)
  ) update (
    .clk(CLOCK_50),

    .state_read(state_read),
    .state_rdata(state_rdata),
    .state_xr(state_xr),
    .state_yr(state_yr),

    .state_write(state_write),
    .state_wdata(state_wdata),
    .state_xw(state_xw),
    .state_yw(state_yw),

    .cobra_dir(cobra_dir)
  );

  cobra (
    .clk(CLOCK_50),
    .up(KEY[0]),
    .down(KEY[1]),
    .right(KEY[2]),
    .left(KEY[3]),
    .cobra_dir(cobra_dir)
  );

  fruta #(
    .MAPA_HEIGHT(MAPA_HEIGHT),
    .MAPA_WIDTH(MAPA_WIDTH)
  ) fruta (
    .clk(CLOCK_50),
    .fruta_write(fruta_write),
    .fruta_xw(fruta_xw),
    .fruta_yw(fruta_yw)
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
endmodule
