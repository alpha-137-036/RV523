`include "../NOR3/NOR3.v"
`include "../NOT/NOT.v"

module OR3(
    output Y,
    input A1,
    input A2,
    input A3
);
    wire nY;
    NOR3 nor1(.A1(A1), .A2(A2), .A3(A3), .Y(nY));
    NOT not1(.A(nY), .Y(Y));
endmodule