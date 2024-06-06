module fruta #(
    parameter MAPA_HEIGHT,
    parameter MAPA_WIDTH
) (
    input clk,
    input fruta_enable,
    output reg fruta_wenable,
    output reg [9:0] fruta_wx,
    output reg [9:0] fruta_wy
);

parameter [39:0] SEED = 'h12345ABCDEF;

reg [19:0] state_x = SEED[39:20];
reg [19:0] state_y = SEED[19:0];

always @(posedge clk) begin
    if (fruta_enable) begin
        fruta_wx = state_x % 40;
        fruta_wy = state_y % 30;
        fruta_wenable = 1;
    end else begin
        fruta_wenable = 0;
        state_x = state_x + state_y;
        state_x = state_x >> 3;
        state_y = state_y * 7;
        state_y = state_y - 31;
    end
end

endmodule //fruta
