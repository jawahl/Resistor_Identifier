onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib dvi2rgb_0_opt

do {wave.do}

view wave
view structure
view signals

do {dvi2rgb_0.udo}

run -all

quit -force
