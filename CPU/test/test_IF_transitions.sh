#!/usr/bin/bash
set -e
iverilog -g2012 -DTRACING -s IF_transitions_tb ../rtl/IF_transitions.sv IF_transitions_tb.sv -o IF_transitions_tb
vvp -n IF_transitions_tb