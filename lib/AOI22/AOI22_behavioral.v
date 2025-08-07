module AOI22(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2
);
    assign Y = ~((A1 & A2) | (B1 & B2));
endmodule