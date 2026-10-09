# 1. Create the work library
vlib work

# 2. Compile the RTL and Testbench
# Paths assume you are executing this script from inside the build/ directory
vlog ../rtd/fir_filter.v
vlog ../tb/fir_filter_tb.v

# 3. Start the simulation 
# -voptargs=+acc ensures signals are not optimized away so you can view them
vsim -voptargs=+acc work.fir_filter_tb

# 4. Configure Waveforms (Project Requirement)
# The spec requires analog format and signed decimal radix for the data signals
add wave -position insertpoint -color "blue" /fir_filter_tb/clk
add wave -position insertpoint -color "yellow" /fir_filter_tb/rst_n

# Format x_in as analog step
add wave -position insertpoint -radix decimal -format analog-step -height 74 -max 13000 -min -13000 -color "cyan" /fir_filter_tb/x_in

# Format y_out as analog step
add wave -position insertpoint -radix decimal -format analog-step -height 74 -max 13000 -min -13000 -color "magenta" /fir_filter_tb/y_out

add wave -position insertpoint -radix unsigned /fir_filter_tb/error_count

# 5. Run the simulation
run -all

# 6. Zoom full to see the whole waveform
wave zoom full