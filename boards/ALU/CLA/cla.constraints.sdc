
create_clock -period 1000.0 -name clk

set_input_delay 0.0 -clock clk [get_ports {A B op}]
set_output_delay 0.0 -clock clk [get_ports {A BG G31}]

set_load 100 A
set_load 100 BG
set_load 100 G31

