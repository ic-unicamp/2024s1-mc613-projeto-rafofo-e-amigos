module renderer #(
    parameter BLOCK_SIZE,
    parameter MAPA_WIDTH,
    parameter MAPA_HEIGHT,
    parameter SCREEN_WIDTH,
    parameter SCREEN_HEIGHT,
) (

    input clk,
    input vga_active,

    input [3:0] mapa_block,
    output [9:0] mapa_x,
    output [9:0] mapa_y,
    output mapa_read,

    output [5:0] buffer_cor,
    output [9:0] buffer_x,
    output [9:0] buffer_y,
    output buffer_write
);

    reg [3:0] block_aux = 0;
    reg [7:0] block_x = 0;
    reg [7:0] block_y = 0;
    reg done = 0;

    always @(posedge clk) begin
        if (~vga_active && ~done) begin

            if (block_x == 0 && block_y == 0) begin
                mapa_read = 1;
            end else begin
                mapa_read = 0;
            end

            if (mapa_block == 4'b0001) begin
                // Fruta
                buffer_dado = 6'b110000;
            end else if (mapa_block == 4'b0010) begin
                // Obstáculo
                buffer_dado = 6'b111111;
            end else if (mapa_block & 4'b1100 == 4'b1000) begin
                // Cobra 1
                buffer_dado = 6'b001100;
            end else if (mapa_block & 4'b1100 == 4'b1100) begin
                // Cobra 2
                buffer_dado = 6'b001111;
            end else begin
                buffer_dado = 6'b0;
            end

            buffer_write = 1;

            block_x = block_x + 1;

            if (block_x == BLOCK_SIZE) begin
                // Linha do bloco
                block_x = 0;
                block_y = block_y + 1;

                if (block_y == BLOCK_SIZE) begin
                    // Final do bloco
                    block_y = 0;
                    mapa_x = mapa_x + 1;

                    if (mapa_x == MAPA_WIDTH) begin
                        // Linha do mapa
                        mapa_x = 0;
                        mapa_y = mapa_y + 1;

                        if (mapa_y == MAPA_HEIGHT) begin
                            // Final do mapa
                            mapa_y = 0;
                            done = 1;
                        end
                    end
                end
            end

        end else begin
            mapa_read = 0;
            mapa_x = 0;
            mapa_y = 0;
            buffer_write = 0;
            buffer_x = 0;
            buffer_y = 0;
            done = 0;
        end
    end

endmodule
