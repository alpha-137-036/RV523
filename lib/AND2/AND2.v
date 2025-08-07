`include "../NAND2/NAND2.v"
`include "../NOT/NOT.v"

module AND2(
    output Y,
    input A1,
    input A2
);
    wire nY;
    NAND2 nand1(.A1(A1), .A2(A2), .Y(nY));
    NOT not1(.A(nY), .Y(Y));
endmodule