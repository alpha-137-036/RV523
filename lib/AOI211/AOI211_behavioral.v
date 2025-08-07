module AOI211(
    output Y,
    input A,
    input B,
    input C1,
    input C2
);
    assign Y = ~(A | B | (C1 & C2));
endmodule