module NAND3(
    output Y,
    input A,
    input B,
    input C
);
    supply1 VDD;
    supply0 GND;
    wire int1, int2;

    NMOS N1(
        .S(GND),
        .D(int1),
        .G(A)
    );
    NMOS N2(
        .S(int1),
        .D(int2),
        .G(B)
    );
    NMOS N3(
        .S(int2),
        .D(Y),
        .G(C)
    );
    PMOS P1(
        .S(VDD),
        .D(Y),
        .G(A)
    );
    PMOS P2(
        .S(VDD),
        .D(Y),
        .G(B)
    );
    PMOS P3(
        .S(VDD),
        .D(Y),
        .G(C)
    );
endmodule