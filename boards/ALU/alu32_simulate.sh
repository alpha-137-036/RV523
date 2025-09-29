set -e
iverilog -g2012 -s alu32_tb -o alu32_tb alu_typedefs.sv alu32_tb.sv alu32.sv alu8.sv
vvp alu32_tb