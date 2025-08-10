module MUX2(
    output Y,
    input I0,
    input I1,
    input S
);
    assign Y = S ? I0 : I1;
endmodule