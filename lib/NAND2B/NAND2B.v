module NAND2B(
    output Y,
    input A_N,
    input B
);
    supply1 VDD;
    supply0 GND;
    wire A, sndA;

    RV523_NMOS N1(
        .S(GND),
        .D(A),
        .G(A_N)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(A),
        .G(A_N)
    );
    RV523_NMOS N2(
        .S(sndA),
        .D(Y),
        .G(A)
    );
    RV523_NMOS N3(
        .S(GND),
        .D(sndA),
        .G(B)
    );
    RV523_PMOS P2(
        .S(VDD),
        .D(Y),
        .G(A)
    );
    RV523_PMOS P3(
        .S(VDD),
        .D(Y),
        .G(B)
    );
endmodule