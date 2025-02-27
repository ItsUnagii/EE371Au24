onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /task2_top_tb/CLOCK_50
add wave -noupdate -label {KEY3 (Start)} {/task2_top_tb/KEY[3]}
add wave -noupdate -label {KEY0 (Reset)} {/task2_top_tb/KEY[0]}
add wave -noupdate -label SW -expand /task2_top_tb/SW
add wave -noupdate -label hex0 /task2_top_tb/HEX0
add wave -noupdate -label hex1 /task2_top_tb/HEX1
add wave -noupdate -label {ledr9 (Done)} {/task2_top_tb/LEDR[9]}
add wave -noupdate -label {ledr0 (found Task 2)} {/task2_top_tb/LEDR[0]}
add wave -noupdate -label {result (Task 1)} /task2_top_tb/task2/taskDisp/result
add wave -noupdate -label {loc (Task 2)} -radix unsigned -radixshowbase 0 /task2_top_tb/task2/taskDisp2/loc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2696 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 251
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
WaveRestoreZoom {0 ps} {3855 ps}
