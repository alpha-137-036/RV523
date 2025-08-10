module AOI221(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2,
    input C
);
    supply1 VDD;
    supply0 GND;
    wire intA, intB, intP, intQ;

    RV523_NMOS N1(
        .S(GND),
        .D(intA),
        .G(A1)
    );
    RV523_NMOS N2(
        .S(intA),
        .D(Y),
        .G(A2)
    );
    RV523_NMOS N3(
        .S(GND),
        .D(intB),
        .G(B1)
    );
    RV523_NMOS N4(
        .S(intB),
        .D(Y),
        .G(B2)
    );
    RV523_NMOS N5(
        .S(GND),
        .D(Y),
        .G(C)
    );
    RV523_PMOS P1(
        .S(intP),
        .D(Y),
        .G(A1)
    );
    RV523_PMOS P2(
        .S(intP),
        .D(Y),
        .G(A2)
    );
    RV523_PMOS P3(
        .S(intQ),
        .D(intP),
        .G(B1)
    );
    RV523_PMOS P4(
        .S(intQ),
        .D(intP),
        .G(B2)
    );
    RV523_PMOS P5(
        .S(VDD),
        .D(intQ),
        .G(C)
    );
endmodule