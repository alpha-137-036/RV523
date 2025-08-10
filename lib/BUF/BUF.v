`include "../NOT/NOT.v"

module BUF(
    output Y,
    input A
);
    wire nA;
    NOT not1(
        .A(A),
        .Y(nA)
    );
    NOT not2(
        .A(nA),
        .Y(Y)
    );
endmodule