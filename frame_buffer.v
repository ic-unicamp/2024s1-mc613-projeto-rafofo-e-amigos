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
  input vga_read,
  output [5:0] vga_dado,
  input [9:0] vga_x,
  input [9:0] vga_y
);

  reg [5:0] map [SCREEN_HEIGHT-1:0][SCREEN_WIDTH-1:0];

  always @(posedge renderer_clk) begin
    if (renderer_write) begin
      map[renderer_y][renderer_x] <= renderer_dado;
    end
  end

  always @(posedge vga_clk) begin
    if (vga_read) begin
      vga_dado <= map[vga_y][vga_x];
    end
  end


endmodule
