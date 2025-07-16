
// Elementary D-LATCH with complementary EN inputs
module D_LATCH(
    output Q,
    output nQ,
    input D,
    input EN,
    input nEN
);
    supply1 VDD;
    supply0 GND;

    TINV NOT1(
        .A(D),
        .Y(nQ),
        .EN(EN),
        .nEN(nEN)
    );
    NOT NOT2(
        .A(nQ),
        .Y(Q)
    );
    TINV NOT3(
        .A(Q),
        .Y(nQ),
        .EN(nEN),
        .nEN(EN)
    );
endmodule