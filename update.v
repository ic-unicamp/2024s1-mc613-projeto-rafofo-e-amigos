module update #(
    parameter MAPA_HEIGHT,
    parameter MAPA_WIDTH,
) (
    input [1:0] mapa_dado,
    output mapa_read,
    output [9:0] mapa_x,
    output [9:0] mapa_y,

    input [1:0] cobra_dir,
);

    reg [9:0] cabeca_x;
    reg [9:0] cabeca_y;

    reg [9:0] cauda_x;
    reg [9:0] cauda_y;

endmodule //update