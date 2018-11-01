vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_refclk/hdl/verilog" "+incdir+../../../../hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_pixclk/hdl/verilog" "+incdir+../../../../hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_refclk/hdl/verilog" "+incdir+../../../../hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_pixclk/hdl/verilog" \
"C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
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

vlog -work xil_defaultlib \
"glbl.v"

