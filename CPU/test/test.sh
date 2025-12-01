#!/usr/bin/bash
set -e
iverilog -g2012 -DTRACING -s CPU_tb ../rtl/opcodes.svh ../rtl/Disassembler.sv ../rtl/IF.sv ../rtl/Regs.sv  ../rtl/ALU.svh ../rtl/ID.sv ../rtl/EX.sv ../rtl/ALU.sv ../rtl/MEM.sv ../rtl/WB.sv ../rtl/CPU.sv CPU_tb.sv -o CPU_tb
vvp -n CPU_tb +CODEHEX=sw/build/test_fibonacci.hex +RODATAHEX=sw/build/test_fibonacci-rodata.hex +OUTFILE=output.txt