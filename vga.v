module vga (
  // -------------------------
  // Interface com a placa
  input CLOCK_50,
  input reset,
  // Sinais do módulo de controle
  input [5:0] RGB,
  // -------------------------
  // Sinais para o DAC
  output wire VGA_CLK,
  output [7:0] VGA_R,
  output [7:0] VGA_G,
  output [7:0] VGA_B,
  output VGA_SYNC_N,
  output VGA_BLANK_N,
  // ------------------------
  // Sinais de sincronização
  output VGA_HS,
  output VGA_VS,
  // ------------------------
  // Sinais de controle do pixel atual
  output active,
  output reg [9:0] x,
  output reg [9:0] y
);

  reg [10:0] hcounter = 0;
  reg [10:0] vcounter = 0;
  reg vga_clk_aux = 0;

  wire [1:0] R;
  wire [1:0] G;
  wire [1:0] B;

  assign R = RGB[5:4];
  assign G = RGB[3:2];
  assign B = RGB[1:0];

  parameter [9:0] VTA = 2;
  parameter [9:0] VTB = 35; // 2 + 33
  parameter [9:0] VTC = 515; // 2 + 33 + 480
  parameter [9:0] VTD = 525; // 2 + 33 + 480 + 10
  parameter [9:0] HTA = 96;
  parameter [9:0] HTB = 144; // 96 + 48
  parameter [9:0] HTC = 784; // 96 + 48 + 640
  parameter [9:0] HTD = 800; // 96 + 48 + 640 + 16

  assign VGA_CLK = vga_clk_aux;
  assign VGA_BLANK_N = 1;
  assign VGA_SYNC_N = 1;
  assign VGA_HS = (hcounter < HTA) ? 0 : 1;
  assign VGA_VS = (vcounter < VTA) ? 0 : 1;
  assign active = ((hcounter >= HTB) && (hcounter < HTC) && (vcounter >= VTB) && (vcounter < VTD))? 1 : 0;
  assign VGA_R = (active) ? {R, 6'b0} : 0; 
  assign VGA_G = (active) ? {G, 6'b0} : 0;
  assign VGA_B = (active) ? {B, 6'b0} : 0;

  always @(posedge CLOCK_50) begin
      vga_clk_aux = !vga_clk_aux;
  end

  always @(posedge VGA_CLK) begin
    if (reset == 0) begin
      hcounter = 0;
      vcounter = 0;
    end

    else begin
      hcounter = hcounter + 1;
      if (hcounter == HTD) begin
        hcounter = 0;
        vcounter = vcounter + 1;
        if (vcounter == VTD)
          vcounter = 0;
      end
    end

    x = (hcounter >= HTB && hcounter < HTD) ? hcounter - HTB : -1;
    y = (vcounter >= VTB && vcounter < VTD) ? vcounter - VTB : -1;
  end

endmodule
