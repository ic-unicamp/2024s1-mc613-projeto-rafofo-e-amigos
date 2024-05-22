module bin2display (
  input [19:0] pontuacao,
  input [19:0] high_score,
  output [6:0] digito0, // digito da direita
  output [6:0] digito1,
  output [6:0] digito2,
  output [6:0] digito3,
  output [6:0] digito4,
  output [6:0] digito5 // digito da esquerda
);

reg [3:0] digito0_bcd;
reg [3:0] digito1_bcd;
reg [3:0] digito2_bcd;
reg [3:0] digito3_bcd;
reg [3:0] digito4_bcd;
reg [3:0] digito5_bcd;
wire [25:0] digitosDir;
wire [25:0] digitosEsq;

wire [6:0] digito1_aux;
wire [6:0] digito2_aux;
wire [6:0] digito4_aux;
wire [6:0] digito5_aux;

bcd2display display0 (
  .numero(digito0_bcd),
  .segmentos(digito0)
);

bcd2display display1 (
  .numero(digito1_bcd),
  .segmentos(digito1_aux)
);

bcd2display display2 (
  .numero(digito2_bcd),
  .segmentos(digito2_aux)
);

bcd2display display3 (
  .numero(digito3_bcd),
  .segmentos(digito3)
);

bcd2display display4 (
  .numero(digito4_bcd),
  .segmentos(digito4_aux)
);

bcd2display display5 (
  .numero(digito5_bcd),
  .segmentos(digito5_aux)
);

bin2bcd pontuacaoDir (
  .bin(pontuacao),
  .bcd(digitosDir)
);
bin2bcd high_scoreEsq (
  .bin(high_score),
  .bcd(digitosEsq)
);

assign digito1 = (pontuacao >= 10 ) ? digito1_aux  : 7'b1111111;
assign digito2 = (pontuacao >= 100 ) ? digito2_aux  : 7'b1111111;
assign digito4 = (high_score >= 10 ) ? digito4_aux  : 7'b1111111;
assign digito5 = (high_score >= 100 ) ? digito5_aux  : 7'b1111111;

always @(pontuacao || high_score) begin
  digito0_bcd = digitosDir[3:0];
  digito1_bcd = digitosDir[7:4];
  digito2_bcd = digitosDir[11:8];
  digito3_bcd = digitosEsq[3:0];
  digito4_bcd = digitosEsq[7:4];
  digito5_bcd = digitosEsq[11:8];
end

endmodule
