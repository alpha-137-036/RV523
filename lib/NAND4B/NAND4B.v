`include "../NOT/NOT.v"
`include "../NAND4/NAND4.v"

module NAND4B(
    output Y,
    input A1_N,
    input A2,
    input A3,
    input A4
);
    wire A1;

    NOT not1(.A(A1_N), .Y(A1));

    NAND4 nand4(.A1(A1), .A2(A2), .A3(A3), .A4(A4), .Y(Y));
endmodule