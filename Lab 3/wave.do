onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /line_drawer_tb/clk
add wave -noupdate /line_drawer_tb/reset
add wave -noupdate -radix decimal /line_drawer_tb/x0
add wave -noupdate -radix decimal /line_drawer_tb/x1
add wave -noupdate -radix decimal /line_drawer_tb/y0
add wave -noupdate -radix decimal /line_drawer_tb/y1
add wave -noupdate -radix decimal /line_drawer_tb/x
add wave -noupdate -radix decimal /line_drawer_tb/y
add wave -noupdate /line_drawer_tb/dut/error
add wave -noupdate /line_drawer_tb/dut/delta_x
add wave -noupdate /line_drawer_tb/dut/delta_y
add wave -noupdate /line_drawer_tb/dut/y_step
add wave -noupdate /line_drawer_tb/dut/is_steep
add wave -noupdate /line_drawer_tb/dut/x0s
add wave -noupdate /line_drawer_tb/dut/x1s
add wave -noupdate /line_drawer_tb/dut/y0s
add wave -noupdate /line_drawer_tb/dut/y1s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {615 ps} {1615 ps}
