iverilog -g2012 -s CPU_tb ../rtl/CPU_Parameters.sv ../rtl/CodeROM.sv ../rtl/IF.sv ../rtl/ID.sv ../rtl/CPU.sv ../rtl/CPU_tb.sv -o CPU_tb
vvp -n CPU_tb