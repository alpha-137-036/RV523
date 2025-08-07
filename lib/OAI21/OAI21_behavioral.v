module OAI21(
    output Y,
    input A,
    input B1,
    input B2
);
    assign Y = ~(A & (B1 | B2));
endmodule