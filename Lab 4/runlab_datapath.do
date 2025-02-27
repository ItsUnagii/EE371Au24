
# Create work library
vlib work


# Compile Verilog
#  - All Verilog files that are part of this design should have
#    their own "vlog" line below.
vlog "./task2.sv"
vlog "./task2_datapath.sv"
vlog "./task2_control.sv"
vlog "./De1SoC.sv"
vlog "./ram32x8.v"
vlog "./seg7.sv"

# Call vsim to invoke simulator
#  - Make sure the last item on the line is the correct name of
#    the testbench module you want to execute.
#  - If you need the altera_mf_ver library, add "-Lf altera_mf_lib"
#    (no quotes) to the end of the vsim command
vsim -voptargs="+acc" -t 1ps -lib work datapath_tb -Lf altera_mf_ver


# Source the wave do file
#  - This should be the file that sets up the signal window for
#    the module you are testing.
do datawave.do


# Set the window types
view wave
view structure
view signals


# Run the simulation
run -all


# End
