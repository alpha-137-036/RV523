set -E
mkdir -p iverilog
iverilog -g2012 -o iverilog/ALU_tb.vvp -s ALU_tb ../../lib/RV523_behavioral.v alu_typedefs.sv ALU_tb.sv ALU.sv Shifter/shifter1.netlist.v Shifter/shifter2.netlist.v CLA/cla.netlist.v ALU-Final/alu_final.netlist.v 
vvp iverilog/ALU_tb.vvp
