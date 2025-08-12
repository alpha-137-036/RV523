module NOR3B(
    output Y,
    input A1,
    input A2,
    input A3_N
);
    assign Y = ~(A1 | A2 | (~A3_N));
endmodule