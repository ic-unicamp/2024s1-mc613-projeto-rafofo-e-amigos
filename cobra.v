module cobra (
  input clk,
  input up,
  input down,
  input left,
  input right,
  output reg [1:0] cobra_dir
);

// up - 00
// down - 01
// left - 10
// right - 11

always @(posedge clk) begin
  if (up) begin
    cobra_dir = 2'b00;
  end else if (down) begin
    cobra_dir = 2'b01;
  end else if (left) begin
    cobra_dir = 2'b10;
  end else if (right) begin
    cobra_dir = 2'b11;
  end

  cobra_dir = 2'b00;
end

endmodule
