module frame_buffer #(
    parameter SCREEN_HEIGHT,
    parameter SCREEN_WIDTH,
) (
  input renderer_clk,
  input renderer_write,
  input [5:0] renderer_dado,
  input [9:0] renderer_x,
  input [9:0] renderer_y,

  input vga_clk,
  input vga_write,
  output [5:0] vga_dado,
  input [9:0] vga_x,
  input [9:0] vga_y
);

  reg [5:0] map [SCREEN_HEIGHT:0][SCREEN_WIDTH:0];


endmodule
