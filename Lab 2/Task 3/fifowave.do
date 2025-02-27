onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /FIFO_tb/clk
add wave -noupdate /FIFO_tb/reset
add wave -noupdate /FIFO_tb/read
add wave -noupdate /FIFO_tb/write
add wave -noupdate -radix unsigned /FIFO_tb/inputBus
add wave -noupdate /FIFO_tb/empty
add wave -noupdate /FIFO_tb/full
add wave -noupdate -radix unsigned /FIFO_tb/outputBus
add wave -noupdate -childformat {{{/FIFO_tb/dut/register/array_reg[0]} -radix unsigned} {{/FIFO_tb/dut/register/array_reg[1]} -radix unsigned} {{/FIFO_tb/dut/register/array_reg[2]} -radix unsigned} {{/FIFO_tb/dut/register/array_reg[3]} -radix unsigned} {{/FIFO_tb/dut/register/array_reg[4]} -radix unsigned} {{/FIFO_tb/dut/register/array_reg[5]} -radix unsigned} {{/FIFO_tb/dut/register/array_reg[6]} -radix unsigned} {{/FIFO_tb/dut/register/array_reg[7]} -radix unsigned}} -expand -subitemconfig {{/FIFO_tb/dut/register/array_reg[0]} {-radix unsigned} {/FIFO_tb/dut/register/array_reg[1]} {-radix unsigned} {/FIFO_tb/dut/register/array_reg[2]} {-radix unsigned} {/FIFO_tb/dut/register/array_reg[3]} {-radix unsigned} {/FIFO_tb/dut/register/array_reg[4]} {-radix unsigned} {/FIFO_tb/dut/register/array_reg[5]} {-radix unsigned} {/FIFO_tb/dut/register/array_reg[6]} {-radix unsigned} {/FIFO_tb/dut/register/array_reg[7]} {-radix unsigned}} /FIFO_tb/dut/register/array_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8562 ps} 0}
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
WaveRestoreZoom {1850 ps} {9850 ps}
