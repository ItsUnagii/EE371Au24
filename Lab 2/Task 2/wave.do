onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /Lab2Task2_tb/dut/dataIn
add wave -noupdate -radix unsigned /Lab2Task2_tb/dut/dataOut
add wave -noupdate -radix unsigned /Lab2Task2_tb/dut/wraddress
add wave -noupdate /Lab2Task2_tb/dut/wren
add wave -noupdate /Lab2Task2_tb/dut/reset
add wave -noupdate -radix unsigned /Lab2Task2_tb/dut/count
add wave -noupdate /Lab2Task2_tb/dut/incrementer/SLOW_CLOCK
add wave -noupdate /Lab2Task2_tb/HEX0
add wave -noupdate /Lab2Task2_tb/HEX1
add wave -noupdate /Lab2Task2_tb/HEX2
add wave -noupdate /Lab2Task2_tb/HEX3
add wave -noupdate /Lab2Task2_tb/HEX4
add wave -noupdate /Lab2Task2_tb/HEX5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {141 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 284
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {268 ps}
