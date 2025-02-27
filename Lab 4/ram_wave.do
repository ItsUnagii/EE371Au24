onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /ram_tb/clock
add wave -noupdate -label data /ram_tb/data
add wave -noupdate -label wren /ram_tb/wren
add wave -noupdate -label address /ram_tb/address
add wave -noupdate -label q /ram_tb/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {1 ns}
