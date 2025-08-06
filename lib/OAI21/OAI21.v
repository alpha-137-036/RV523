module OAI21(
    output Y,
    input A,
    input B1,
    input B2
);
    supply1 VDD;
    supply0 GND;
    wire intB, intN;

    RV523_NMOS N1(
        .S(GND),
        .D(intN),
        .G(A)
    );
    RV523_NMOS N2(
        .S(intN),
        .D(Y),
        .G(B1)
    );
    RV523_NMOS N3(
        .S(intN),
        .D(Y),
        .G(B2)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(Y),
        .G(A)
    );
    RV523_PMOS P2(
        .S(VDD),
        .D(intB),
        .G(B1)
    );
    RV523_PMOS P3(
        .S(intB),
        .D(Y),
        .G(B2)
    );
endmodule