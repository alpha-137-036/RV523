`include "../NAND4/NAND4.v"
`include "../NOT/NOT.v"

module AND4(
    output Y,
    input A1,
    input A2,
    input A3,
    input A4
);
    wire nY;
    NAND4 nand1(.A1(A1), .A2(A2), .A3(A3), .A4(A4), .Y(nY));
    NOT not1(.A(nY), .Y(Y));
endmodule