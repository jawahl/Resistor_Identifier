`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jake Wahl and Carson Robles
// 
// Create Date: 10/31/2018 01:34:50 PM
// Design Name: 
// Module Name: top_wrapper
// Project Name: 
// Target Devices: Zybo Zynq SoC
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_wrapper(

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
  clk_wiz_0 clk_wiz_0_i (
    .clk_in1  (clk),
    .clk_out1  (hdmi_clk),
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
  dvi2rgb_0 dvi2rgb_0_i (
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
    .SDA_I     (ddc_sda_io),
    .SDA_O     (ddc_sda_o),
    .SDA_T     (ddc_sda_t),
    .SCL_I     (ddc_scl_io),
    .SCL_O     (ddc_scl_o),
    .SCL_T     (ddc_scl_t),
    .pRst_n        (1)
  );

//////////////////////////////
// PIXEL CLK DOMAIN
//////////////////////////////

  wire [23:0] vga_data;
  wire        vga_vde;
  wire        vga_hsync;
  wire        vga_vsync;


img_proc img_proc_i (
    .clk (pix_clk),
    .data_i (vid_data + {6{sw}}),
    .vde_i (vid_vde),
    .hsync_i (vid_hsync),
    .vsync_i (vid_vsync),
    .data_o (vga_data),
    .vde_o (vga_vde),
    .hsync_o (vga_hsync),
    .vsync_o (vga_vsync)
);

  // RGB to VGA converter
  rgb2vga_0 rgb2vga_0_i (
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
