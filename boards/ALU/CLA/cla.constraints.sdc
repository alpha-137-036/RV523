
create_clock -period 1000.0 -name clk

set_input_delay 0.0 -clock clk [get_ports {A B op}]
set_output_delay 0.0 -clock clk [get_ports {AG LT LTU}]

set_load 100 AG
set_load 100 LT
set_load 100 LTU

