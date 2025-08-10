module OAI222(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2,
    input C1,
    input C2
);
    supply1 VDD;
    supply0 GND;
    wire intC, intNA, intNB, intNC, intPA, intPB, intPC;

    RV523_NMOS N1(
        .S(GND),
        .D(intNA),
        .G(A1)
    );
    RV523_NMOS N2(
        .S(GND),
        .D(intNA),
        .G(A2)
    );
    RV523_NMOS N3(
        .S(intNA),
        .D(intNB),
        .G(B1)
    );
    RV523_NMOS N4(
        .S(intNA),
        .D(intNB),
        .G(B2)
    );
    RV523_NMOS N5(
        .S(intNB),
        .D(Y),
        .G(C1)
    );
    RV523_NMOS N6(
        .S(intNB),
        .D(Y),
        .G(C2)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(intPA),
        .G(A1)
    );
    RV523_PMOS P2(
        .S(intPA),
        .D(Y),
        .G(A2)
    );
    RV523_PMOS P3(
        .S(VDD),
        .D(intPB),
        .G(B1)
    );
    RV523_PMOS P4(
        .S(intPB),
        .D(Y),
        .G(B2)
    );
    RV523_PMOS P5(
        .S(VDD),
        .D(intPC),
        .G(C1)
    );
    RV523_PMOS P6(
        .S(intPC),
        .D(Y),
        .G(C2)
    );
endmodule