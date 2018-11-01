-makelib xcelium_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_refclk/sim/ila_refclk.vhd" \
  "../../../../hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_pixclk/sim/ila_pixclk.vhd" \
  "../../../ipstatic/src/SyncBase.vhd" \
  "../../../ipstatic/src/EEPROM_8b.vhd" \
  "../../../ipstatic/src/TWI_SlaveCtl.vhd" \
  "../../../ipstatic/src/GlitchFilter.vhd" \
  "../../../ipstatic/src/SyncAsync.vhd" \
  "../../../ipstatic/src/DVI_Constants.vhd" \
  "../../../ipstatic/src/SyncAsyncReset.vhd" \
  "../../../ipstatic/src/PhaseAlign.vhd" \
  "../../../ipstatic/src/InputSERDES.vhd" \
  "../../../ipstatic/src/ChannelBond.vhd" \
  "../../../ipstatic/src/ResyncToBUFG.vhd" \
  "../../../ipstatic/src/TMDS_Decoder.vhd" \
  "../../../ipstatic/src/TMDS_Clocking.vhd" \
  "../../../ipstatic/src/dvi2rgb.vhd" \
  "../../../../hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/sim/dvi2rgb_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

