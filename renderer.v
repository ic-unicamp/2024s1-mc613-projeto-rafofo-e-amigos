module renderer #(
    parameter MAPA_WIDTH,
    parameter MAPA_HEIGHT,
    parameter SCREEN_WIDTH,
    parameter SCREEN_HEIGHT,
) (
    input vga_active,
    input [2:0] mapa_block,
    output [9:0] mapa_x,
    output [9:0] mapa_y,
    output mapa_read,
    output [5:0] buffer_cor,
    output [9:0] buffer_x,
    output [9:0] buffer_y,
    output buffer_write
);

endmodule