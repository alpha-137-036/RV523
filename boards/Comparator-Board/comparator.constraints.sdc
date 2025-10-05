
create_clock -period 1000.0 -name clk

set_input_delay 0.0 -clock clk [get_ports {A B U}]
set_output_delay 0.0 -clock clk [get_ports {EQ LT}]

set_load 100 EQ
set_load 100 LT

