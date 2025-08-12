module NAND2B(
    output Y,
    input A_N,
    input B
);
    assign Y = ~( ~A_N & B);
endmodule