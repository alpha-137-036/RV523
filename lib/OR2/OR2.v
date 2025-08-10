`include "../NOR2/NOR2.v"
`include "../NOT/NOT.v"

module OR2(
    output Y,
    input A1,
    input A2
);
    wire nY;
    NOR2 nor1(.A1(A1), .A2(A2), .Y(nY));
    NOT not1(.A(nY), .Y(Y));
endmodule