onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_tb/clk
add wave -noupdate /control_tb/reset
add wave -noupdate /control_tb/start
add wave -noupdate -radix unsigned /control_tb/A
add wave -noupdate -radix unsigned /control_tb/data_out
add wave -noupdate /control_tb/found
add wave -noupdate /control_tb/notfound
add wave -noupdate /control_tb/done
add wave -noupdate -radix unsigned /control_tb/to_check
add wave -noupdate -radix unsigned /control_tb/loc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
