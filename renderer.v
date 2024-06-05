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
  output reg [1:0] R,
  output reg [1:0] G,
  output reg [1:0] B,

  // Sinais do mapa
  output [9:0] mapa_x,
  output [9:0] mapa_y,
  input [1:0] mapa_R,
  input [1:0] mapa_G,
  input [1:0] mapa_B,
  output reg mapa_read
);

    reg [1:0] linha [(SCREEN_WIDTH / BLOCK_SIZE) - 1:0][2:0];

    assign mapa_x = { 3'b000, pixel_x[9:3]};
    assign mapa_y = { 3'b000, pixel_y[9:3] };

    reg [9:0] mapa_y_buf;

    reg [9:0] linha_x = 0; // Até qual bloco da linha foi memorizado

    always @(posedge clk) begin
        if (pixel_read) begin
            if(mapa_y_buf != mapa_y) begin
                // Se a linha do vga ta diferente da linha armazenada,
                // reseta ela
                linha_x = 0;
                mapa_y_buf = mapa_y;
            end if (mapa_x == linha_x) begin
                mapa_read = 1;
                linha_x = linha_x + 1;
            end else begin
                mapa_read = 0;
            end
            R = 2'b11;
            G = 2'b00;
            B = 2'b10;
        end
    end

endmodule
