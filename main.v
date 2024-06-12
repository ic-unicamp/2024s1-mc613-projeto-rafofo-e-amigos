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

  wire [9:0] vga_rx;
  wire [9:0] vga_ry;

  wire [9:0] renderer_rx;
  wire [9:0] renderer_ry;

  wire fruta_enable;
  wire fruta_wenable;
  wire [9:0] fruta_wx;
  wire [9:0] fruta_wy;

  wire obstaculo_wenable;
  wire [9:0] obstaculo_xw;
  wire [9:0] obstaculo_yw;

  wire update_renable;
  wire [1:0] update_rdata;
  wire [9:0] update_rx;
  wire [9:0] update_ry;

  wire update_wenable;
  wire [9:0] update_wx;
  wire [9:0] update_wy;
  wire [1:0] update_wdata;

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
    .reset(SW[0]),
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
    .vga_rx(vga_rx),
    .vga_ry(vga_ry)
  );

  // Faz a comunicação entre o vga e o mapa
  renderer #(
    .SCREEN_WIDTH(SCREEN_WIDTH),
    .BLOCK_SIZE(BLOCK_SIZE),
    .BLOCK_BITS(BLOCK_BITS)
  ) renderer (
    .clk(CLOCK_50),
    .pixel_read(vga_active),
    .vga_rx(vga_rx),
    .vga_ry(vga_ry),
    .R(R),
    .G(G),
    .B(B),
    .renderer_rx(renderer_rx),
    .renderer_ry(renderer_ry),
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
    // .reset(SW[0]),
    .mapa_R(mapa_R),
    .mapa_G(mapa_G),
    .mapa_B(mapa_B),
    .renderer_rx(renderer_rx),
    .renderer_ry(renderer_ry),

    .update_renable(update_renable),
    .update_rx(update_rx),
    .update_ry(update_ry),
    .update_rdata(update_rdata),

    .update_wenable(update_wenable),
    .update_wx(update_wx),
    .update_wy(update_wy),
    .update_wdata(update_wdata)
  );

  update #(
    .MAPA_HEIGHT(MAPA_HEIGHT),
    .MAPA_WIDTH(MAPA_WIDTH)
  ) update (
    .clk(CLOCK_50),
    .reset(SW[0]),

    .update_renable(update_renable),
    .update_rdata(update_rdata),
    .update_rx(update_rx),
    .update_ry(update_ry),

    .sw_switch(SW[1]),
    .update_wenable(update_wenable),
    .update_wdata(update_wdata),
    .update_wx(update_wx),
    .update_wy(update_wy),

    .fruta_enable(fruta_enable),
    .fruta_wenable(fruta_wenable),
    .fruta_wx(fruta_wx),
    .fruta_wy(fruta_wy),

    .obstaculo_wenable(obstaculo_wenable),
    .obstaculo_wx(obstaculo_wx),
    .obstaculo_wy(obstaculo_wy),

    .cobra_dir(cobra_dir),

    .score(score)
  );

  cobra (
    .clk(CLOCK_50),
    .up(KEY[0]),
    .down(KEY[1]),
    .right(KEY[2]),
    .left(KEY[3]),
    .cobra_dir_atual(cobra_dir),
    .cobra_dir(cobra_dir)
  );

  fruta #(
    .MAPA_HEIGHT(MAPA_HEIGHT),
    .MAPA_WIDTH(MAPA_WIDTH)
  ) fruta (
    .clk(CLOCK_50),
    .fruta_enable(fruta_enable),
    .fruta_wenable(fruta_wenable),
    .fruta_wx(fruta_wx),
    .fruta_wy(fruta_wy)
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
