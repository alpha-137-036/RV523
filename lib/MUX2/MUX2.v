`include "../NOT/NOT.v"
`include "../AOI22/AOI22.v"

module MUX2(
    output Y,
    input I0,
    input I1,
    input S
);
    wire nS, nY;
    NOT notS(.A(S), .Y(nS));    
    AOI22 aoi(
        .A1(nS),
        .A2(I0),
        .B1(S),
        .B2(I1),
        .Y(nY)
    );
    NOT notY(.A(nY), .Y(Y));
endmodule