# Definição da imagem da maçã 16x16 pixels
apple_image = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
    [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
    [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
    [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
]

# Definindo cores RGB
colors = {
    0: 0x000000,  # Preto
    1: 0xFF0000,  # Vermelho
    2: 0x00FF00   # Verde (não usado aqui, mas incluído para referência)
}

# Função para converter a imagem para ROM Verilog
def convert_to_rom(image, color_map):
    with open('sprite_rom.v', 'w') as f:
        f.write("module sprite_rom (\n")
        f.write("    input wire [7:0] addr,\n")
        f.write("    output reg [23:0] data\n")
        f.write(");\n\n")
        f.write("    always @(*) begin\n")
        f.write("        case (addr)\n")

        addr = 0
        for row in image:
            for pixel in row:
                color = color_map.get(pixel, 0x000000)
                f.write(f"            8'd{addr}: data = 24'h{color:06X};\n")
                addr += 1

        f.write("            default: data = 24'h000000;\n")
        f.write("        endcase\n")
        f.write("    end\n")
        f.write("endmodule\n")

convert_to_rom(apple_image, colors)
