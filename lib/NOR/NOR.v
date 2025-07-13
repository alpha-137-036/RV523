module NOR(
    output Y,
    input A,
    input B,
);
    supply1 VDD;
    supply0 GND;
    wire C;

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
    RV523_PMOS P1(
        .S(VDD),
        .D(C),
        .G(A)
    );
    RV523_PMOS P2(
        .S(C),
        .D(Y),
        .G(B)
    );
endmodule