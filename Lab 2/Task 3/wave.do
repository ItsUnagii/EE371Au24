onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Lab2Task3_tb/CLOCK_50
add wave -noupdate {/Lab2Task3_tb/SW[7]}
add wave -noupdate {/Lab2Task3_tb/SW[6]}
add wave -noupdate {/Lab2Task3_tb/SW[5]}
add wave -noupdate {/Lab2Task3_tb/SW[4]}
add wave -noupdate {/Lab2Task3_tb/SW[3]}
add wave -noupdate {/Lab2Task3_tb/SW[2]}
add wave -noupdate {/Lab2Task3_tb/SW[1]}
add wave -noupdate {/Lab2Task3_tb/SW[0]}
add wave -noupdate {/Lab2Task3_tb/KEY[3]}
add wave -noupdate {/Lab2Task3_tb/KEY[2]}
add wave -noupdate {/Lab2Task3_tb/KEY[0]}
add wave -noupdate {/Lab2Task3_tb/LEDR[9]}
add wave -noupdate {/Lab2Task3_tb/LEDR[8]}
add wave -noupdate /Lab2Task3_tb/HEX0
add wave -noupdate /Lab2Task3_tb/HEX1
add wave -noupdate /Lab2Task3_tb/HEX4
add wave -noupdate /Lab2Task3_tb/HEX5
add wave -noupdate -childformat {{{/Lab2Task3_tb/dut/main/register/array_reg[0]} -radix unsigned} {{/Lab2Task3_tb/dut/main/register/array_reg[1]} -radix unsigned} {{/Lab2Task3_tb/dut/main/register/array_reg[2]} -radix unsigned} {{/Lab2Task3_tb/dut/main/register/array_reg[3]} -radix unsigned} {{/Lab2Task3_tb/dut/main/register/array_reg[4]} -radix unsigned} {{/Lab2Task3_tb/dut/main/register/array_reg[5]} -radix unsigned} {{/Lab2Task3_tb/dut/main/register/array_reg[6]} -radix unsigned} {{/Lab2Task3_tb/dut/main/register/array_reg[7]} -radix unsigned}} -expand -subitemconfig {{/Lab2Task3_tb/dut/main/register/array_reg[0]} {-radix unsigned} {/Lab2Task3_tb/dut/main/register/array_reg[1]} {-radix unsigned} {/Lab2Task3_tb/dut/main/register/array_reg[2]} {-radix unsigned} {/Lab2Task3_tb/dut/main/register/array_reg[3]} {-radix unsigned} {/Lab2Task3_tb/dut/main/register/array_reg[4]} {-radix unsigned} {/Lab2Task3_tb/dut/main/register/array_reg[5]} {-radix unsigned} {/Lab2Task3_tb/dut/main/register/array_reg[6]} {-radix unsigned} {/Lab2Task3_tb/dut/main/register/array_reg[7]} {-radix unsigned}} /Lab2Task3_tb/dut/main/register/array_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {76 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 202
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
WaveRestoreZoom {0 ps} {900 ps}
