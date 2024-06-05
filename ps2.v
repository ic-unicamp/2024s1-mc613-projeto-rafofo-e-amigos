module teclado (
  input clk,
  input ps2clk,
  input data,
  output reg up,
  output reg down,
  output reg left,
  output reg right
);

  reg [10:0] package_cur;
  reg parity_cur;
  reg error_cur;
