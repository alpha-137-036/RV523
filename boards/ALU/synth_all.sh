set -e
(cd Shifter; yosys shifter1.ys)
(cd Shifter; yosys shifter2.ys)
(cd CLA; yosys CLA.ys)
(cd ALU-Final; yosys alu_final.ys)
yosys ALU.ys