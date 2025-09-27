module AOI2111(
    output Y,
    input A1,
    input A2,
    input B1,
    input C1,
    input D1
);
    assign Y = ~((A1 & A2) | B1 | C1 | D1);
endmodule