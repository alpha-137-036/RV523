module AOI2111(
    output Y,
    input A1,
    input A2,
    input B1,
    input C1,
    input D1
);
    supply1 VDD;
    supply0 GND;
    wire sndA1, pndA, pndB, pndC;

    RV523_NMOS N1(
        .S(GND),
        .D(sndA1),
        .G(A1)
    );
    RV523_NMOS N2(
        .S(sndA1),
        .D(Y),
        .G(A2)
    );
    RV523_NMOS N3(
        .S(GND),
        .D(Y),
        .G(B1)
    );
    RV523_NMOS N4(
        .S(GND),
        .D(Y),
        .G(C1)
    );
    RV523_NMOS N5(
        .S(GND),
        .D(Y),
        .G(D1)
    );

    RV523_PMOS P1(
        .S(VDD),
        .D(pndA),
        .G(A1)
    );
    RV523_PMOS P2(
        .S(VDD),
        .D(pndA),
        .G(A2)
    );
    RV523_PMOS P3(
        .S(pndA),
        .D(pndB),
        .G(B1)
    );
    RV523_PMOS P4(
        .S(pndB),
        .D(pndC),
        .G(C1)
    );
    RV523_PMOS P5(
        .S(pndC),
        .D(Y),
        .G(D1)
    );
endmodule