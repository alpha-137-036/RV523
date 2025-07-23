module NAND4(
    output Y,
    input A1,
    input A2,
    input A3,
    input A4
);
    supply1 VDD;
    supply0 GND;
    wire int1, int2, int3;

    RV523_NMOS N1(
        .S(GND),
        .D(int1),
        .G(A1)
    );
    RV523_NMOS N2(
        .S(int1),
        .D(int2),
        .G(A2)
    );
    RV523_NMOS N3(
        .S(int2),
        .D(int3),
        .G(A3)
    );
    RV523_NMOS N4(
        .S(int3),
        .D(Y),
        .G(A4)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(Y),
        .G(A1)
    );
    RV523_PMOS P2(
        .S(VDD),
        .D(Y),
        .G(A2)
    );
    RV523_PMOS P3(
        .S(VDD),
        .D(Y),
        .G(A3)
    );
    RV523_PMOS P4(
        .S(VDD),
        .D(Y),
        .G(A4)
    );
endmodule