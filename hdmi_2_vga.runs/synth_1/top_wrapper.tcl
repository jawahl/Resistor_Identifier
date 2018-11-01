# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param synth.incrementalSynthesisCache C:/Users/jawah/AppData/Roaming/Xilinx/Vivado/.Xil/Vivado-19484-poseidon/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/jawah/hdmi_2_vga/hdmi_2_vga.cache/wt [current_project]
set_property parent.project_path C:/Users/jawah/hdmi_2_vga/hdmi_2_vga.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths c:/Users/jawah/hdmi_2_vga/vivado_lib/vivado-library-master [current_project]
set_property ip_output_repo c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv C:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/new/img_proc.sv
read_verilog -library xil_defaultlib C:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/new/top_wrapper.v
read_ip -quiet c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

read_ip -quiet c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/dvi2rgb_0.xci
set_property used_in_implementation false [get_files -all c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_refclk/ila_v6_2/constraints/ila.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_refclk/ila_refclk_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_timing_workaround.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/dvi2rgb.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/dvi2rgb_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_pixclk/ila_v6_2/constraints/ila.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/dvi2rgb_0/src/ila_pixclk/ila_pixclk_ooc.xdc]

read_ip -quiet c:/Users/jawah/hdmi_2_vga/hdmi_2_vga.srcs/sources_1/ip/rgb2vga_0/rgb2vga_0.xci

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/jawah/Desktop/ZYBO_Master.xdc
set_property used_in_implementation false [get_files C:/Users/jawah/Desktop/ZYBO_Master.xdc]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top top_wrapper -part xc7z010clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top_wrapper.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_wrapper_utilization_synth.rpt -pb top_wrapper_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]