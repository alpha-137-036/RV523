module NOR3(
    output Y,
    input A,
    input B,
    input C
);
    supply1 VDD;
    supply0 GND;
    wire int1, int2;

    RV523_NMOS N1(
        .S(GND),
        .D(Y),
        .G(A)
    );
    RV523_NMOS N2(
        .S(GND),
        .D(Y),
        .G(B)
    );
    RV523_NMOS N3(
        .S(GND),
        .D(Y),
        .G(C)
    );
    RV523_PMOS P1(
        .S(int1),
        .D(Y),
        .G(A)
    );
    RV523_PMOS P2(
        .S(int2),
        .D(int1),
        .G(B)
    );
    RV523_PMOS P3(
        .S(VDD),
        .D(int2),
        .G(C)
    );
endmodule