# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./FIFO.sv"
vlog "./FIFO_ctrl.sv"
vlog "./seg7.sv"
vlog "./dpram.sv"
vlog "./Lab2Task3.sv"
vlog "./buttonCheck.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
# vsim -voptargs="+acc" -t 1ps -lib work Lab2Task2_tb
vsim -voptargs=\"+acc\" -t 1ps -lib work work.Lab2Task3_tb -Lf altera_mf_ver

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
