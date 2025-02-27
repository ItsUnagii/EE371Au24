onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label reset /task2_tb/reset
add wave -noupdate -label clk /task2_tb/clk
add wave -noupdate -label start /task2_tb/start
add wave -noupdate -label found /task2_tb/found
add wave -noupdate -label done /task2_tb/done
add wave -noupdate -label A -radix unsigned -radixshowbase 0 /task2_tb/A
add wave -noupdate -label loc -radix unsigned -radixshowbase 0 /task2_tb/loc
add wave -noupdate -label /ps /task2_tb/dut/ps
add wave -noupdate -label /ns /task2_tb/dut/ns
add wave -noupdate -label /upper_bound -radix unsigned -radixshowbase 0 /task2_tb/dut/upper_bound
add wave -noupdate -label /lower_bound -radix unsigned -radixshowbase 0 /task2_tb/dut/lower_bound
add wave -noupdate -label /ub_next -radix unsigned -radixshowbase 0 /task2_tb/dut/ub_next
add wave -noupdate -label /lb_next -radix unsigned -radixshowbase 0 /task2_tb/dut/lb_next
add wave -noupdate -label /to_check -radix unsigned -radixshowbase 0 /task2_tb/dut/to_check
add wave -noupdate -label /data_out -radix unsigned -radixshowbase 0 /task2_tb/dut/data_out
add wave -noupdate -label /not_found /task2_tb/dut/not_found
add wave -noupdate -label /next_bounds /task2_tb/dut/next_bounds
add wave -noupdate -label /change_bounds /task2_tb/dut/change_bounds
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {237 ps} 0}
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
WaveRestoreZoom {0 ps} {2048 ps}
