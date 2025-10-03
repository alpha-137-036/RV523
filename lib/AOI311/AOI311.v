module AOI311(
    output Y,
    input A1,
    input A2,
    input A3,
    input B1,
    input C1
);
    supply1 VDD;
    supply0 GND;
    wire intA1, intA2, intPA, intPB;

    RV523_NMOS N1(
        .S(GND),
        .D(intA1),
        .G(A1)
    );
    RV523_NMOS N2(
        .S(intA1),
        .D(intA2),
        .G(A2)
    );
    RV523_NMOS N3(
        .S(intA2),
        .D(Y),
        .G(A3)
    );
    RV523_NMOS N4(
        .S(GND),
        .D(Y),
        .G(B1)
    );
    RV523_NMOS N5(
        .S(GND),
        .D(Y),
        .G(C1)
    );
    RV523_PMOS P1(
        .S(intPA),
        .D(Y),
        .G(A1)
    );
    RV523_PMOS P2(
        .S(intPA),
        .D(Y),
        .G(A2)
    );
    RV523_PMOS P3(
        .S(intPA),
        .D(Y),
        .G(A3)
    );
    RV523_PMOS P4(
        .S(intPB),
        .D(intPA),
        .G(B1)
    );
    RV523_PMOS P5(
        .S(VDD),
        .D(intPB),
        .G(C1)
    );
endmodule