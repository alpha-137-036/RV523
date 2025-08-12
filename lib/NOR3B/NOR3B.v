`include "../NOR3/NOR3.v"
`include "../NOT/NOT.v"

module NOR3B(
    output Y,
    input A1,
    input A2,
    input A3_N
);
    wire A3;
    NOT not1(.A(A3_N), .Y(A3));
    NOR3 nor3(.A1(A1), .A2(A2), .A3(A3), .Y(Y));
endmodule