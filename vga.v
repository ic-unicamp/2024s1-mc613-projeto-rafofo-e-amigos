module vga (
  // -------------------------
  // Interface com a placa
  input CLOCK_50,
  input reset,
  // Sinais do módulo de controle
  input [7:0] R,
  input [7:0] G,
  input [7:0] B,
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
  output reg [9:0] x,
  output reg [9:0] y
);

  reg [10:0] hcounter = 0;
  reg [10:0] vcounter = 0;
  wire active_display;
  reg vga_clk_aux = 0;

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
  assign active_display = ((hcounter >= HTB) && (hcounter < HTC) && (vcounter >= VTB) && (vcounter < VTD))? 1 : 0;
  assign VGA_R = (active_display) ? R : 0; 
  assign VGA_G = (active_display) ? G : 0;
  assign VGA_B = (active_display) ? B : 0;

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
