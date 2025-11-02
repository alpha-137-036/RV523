
create_clock -period 1000.0 -name clk

set_input_delay 0.0 -clock clk [get_ports {A B B_N}]
set_output_delay 0.0 -clock clk [get_ports {Y}]

set_load 100 Y

