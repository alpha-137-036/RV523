#!/usr/bin/bash
set -e
iverilog -g2012 -s CPU_tb ../rtl/IF.sv ../rtl/ID.sv ../rtl/CPU.sv CodeROM.sv CPU_tb.sv -o CPU_tb
vvp -n CPU_tb