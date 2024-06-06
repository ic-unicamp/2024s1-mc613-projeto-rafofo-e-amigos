module renderer #(
  parameter SCREEN_WIDTH,
  parameter BLOCK_BITS,
  parameter BLOCK_SIZE
) (
  input clk,

  // Sinais de sincronização vga
  input pixel_read,
  input [9:0] vga_rx,
  input [9:0] vga_ry,

  // Sinal de saída para o vga
  output [1:0] R,
  output [1:0] G,
  output [1:0] B,

  // Sinais do mapa
  output [9:0] renderer_rx,
  output [9:0] renderer_ry,
  input [1:0] mapa_R,
  input [1:0] mapa_G,
  input [1:0] mapa_B,
  output mapa_read
);

    reg [1:0] linha [(SCREEN_WIDTH / BLOCK_SIZE) - 1:0][2:0];

    assign renderer_rx = vga_rx >> 4;
    assign renderer_ry = vga_ry >> 4;

    assign R = mapa_R;
    assign G = mapa_G;
    assign B = mapa_B;

    assign mapa_read = pixel_read;

    reg [9:0] mapa_y_buf;

    reg [9:0] linha_x = 0; // Até qual bloco da linha foi memorizado
endmodule
