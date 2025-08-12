module NAND4B(
    output Y,
    input A1_N,
    input A2,
    input A3,
    input A4
);
    assign Y = ~((~A1_N) & A2 & A3 & A4);
endmodule