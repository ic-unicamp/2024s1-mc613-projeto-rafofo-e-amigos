module renderer #(
  parameter SCREEN_WIDTH,
  parameter BLOCK_BITS,
  parameter BLOCK_SIZE
) (
  input clk,

  // Sinais de sincronização vga
  input pixel_read,
  input [9:0] pixel_x,
  input [9:0] pixel_y,
  // Sinal de saída para o vga
  output reg [5:0] cor,

  // Sinais do mapa
  output [9:0] mapa_x,
  output [9:0] mapa_y,
  input [5:0] mapa_cor,
  output reg mapa_read
);

    reg [5:0] linha [(SCREEN_WIDTH / BLOCK_SIZE) - 1:0];

    assign mapa_x = pixel_x[9:BLOCK_BITS];
    assign mapa_y = pixel_y[9:BLOCK_BITS];

    reg [9:0] mapa_y_buf;

    reg [9:0] linha_x = 0; // Até qual bloco da linha foi memorizado

    always @(posedge clk) begin
        if (pixel_read) begin
            mapa_read = 1;
            cor <= mapa_cor;
        end else begin
            mapa_read = 0;
        end


//            if(mapa_y_buf != mapa_y) begin
//                // Se a linha do vga ta diferente da linha armazenada,
//                // reseta ela
//                linha_x = 0;
//            end
//            if (mapa_x == linha_x) begin
//                mapa_read = 1;
//                linha[mapa_x] <= mapa_cor;
//                cor = 6'b110011;
//                linha_x = linha_x + 1;
//                mapa_y_buf = mapa_y;
//            end else begin
//                cor = 6'b111111;
//                mapa_read = 0;
//            end
//        end
    end

endmodule
