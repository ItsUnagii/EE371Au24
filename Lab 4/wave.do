onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /task2_tb/clk
add wave -noupdate /task2_tb/reset
add wave -noupdate -radix unsigned /task2_tb/A
add wave -noupdate -radix unsigned /task2_tb/loc
add wave -noupdate /task2_tb/start
add wave -noupdate /task2_tb/found
add wave -noupdate /task2_tb/notfound
add wave -noupdate /task2_tb/done
add wave -noupdate -radix unsigned /task2_tb/dut/to_check
add wave -noupdate -radix unsigned /task2_tb/dut/data_out
add wave -noupdate -radix unsigned /task2_tb/dut/c_unit/upper_bound
add wave -noupdate -radix unsigned /task2_tb/dut/c_unit/lower_bound
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25034 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {535500 ps}
