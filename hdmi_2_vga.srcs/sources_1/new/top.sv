module top (
  input  wire       clk,

  input  wire [3:0] sw,

  input  wire       TMDS_Clk_p,
  input  wire       TMDS_Clk_n,
  input  wire [2:0] TMDS_Data_p,
  input  wire [2:0] TMDS_Data_n,

  output wire       HDMI_HPD,
  output wire       HDMI_OUT_EN,

  inout  wire       ddc_scl_io,
  inout  wire       ddc_sda_io,

  output wire [4:0] vga_pRed,
  output wire [5:0] vga_pGreen,
  output wire [4:0] vga_pBlue,
  output wire       vga_pHSync,
  output wire       vga_pVSync,

  output wire [3:0] led
);

//////////////////////////////
// SYSTEM CLK DOMAIN
//////////////////////////////



//////////////////////////////
// HDMI CLK DOMAIN
//////////////////////////////

  wire hdmi_clk;
  wire hdmi_clk_lck;

  // generate hdmi clock
  clk_wiz_ip clk_wiz_ip_i (
    .clk_i  (clk),
    .clk_o  (hdmi_clk),
    .reset  (0),
    .locked (hdmi_clk_lck)
  );

  wire [23:0] vid_data;
  wire        vid_vde;
  wire        vid_hsync;
  wire        vid_vsync;
  wire        pix_clk;
  wire        pix_clk_lck;

  assign ddc_sda_io = (~ddc_sda_t) ? ddc_sda_o : 1'bz;
  assign ddc_scl_io = (~ddc_scl_t) ? ddc_scl_o : 1'bz;

  // DVI to RGB converter
  dvi2rgb_ip dvi2rgb_ip_i (
    .TMDS_Clk_p    (TMDS_Clk_p),
    .TMDS_Clk_n    (TMDS_Clk_n),
    .TMDS_Data_p   (TMDS_Data_p),
    .TMDS_Data_n   (TMDS_Data_n),
    .RefClk        (hdmi_clk),
    .aRst_n        (1),
    .vid_pData     (vid_data),
    .vid_pVDE      (vid_vde),
    .vid_pHSync    (vid_hsync),
    .vid_pVSync    (vid_vsync),
    .PixelClk      (pix_clk),
    .aPixelClkLckd (pix_clk_lck),
    .DDC_SDA_I     (ddc_sda_io),
    .DDC_SDA_O     (ddc_sda_o),
    .DDC_SDA_T     (ddc_sda_t),
    .DDC_SCL_I     (ddc_scl_io),
    .DDC_SCL_O     (ddc_scl_o),
    .DDC_SCL_T     (ddc_scl_t),
    .pRst_n        (1)
  );

//////////////////////////////
// PIXEL CLK DOMAIN
//////////////////////////////

  wire [23:0] vga_data;
  wire        vga_vde;
  wire        vga_hsync;
  wire        vga_vsync;

  // placeholder for now, process data
  img_proc img_proc_i (
    .clk     (pix_clk),
    .data_i  (vid_data),
    .vde_i   (vid_vde),
    .hsync_i (vid_hsync),
    .vsync_i (vid_vsync),
    .data_o  (vga_data),
    .vde_o   (vga_vde),
    .hsync_o (vga_hsync),
    .vsync_o (vga_vsync)
  );

  // RGB to VGA converter
  rgb2vga_ip rgb2vga_ip_i (
    .rgb_pData  (vga_data),
    .rgb_pVDE   (vga_vde),
    .rgb_pHSync (vga_hsync),
    .rgb_pVSync (vga_vsync),
    .PixelClk   (pix_clk),
    .vga_pRed   (vga_pRed),
    .vga_pGreen (vga_pGreen),
    .vga_pBlue  (vga_pBlue),
    .vga_pHSync (vga_pHSync),
    .vga_pVSync (vga_pVSync)
  );

//////////////////////////////
// ASSIGN OUTPUTS
//////////////////////////////

  assign HDMI_HPD    = 1;
  assign HDMI_OUT_EN = 0;
  assign led         = {hdmi_clk_lck, pix_clk_lck, vid_vsync, vga_vsync};

endmodule
