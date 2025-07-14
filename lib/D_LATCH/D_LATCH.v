// Tristate inverter
module TristateInverter(
    output Y,
    input  A,
    input  EN,
    input  nEN
);
    supply1 VDD;
    supply0 GND;
    wire intN, intP;
    RV523_NMOS N1(
        .S(GND),
        .G(A),
        .D(intN),
    );
    RV523_NMOS N2(
        .S(intN),
        .G(EN),
        .D(Y),
    );
    RV523_PMOS P1(
        .S(VDD),
        .G(A),
        .D(intP),
    );
    RV523_PMOS P2(
        .S(intP),
        .G(nEN),
        .D(Y),
    );
endmodule


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

    TristateInverter NOT1(
        .A(D),
        .Y(nQ),
        .EN(EN),
        .nEN(nEN)
    );
    NOT NOT2(
        .A(nQ),
        .Y(Q)
    );
    TristateInverter NOT3(
        .A(Q),
        .Y(nQ),
        .EN(nEN),
        .nEN(EN)
    );
endmodule