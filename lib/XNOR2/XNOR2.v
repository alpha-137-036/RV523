`include "../NOT/NOT.v"
`include "../AOI22/AOI22.v"

module XNOR2(
    output Y,
    input A,
    input B
);
    wire nA, nB;
    NOT notA(.A(A), .Y(nA));    
    NOT notB(.A(B), .Y(nB));
    AOI22 aoi(
        .A1(A),
        .A2(nB),
        .B1(nA),
        .B2(B),
        .Y(Y)
    );
endmodule