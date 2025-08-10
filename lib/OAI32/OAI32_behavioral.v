module OAI32(
    output Y,
    input A1,
    input A2,
    input A3,
    input B1,
    input B2
);
    assign Y = ~((A1 | A2 | A3) & (B1 | B2));
endmodule