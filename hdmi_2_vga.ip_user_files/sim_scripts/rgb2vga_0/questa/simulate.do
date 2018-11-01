onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib rgb2vga_0_opt

do {wave.do}

view wave
view structure
view signals

do {rgb2vga_0.udo}

run -all

quit -force
