module cobra (
  input clk,
  input up,
  input down,
  input left,
  input right,
  input [1:0] cobra_dir_atual,
  output reg [1:0] cobra_dir
);

// up - 00
// down - 01
// left - 10
// right - 11

always @(posedge clk) begin
  if (~up) begin
    if (cobra_dir_atual != 2'b01) begin
      cobra_dir = 2'b00;
    end
  end else if (~down) begin
    if (cobra_dir_atual != 2'b00) begin
      cobra_dir = 2'b01;
    end
  end else if (~left) begin
    if (cobra_dir_atual != 2'b11) begin
      cobra_dir = 2'b10;
    end
  end else if (~right) begin
    if (cobra_dir_atual != 2'b10) begin
      cobra_dir = 2'b11;
    end
  end
end

endmodule
