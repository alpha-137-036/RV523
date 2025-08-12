`include "../NOT/NOT.v"
`include "../AOI222/AOI222.v"

module MAJ3(
    output Y,
    input A1,
    input A2,
    input A3
);
    wire Y_N;
    AOI222 aoi(.A1(A1), .A2(A2), .B1(A2), .B2(A3), .C1(A3), .C2(A1), .Y(Y_N));
    NOT notY(.A(Y_N), .Y(Y));
endmodule