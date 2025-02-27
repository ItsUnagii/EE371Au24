onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /task1_tb/clk
add wave -noupdate -label N /task1_tb/N
add wave -noupdate -label reset /task1_tb/reset
add wave -noupdate -label A /task1_tb/A
add wave -noupdate -label s /task1_tb/s
add wave -noupdate -label result /task1_tb/result
add wave -noupdate -label done /task1_tb/done
add wave -noupdate -label /ps /task1_tb/dut/ps
add wave -noupdate -label /ns /task1_tb/dut/ns
add wave -noupdate -label /s /task1_tb/dut/s
add wave -noupdate -label /L /task1_tb/dut/L
add wave -noupdate -label /E /task1_tb/dut/E
add wave -noupdate -label /ShiftedA /task1_tb/dut/ShiftedA
add wave -noupdate -label /increment /task1_tb/dut/increment
add wave -noupdate -label /preResult /task1_tb/dut/preResult
add wave -noupdate -label /result -radix unsigned -radixshowbase 0 /task1_tb/dut/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {250 ps}
