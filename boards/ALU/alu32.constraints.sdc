
create_clock -period 1000.0 -name clk

set_input_delay 2.0 -clock clk [get_ports {A B}]
set_output_delay 2.0 -clock clk [get_ports {S nCout}]

set_load 100 S
set_load 100 nCout

