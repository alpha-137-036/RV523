module AOI21(
    output Y,
    input A1,
    input A2,
    input B1
);
    assign Y = ~((A1 & A2) | B1);
endmodule