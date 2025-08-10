module OAI33(
    output Y,
    input A1,
    input A2,
    input A3,
    input B1,
    input B2,
    input B3
);
    supply1 VDD;
    supply0 GND;
    wire intN, intPA1, intPA2, intPB1, intPB2;

    RV523_NMOS N1(
        .S(GND),
        .D(intN),
        .G(A1)
    );
    RV523_NMOS N2(
        .S(GND),
        .D(intN),
        .G(A2)
    );
    RV523_NMOS N3(
        .S(GND),
        .D(intN),
        .G(A3)
    );
    RV523_NMOS N4(
        .S(intN),
        .D(Y),
        .G(B1)
    );
    RV523_NMOS N5(
        .S(intN),
        .D(Y),
        .G(B2)
    );
    RV523_NMOS N6(
        .S(intN),
        .D(Y),
        .G(B3)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(intPA1),
        .G(A1)
    );
    RV523_PMOS P2(
        .S(intPA1),
        .D(intPA2),
        .G(A2)
    );
    RV523_PMOS P3(
        .S(intPA2),
        .D(Y),
        .G(A3)
    );
    RV523_PMOS P4(
        .S(VDD),
        .D(intPB1),
        .G(B1)
    );
    RV523_PMOS P5(
        .S(intPB1),
        .D(intPB2),
        .G(B2)
    );
    RV523_PMOS P6(
        .S(intPB2),
        .D(Y),
        .G(B3)
    );
endmodule