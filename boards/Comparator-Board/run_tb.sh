set -E
mkdir -p iverilog
iverilog -g2012 -o iverilog/comparator_tb.vvp -s comparator_tb ../../lib/RV523_behavioral.v comparator.netlist.v comparator_tb.sv 
vvp iverilog/comparator_tb.vvp
