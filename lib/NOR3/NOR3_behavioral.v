module NOR3(
    output Y,
    input A1,
    input A2,
    input A3
);
    assign Y = ~(A1 | A2 | A3);
endmodule