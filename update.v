module update #(
    parameter MAPA_HEIGHT,
    parameter MAPA_WIDTH
) (
    input [3:0] mapa_dado_read,
    output [3:0] mapa_dado_write,
    output reg mapa_read,
    output reg mapa_write,
    output [4:0] mapa_x,
    output [4:0] mapa_y,

    input [1:0] cobra_dir
);

    parameter [4:0] OVERFLOW = 4'b1111;

    reg [9:0] speed;
    reg [9:0] counter;

    reg [4:0] cabeca_x;
    reg [4:0] cabeca_y;

    reg [4:0] cauda_x;
    reg [4:0] cauda_y;

    reg [1:0] cauda_dir;

    reg [4:0] next_x;
    reg [4:0] next_y;

always @(posedge clk) begin
    counter = counter + 1;
    if (counter == speed) begin
        counter = 0;

        case (cobra_dir) 
            0: begin
                next_x = cabeca_x;
                next_y = cabeca_y - 1;
            end
            1: begin
                next_x = cabeca_x;
                next_y = cabeca_y + 1;
            end
            2: begin
                next_x = cabeca_x - 1;
                next_y = cabeca_y;
            end
            3: begin
                next_x = cabeca_x + 1;
                next_y = cabeca_y;
            end
        endcase

        mapa_x = cauda_x;
        mapa_y = cauda_y;

        // Descobre a direção da cauda
        mapa_dado_read = 1;
        cauda_dir = mapa_dado_read;

        mapa_dado_read = 0;

        // Apaga a cauda
        mapa_dado_write = 0; // Vazio
        mapa_write = 1;

        mapa_write = 0;

        // Posição da nova cauda
        case (cauda_dir) begin
            0: begin
                cauda_x = cauda_x;
                cauda_y = cauda_y - 1;
            end
            1: begin
                cauda_x = cauda_x;
                cauda_y = cauda_y + 1;
            end
            2: begin
                cauda_x = cauda_x - 1;
                cauda_y = cauda_y;
            end
            3: begin
                cauda_x = cauda_x + 1;
                cauda_y = cauda_y;
            end
        endcase

        // Checa wrap da nova cauda
        if (cauda_x == MAPA_WIDTH) begin
            cauda_x = 0;
        end else if (cauda_x == OVERFLOW) begin
            cauda_x = MAPA_WIDTH - 1;
        end

        if (cauda_y == MAPA_HEIGHT) begin
            cauda_y = 0;
        end else if (cauda_y == OVERFLOW) begin
            cauda_y = MAPA_HEIGHT - 1;
        end

        // Checar wrap
        // Setar nova cabeça
        // Checar colisão
    end
end

endmodule //update
