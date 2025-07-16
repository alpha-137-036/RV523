
// Elementary D-LATCH with complementary CLK enable inputs
module D_LATCH(
    output Q,
    output nQ,
    input D,
    input CLK,
    input nCLK
);
    supply1 VDD;
    supply0 GND;

    TINV NOT1(
        .A(D),
        .Y(nQ),
        .EN(CLK),
        .nEN(nCLK)
    );
    NOT NOT2(
        .A(nQ),
        .Y(Q)
    );
    TINV NOT3(
        .A(Q),
        .Y(nQ),
        .EN(nCLK),
        .nEN(CLK)
    );
endmodule