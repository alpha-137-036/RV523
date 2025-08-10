module OAI31(
    output Y,
    input A1,
    input A2,
    input A3,
    input B
);
    assign Y = ~((A1 | A2 | A3) & B);
endmodule